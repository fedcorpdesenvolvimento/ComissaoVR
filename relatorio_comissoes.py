"""Geracao de pre-vouchers e relatorio de comissoes de VR."""

from __future__ import annotations

import csv
import os
import tkinter as tk
from datetime import date, datetime
from decimal import Decimal
from pathlib import Path
from tkinter import filedialog, messagebox, ttk
from typing import Any

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_RIGHT
from reportlab.lib.pagesizes import A4, landscape
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import mm
from reportlab.platypus import (
    Paragraph,
    PageBreak,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)
from tkcalendar import DateEntry

from database import open_connection


class RelatorioComissoesWindow(tk.Toplevel):
    """Reproduz o fluxo de geracao automatica do formulario Delphi."""

    def __init__(self, parent: tk.Misc) -> None:
        super().__init__(parent)
        self.title("Geracao de Comissao Automatica")
        self.geometry("1280x650")
        self.minsize(1050, 550)
        self.transient(parent)
        self.connection = None
        self.administradoras: dict[str, str] = {}
        self.produtores: dict[str, str] = {}
        self.rows: list[tuple[Any, ...]] = []
        self.report_rows: list[tuple[Any, ...]] = []

        self.administradora = tk.StringVar()
        self.produtor = tk.StringVar()
        self.vigencia = tk.StringVar()
        self.status = tk.StringVar(value="Conectando ao Firebird...")
        self._create_widgets()
        self._load_filters()
        self.protocol("WM_DELETE_WINDOW", self._close)

    def _create_widgets(self) -> None:
        root = ttk.Frame(self, padding=10)
        root.pack(fill=tk.BOTH, expand=True)

        filters = ttk.LabelFrame(root, text="Parametros")
        filters.pack(fill=tk.X, pady=(0, 8))
        ttk.Label(filters, text="Administradora:").grid(
            row=0, column=0, padx=8, pady=6, sticky=tk.W
        )
        self.admin_combo = ttk.Combobox(
            filters, textvariable=self.administradora, state="readonly", width=58
        )
        self.admin_combo.grid(row=0, column=1, padx=8, pady=6, sticky=tk.W)
        self.admin_combo.bind("<<ComboboxSelected>>", self._load_producers)

        ttk.Label(filters, text="Produtor:").grid(
            row=1, column=0, padx=8, pady=6, sticky=tk.W
        )
        self.producer_combo = ttk.Combobox(
            filters, textvariable=self.produtor, state="readonly", width=58
        )
        self.producer_combo.grid(row=1, column=1, padx=8, pady=6, sticky=tk.W)

        ttk.Label(filters, text="Vigencia (dd/mm/aaaa):").grid(
            row=2, column=0, padx=8, pady=6, sticky=tk.W
        )
        self.date_entry = DateEntry(
            filters,
            textvariable=self.vigencia,
            width=18,
            date_pattern="dd/mm/yyyy",
            locale="pt_BR",
            state="readonly",
        )
        self.date_entry.grid(
            row=2, column=1, padx=8, pady=6, sticky=tk.W
        )
        self.date_entry.bind("<<DateEntrySelected>>", self._on_date_selected)
        ttk.Button(
            filters,
            text="Hoje",
            command=lambda: self.vigencia.set(date.today().strftime("%d/%m/%Y")),
        ).grid(row=2, column=2, padx=4, pady=6, sticky=tk.W)

        actions = ttk.Frame(root)
        actions.pack(fill=tk.X, pady=(0, 8))
        ttk.Button(
            actions,
            text="Relatorio de Previa",
            command=self.generate_preview,
        ).pack(side=tk.LEFT, padx=(0, 8))
        ttk.Button(
            actions,
            text="Emissao de Voucher",
            command=self.emit_voucher,
        ).pack(side=tk.LEFT, padx=8)
        ttk.Button(
            actions,
            text="Exportar relatorio CSV",
            command=self.export_csv,
        ).pack(side=tk.LEFT, padx=8)
        ttk.Button(actions, text="Limpa", command=self.clear).pack(
            side=tk.LEFT, padx=8
        )
        ttk.Button(actions, text="Sair", command=self._close).pack(side=tk.RIGHT)

        report = ttk.LabelFrame(root, text="Relatorio de comissoes")
        report.pack(fill=tk.BOTH, expand=True)
        columns = (
            "controle",
            "recibo",
            "vigencia",
            "administradora",
            "produtor",
            "produto",
            "percentual",
            "desconto",
            "bruto",
            "taxas",
            "comissao",
            "status",
            "nome_adm",
            "nome_produtor",
            "beneficios",
        )
        grid_style = ttk.Style(self)
        grid_style.configure(
            "Commission.Treeview",
            rowheight=24,
            borderwidth=1,
            relief="solid",
            fieldbackground="white",
            background="white",
        )
        grid_style.configure(
            "Commission.Treeview.Heading",
            font=("Segoe UI", 9, "bold"),
            padding=(5, 5),
        )
        self.grid = ttk.Treeview(
            report,
            columns=columns,
            show="headings",
            style="Commission.Treeview",
            selectmode="browse",
        )
        self.grid.tag_configure("even", background="#FFFFFF")
        self.grid.tag_configure("odd", background="#F2F6FA")
        self.grid.tag_configure(
            "group",
            background="#D9EAF7",
            foreground="#1F4E79",
            font=("Segoe UI", 9, "bold"),
        )
        self.grid.tag_configure(
            "subtotal",
            background="#E2F0D9",
            foreground="#1F1F1F",
            font=("Segoe UI", 9, "bold"),
        )
        headings = {
            "controle": "Controle",
            "recibo": "Recibo",
            "vigencia": "Vigencia",
            "administradora": "Administradora",
            "produtor": "Produtor",
            "produto": "Produto",
            "percentual": "% Com.",
            "desconto": "% Desc.",
            "bruto": "Valor de carga",
            "taxas": "Taxas",
            "comissao": "Comissao",
            "status": "Status",
            "nome_adm": "Nome administradora",
            "nome_produtor": "Nome produtor",
            "beneficios": "Beneficios",
        }
        widths = {
            "controle": 70,
            "recibo": 60,
            "vigencia": 90,
            "administradora": 210,
            "produtor": 210,
            "produto": 180,
            "percentual": 70,
            "desconto": 70,
            "bruto": 95,
            "taxas": 95,
            "comissao": 95,
            "status": 65,
            "nome_adm": 210,
            "nome_produtor": 210,
            "beneficios": 80,
        }
        for column in columns:
            self.grid.heading(column, text=headings[column])
            self.grid.column(column, width=widths[column], anchor=tk.W)
        scrollbar = ttk.Scrollbar(report, orient=tk.VERTICAL, command=self.grid.yview)
        self.grid.configure(yscrollcommand=scrollbar.set)
        self.grid.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        ttk.Label(root, textvariable=self.status).pack(anchor=tk.W, pady=(5, 0))

    def _load_filters(self) -> None:
        try:
            self.connection = open_connection()
            cursor = self.connection.cursor()
            cursor.execute(
                "SELECT APO.ADMINISTRADORA, PES.NOME "
                "FROM APOLICES APO LEFT JOIN PESSOAS PES "
                "ON PES.PESSOA = APO.ADMINISTRADORA "
                "WHERE APO.APOLICE LIKE '%VR%' AND PES.NOME <> '' "
                "AND APO.STATUS = 'A' GROUP BY APO.ADMINISTRADORA, PES.NOME "
                "ORDER BY PES.NOME"
            )
            self.administradoras = {
                str(row[1]): str(row[0]) for row in cursor.fetchall() if row[1]
            }
            self.admin_combo["values"] = list(self.administradoras)
            self.status.set("Conectado ao Firebird")
        except Exception as exc:
            self.status.set("Falha na conexao com o Firebird")
            messagebox.showerror("Conexao", str(exc), parent=self)

    def _load_producers(self, _event: tk.Event[tk.Misc] | None = None) -> None:
        if self.connection is None:
            return
        admin = self.administradoras.get(self.administradora.get())
        if not admin:
            return
        cursor = self.connection.cursor()
        cursor.execute(
            "SELECT DISTINCT P.PESSOA, P.NOME FROM APOLICES APO "
            "JOIN PESSOAS P ON P.PESSOA IN (APO.FAVOR, APO.FAVOR2) "
            "WHERE APO.ADMINISTRADORA = ? AND APO.APOLICE LIKE '%VR%' "
            "AND APO.STATUS = 'A' AND P.STATUS = 'A' AND P.NOME <> '' "
            "ORDER BY P.NOME",
            (admin,),
        )
        self.produtores = {
            str(row[1]): str(row[0]) for row in cursor.fetchall() if row[1]
        }
        self.producer_combo["values"] = list(self.produtores)
        self.produtor.set("")

    def _parse_date(self) -> date:
        try:
            return datetime.strptime(self.vigencia.get().strip(), "%d/%m/%Y").date()
        except ValueError as exc:
            raise ValueError("Informe a vigencia no formato dd/mm/aaaa.") from exc

    def _validate_date(self) -> bool:
        value = self.vigencia.get().strip()
        if not value:
            return True
        try:
            self._parse_date()
        except ValueError:
            self.status.set("Vigencia invalida: use dd/mm/aaaa")
            return False
        self.status.set("Data de vigencia valida")
        return True

    def _on_date_selected(self, _event: tk.Event[tk.Misc]) -> None:
        self.vigencia.set(self.date_entry.get())
        self.status.set("Data de vigencia selecionada")

    def generate_preview(self) -> None:
        if self.connection is None:
            messagebox.showerror("Comissoes", "Nao ha conexao com o Firebird.", parent=self)
            return
        try:
            reference_date = self._parse_date()
        except ValueError as exc:
            messagebox.showwarning("Comissoes", str(exc), parent=self)
            return
        admin = self.administradoras.get(self.administradora.get())
        producer = self.produtores.get(self.produtor.get())
        try:
            self._delete_pending(reference_date, admin, producer)
            generated = self._generate_receipts(reference_date, admin, producer)
            self.connection.commit()
            self._load_report(reference_date, admin, producer)
            self.status.set(f"{generated} pre-voucher(s) gerado(s).")
            if self.rows:
                self._save_preview_pdf(reference_date)
        except Exception as exc:
            self.connection.rollback()
            messagebox.showerror("Geracao de comissao", str(exc), parent=self)

    def _delete_pending(
        self, reference_date: date, admin: str | None, producer: str | None
    ) -> None:
        query = (
            "DELETE FROM RECIBOS_COMISSAO_VR "
            "WHERE INI_VIGENCIA = ? AND NUM_RECIBO = 0"
        )
        parameters: list[Any] = [reference_date]
        if admin:
            query += " AND ADMINISTRADORA = ?"
            parameters.append(admin)
        if producer:
            query += " AND PRODUTOR = ?"
            parameters.append(producer)
        self.connection.cursor().execute(query, tuple(parameters))

    def _generate_receipts(
        self, reference_date: date, admin: str | None, producer: str | None
    ) -> int:
        query = (
            "SELECT IV.ADMINISTRADORA, IV.PRODUTO, NPV.CONTA, "
            "TCA.PRODUTOR, TCA.PERC_COM, TCA.PERC_DESC, "
            "TCA.SOBRE_TAXA, TCA.APENAS_COND_TAXA, "
            "COUNT(*), COALESCE(SUM(IV.TARIFA), 0), "
            "COALESCE(SUM(IV.TARIFA * IV.TAXA / 100), 0) "
            "FROM IMPORTA_VR IV "
            "JOIN NOMES_PRODUTOS_VR NPV ON NPV.NOME_PRODUTO = IV.PRODUTO "
            "JOIN TAB_COMISSAO_ADM_VR TCA ON TCA.ADMINISTRADORA = IV.ADMINISTRADORA "
            "AND TCA.CONTA = NPV.CONTA AND TCA.STATUS = 'A' "
            "WHERE IV.DT_INI_USO = ? AND IV.STATUS <> 'C' "
            "AND (TCA.APENAS_COND_TAXA = 'N' OR IV.TAXA > 0) "
        )
        parameters: list[Any] = [reference_date]
        if admin:
            query += "AND IV.ADMINISTRADORA = ? "
            parameters.append(admin)
        if producer:
            query += "AND TCA.PRODUTOR = ? "
            parameters.append(producer)
        query += (
            "GROUP BY IV.ADMINISTRADORA, IV.PRODUTO, NPV.CONTA, "
            "TCA.PRODUTOR, TCA.PERC_COM, TCA.PERC_DESC, "
            "TCA.SOBRE_TAXA, TCA.APENAS_COND_TAXA"
        )
        cursor = self.connection.cursor()
        cursor.execute(query, tuple(parameters))
        generated = 0
        insert = self.connection.cursor()
        for row in cursor.fetchall():
            (
                administrator,
                _product_name,
                account,
                producer_id,
                commission_rate,
                discount_rate,
                sobre_taxa,
                apenas_cond_taxa,
                _benefits,
                gross_value,
                total_tax,
            ) = row
            base = Decimal(str(total_tax or 0)) if sobre_taxa == "S" else Decimal(
                str(gross_value or 0)
            )
            commission = base * Decimal(str(commission_rate or 0)) / Decimal("100")
            discount = commission * Decimal(str(discount_rate or 0)) / Decimal("100")
            commission -= discount
            generator = self.connection.cursor()
            generator.execute(
                "SELECT GEN_ID(GEN_RECIBO_COMISSAO_VR, 1) FROM RDB$DATABASE"
            )
            control = generator.fetchone()[0]
            insert.execute(
                "INSERT INTO RECIBOS_COMISSAO_VR "
                "(CONTROLE_REC, NUM_RECIBO, DT_EMI_RECIBO, INI_VIGENCIA, "
                "ADMINISTRADORA, PRODUTOR, CONTA, PERC_COM, DESC_COM, "
                "VALOR_BRUTO, VALOR_TOT_TAXA, VALOR_COM, "
                "USU_EMI_RECIBO, STATUS) "
                "VALUES (?, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, '', 'A')",
                (
                    control,
                    date.today(),
                    reference_date,
                    administrator,
                    producer_id,
                    account,
                    commission_rate,
                    discount_rate,
                    total_tax if sobre_taxa == "S" else gross_value,
                    total_tax,
                    commission,
                ),
            )
            generated += 1
        return generated

    def _load_report(
        self, reference_date: date, admin: str | None, producer: str | None
    ) -> None:
        query = (
            "SELECT RCV.CONTROLE_REC, RCV.NUM_RECIBO, RCV.INI_VIGENCIA, "
            "RCV.ADMINISTRADORA, RCV.PRODUTOR, NPV.NOME_PRODUTO, "
            "RCV.PERC_COM, RCV.DESC_COM, RCV.VALOR_BRUTO, "
            "COALESCE(RCV.VALOR_TOT_TAXA, 0), RCV.VALOR_COM, RCV.STATUS, "
            "PA.NOME, PP.NOME "
            ", (SELECT COUNT(*) FROM IMPORTA_VR IVB "
            "WHERE IVB.ADMINISTRADORA = RCV.ADMINISTRADORA "
            "AND IVB.PRODUTO = NPV.NOME_PRODUTO "
            "AND IVB.DT_INI_USO = RCV.INI_VIGENCIA "
            "AND IVB.STATUS <> 'C') BENEFICIOS, "
            "(SELECT COALESCE(SUM(IVC.TARIFA), 0) FROM IMPORTA_VR IVC "
            "WHERE IVC.ADMINISTRADORA = RCV.ADMINISTRADORA "
            "AND IVC.PRODUTO = NPV.NOME_PRODUTO "
            "AND IVC.DT_INI_USO = RCV.INI_VIGENCIA "
            "AND IVC.STATUS <> 'C') VALOR_CARGA, "
            "(SELECT COALESCE(SUM(IVT.TARIFA * IVT.TAXA / 100), 0) "
            "FROM IMPORTA_VR IVT "
            "WHERE IVT.ADMINISTRADORA = RCV.ADMINISTRADORA "
            "AND IVT.PRODUTO = NPV.NOME_PRODUTO "
            "AND IVT.DT_INI_USO = RCV.INI_VIGENCIA "
            "AND IVT.STATUS <> 'C') VALOR_TAXA "
            "FROM RECIBOS_COMISSAO_VR RCV "
            "LEFT JOIN NOMES_PRODUTOS_VR NPV ON NPV.CONTA = RCV.CONTA "
            "LEFT JOIN PESSOAS PA ON PA.PESSOA = RCV.ADMINISTRADORA "
            "LEFT JOIN PESSOAS PP ON PP.PESSOA = RCV.PRODUTOR "
            "WHERE RCV.STATUS = 'A' AND RCV.NUM_RECIBO = 0 "
            "AND RCV.INI_VIGENCIA = ? "
        )
        parameters: list[Any] = [reference_date]
        if admin:
            query += "AND RCV.ADMINISTRADORA = ? "
            parameters.append(admin)
        if producer:
            query += "AND RCV.PRODUTOR = ? "
            parameters.append(producer)
        query += "ORDER BY PA.NOME, PP.NOME, NPV.NOME_PRODUTO"
        cursor = self.connection.cursor()
        cursor.execute(query, tuple(parameters))
        self.rows = cursor.fetchall()
        self.report_rows = []
        self._clear_grid()
        current_admin = None
        current_producer = None
        producer_total = Decimal("0")
        producer_benefits = 0
        for row in self.rows:
            display = list(row[:15])
            display[8] = row[15]
            display[9] = row[16]
            display[2] = display[2].strftime("%d/%m/%Y") if display[2] else ""
            admin_name = str(row[12] or row[3] or "")
            producer_name = str(row[13] or row[4] or "")
            if admin_name != current_admin:
                current_admin = admin_name
                current_producer = None
                self._insert_group_row(f"ADMINISTRADORA: {admin_name}")
            if producer_name != current_producer:
                if current_producer is not None:
                    self._insert_subtotal(current_producer, producer_total)
                current_producer = producer_name
                producer_total = Decimal("0")
                producer_benefits = 0
                self._insert_group_row(f"  PRODUTOR: {producer_name}")
            producer_total += Decimal(str(row[10] or 0))
            producer_benefits += int(row[14] or 0)
            self.grid.insert(
                "",
                tk.END,
                values=tuple(display),
                tags=(
                    "even" if len(self.grid.get_children()) % 2 == 0 else "odd",
                ),
            )
            self.report_rows.append(tuple(display))
        if current_producer is not None:
            self._insert_subtotal(current_producer, producer_total)

    def _insert_group_row(self, title: str) -> None:
        values = [title] + [""] * 14
        self.grid.insert("", tk.END, values=tuple(values), tags=("group",))

    def _insert_subtotal(self, producer: str, total: Decimal) -> None:
        values = [f"TOTAL PRODUTOR: {producer}"] + [""] * 14
        values[10] = str(total)
        self.grid.insert("", tk.END, values=tuple(values), tags=("subtotal",))

    def _save_preview_pdf(self, reference_date: date) -> None:
        """Gera o relatorio resumido da previa em A4 paisagem."""
        target = filedialog.asksaveasfilename(
            parent=self,
            title="Salvar relatorio de previa",
            defaultextension=".pdf",
            filetypes=[("PDF", "*.pdf")],
            initialfile=f"relatorio_previa_{reference_date:%Y%m%d}.pdf",
        )
        if not target:
            return

        styles = getSampleStyleSheet()
        title_style = ParagraphStyle(
            "PreviewTitle", parent=styles["Title"], fontName="Helvetica-Bold",
            fontSize=15, alignment=TA_CENTER, spaceAfter=5 * mm,
        )
        group_style = ParagraphStyle(
            "PreviewGroup", parent=styles["Heading2"], fontName="Helvetica-Bold",
            fontSize=10, textColor=colors.HexColor("#1F4E79"),
            spaceBefore=4 * mm, spaceAfter=2 * mm,
        )
        normal_style = ParagraphStyle(
            "PreviewNormal", parent=styles["Normal"], fontName="Helvetica", fontSize=8,
        )
        total_style = ParagraphStyle(
            "PreviewTotal", parent=normal_style, fontName="Helvetica-Bold",
            fontSize=9, spaceBefore=3 * mm, spaceAfter=3 * mm,
        )
        elements: list[Any] = [
            Paragraph("RELATORIO DE PREVIA DE COMISSAO - VR", title_style),
            Paragraph(f"Competencia: {reference_date:%d/%m/%Y}", normal_style),
            Spacer(1, 4 * mm),
        ]
        current_admin: str | None = None
        current_producer: str | None = None
        producer_total = Decimal("0")
        producer_benefits = 0
        detail_rows: list[list[Any]] = []

        def add_details() -> None:
            if not detail_rows:
                return
            table = Table(
                detail_rows, repeatRows=1,
                colWidths=[33 * mm, 25 * mm, 25 * mm, 28 * mm, 28 * mm],
            )
            table.setStyle(TableStyle([
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#D9EAF7")),
                ("GRID", (0, 0), (-1, -1), 0.35, colors.grey),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 7),
                ("ALIGN", (1, 1), (-1, -1), "RIGHT"),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
            ]))
            elements.append(table)
            detail_rows.clear()

        def add_total() -> None:
            if current_producer is None:
                return
            add_details()
            elements.append(Paragraph(
                f"Total do produtor: {current_producer} - "
                f"{producer_benefits} beneficios - {self._money(producer_total)}",
                total_style,
            ))
            elements.append(Spacer(1, 2 * mm))

        for row in self.report_rows:
            admin_name = str(row[12] or row[3] or "")
            producer_name = str(row[13] or row[4] or "")
            if admin_name != current_admin:
                add_total()
                current_admin = admin_name
                current_producer = None
                elements.append(Paragraph(f"Administradora: {admin_name}", group_style))
            if producer_name != current_producer:
                add_total()
                current_producer = producer_name
                producer_total = Decimal("0")
                producer_benefits = 0
                elements.append(Paragraph(f"Produtor: {producer_name}", normal_style))
                detail_rows.append(
                    ["Produto", "% Com.", "Valor de carga", "Taxas", "Comissao"]
                )
            commission = Decimal(str(row[10] or 0))
            producer_total += commission
            producer_benefits += int(row[14] or 0)
            detail_rows.append([
                str(row[5] or ""),
                f"{Decimal(str(row[6] or 0)):.2f}%",
                self._money(row[8]),
                self._money(row[9]),
                self._money(commission),
            ])
        add_total()

        document = SimpleDocTemplate(
            target, pagesize=landscape(A4), rightMargin=12 * mm, leftMargin=12 * mm,
            topMargin=12 * mm, bottomMargin=12 * mm,
            title="Relatorio de previa de comissao VR",
        )
        document.build(elements)
        self.status.set(f"Relatorio de previa gerado: {target}")
        if messagebox.askyesno(
            "Relatorio de previa gerado",
            "Relatorio gerado com sucesso. Deseja abrir o arquivo agora?",
            parent=self,
        ):
            os.startfile(target)

    def emit_voucher(self) -> None:
        """Emite o voucher financeiro usando o modelo ReportBuilder."""
        if not self.rows:
            messagebox.showwarning(
                "Voucher", "Gere o relatorio de previa antes de emitir o voucher.",
                parent=self,
            )
            return
        try:
            self._save_voucher_pdf(self._parse_date())
        except ValueError as exc:
            messagebox.showwarning("Voucher", str(exc), parent=self)
        except Exception as exc:
            messagebox.showerror("Emissao de voucher", str(exc), parent=self)

    def _load_voucher_rows(self, reference_date: date) -> list[tuple[Any, ...]]:
        """Carrega os campos usados pelo layout de voucher do ReportBuilder."""
        query = (
            "SELECT RCV.CONTROLE_REC, RCV.NUM_RECIBO, RCV.DT_EMI_RECIBO, "
            "RCV.INI_VIGENCIA, RCV.ADMINISTRADORA, RCV.PRODUTOR, RCV.CONTA, "
            "RCV.PERC_COM, RCV.DESC_COM, RCV.VALOR_BRUTO, "
            "COALESCE(RCV.VALOR_TOT_TAXA, 0), RCV.VALOR_COM, "
            "NPV.NOME_PRODUTO, PA.NOME, PP.NOME, PP.CPF_CNPJ, "
            "PP.OPTOU_SIMPLES, BAN.NOME_BANCO, PP.BANCO, PP.AGENCIA, "
            "PP.CONTA, "
            "(SELECT COALESCE(SUM(IVC.TARIFA), 0) FROM IMPORTA_VR IVC "
            "WHERE IVC.ADMINISTRADORA = RCV.ADMINISTRADORA "
            "AND IVC.PRODUTO = NPV.NOME_PRODUTO "
            "AND IVC.DT_INI_USO = RCV.INI_VIGENCIA "
            "AND IVC.STATUS <> 'C') VALOR_CARGA, "
            "(SELECT COALESCE(SUM(IVT.TARIFA * IVT.TAXA / 100), 0) "
            "FROM IMPORTA_VR IVT "
            "WHERE IVT.ADMINISTRADORA = RCV.ADMINISTRADORA "
            "AND IVT.PRODUTO = NPV.NOME_PRODUTO "
            "AND IVT.DT_INI_USO = RCV.INI_VIGENCIA "
            "AND IVT.STATUS <> 'C') VALOR_TAXA "
            "FROM RECIBOS_COMISSAO_VR RCV "
            "LEFT JOIN NOMES_PRODUTOS_VR NPV ON NPV.CONTA = RCV.CONTA "
            "LEFT JOIN PESSOAS PA ON PA.PESSOA = RCV.ADMINISTRADORA "
            "LEFT JOIN PESSOAS PP ON PP.PESSOA = RCV.PRODUTOR "
            "LEFT JOIN BANCOS BAN ON BAN.COD_BANCO = PP.BANCO "
            "WHERE RCV.STATUS = 'A' AND RCV.NUM_RECIBO = 0 "
            "AND RCV.INI_VIGENCIA = ? "
        )
        parameters: list[Any] = [reference_date]
        admin = self.administradoras.get(self.administradora.get())
        producer = self.produtores.get(self.produtor.get())
        if admin:
            query += "AND RCV.ADMINISTRADORA = ? "
            parameters.append(admin)
        if producer:
            query += "AND RCV.PRODUTOR = ? "
            parameters.append(producer)
        query += "ORDER BY PA.NOME, PP.NOME, NPV.NOME_PRODUTO"
        cursor = self.connection.cursor()
        cursor.execute(query, tuple(parameters))
        return cursor.fetchall()

    @staticmethod
    def _money(value: Any) -> str:
        amount = Decimal(str(value or 0))
        return f"R$ {amount:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".")

    @staticmethod
    def _document(value: Any) -> str:
        digits = "".join(character for character in str(value or "") if character.isdigit())
        if len(digits) == 14:
            return (
                f"{digits[:2]}.{digits[2:5]}.{digits[5:8]}/"
                f"{digits[8:12]}-{digits[12:]}"
            )
        if len(digits) == 11:
            return f"{digits[:3]}.{digits[3:6]}.{digits[6:9]}-{digits[9:]}"
        return str(value or "")

    def _next_voucher_number(self) -> int:
        cursor = self.connection.cursor()
        cursor.execute(
            "SELECT GEN_ID(NUMERO_VOUCHER_VR, 1) CONTA FROM RDB$DATABASE"
        )
        row = cursor.fetchone()
        if row is None or row[0] is None:
            raise RuntimeError("Nao foi possivel gerar o numero do voucher.")
        return int(row[0])

    def _save_voucher_pdf(self, reference_date: date) -> None:
        target = filedialog.asksaveasfilename(
            parent=self,
            title="Salvar vouchers de previa",
            defaultextension=".pdf",
            filetypes=[("PDF", "*.pdf")],
            initialfile=f"VoucherVR_{reference_date:%Y%m%d}.pdf",
        )
        if not target:
            return

        rows = self._load_voucher_rows(reference_date)
        if not rows:
            messagebox.showwarning(
                "Voucher", "Nao ha dados para gerar o voucher.", parent=self
            )
            return

        styles = getSampleStyleSheet()
        title_style = ParagraphStyle(
            "VoucherTitle",
            parent=styles["Title"],
            fontName="Helvetica-Bold",
            fontSize=14,
            alignment=TA_CENTER,
            spaceAfter=3 * mm,
        )
        label_style = ParagraphStyle(
            "VoucherLabel",
            parent=styles["Normal"],
            fontName="Helvetica-Bold",
            fontSize=8,
        )
        value_style = ParagraphStyle(
            "VoucherValue",
            parent=styles["Normal"],
            fontName="Helvetica",
            fontSize=8,
        )
        total_style = ParagraphStyle(
            "VoucherTotal",
            parent=value_style,
            fontName="Helvetica-Bold",
            fontSize=10,
            alignment=TA_RIGHT,
        )
        blue = colors.HexColor("#B7D2EF")
        border = colors.HexColor("#174A9C")
        elements: list[Any] = []
        administrators: dict[str, list[tuple[Any, ...]]] = {}
        for row in rows:
            administrators.setdefault(str(row[13] or row[4] or ""), []).append(row)

        for page_index, (admin_name, admin_rows) in enumerate(administrators.items()):
            first = admin_rows[0]
            producer_name = str(first[14] or first[5] or "")
            producer_document = self._document(first[15])
            total_base = sum((Decimal(str(row[21] or 0)) for row in admin_rows), Decimal("0"))
            total_tax = sum((Decimal(str(row[22] or 0)) for row in admin_rows), Decimal("0"))
            total_commission = sum(
                (Decimal(str(row[11] or 0)) for row in admin_rows), Decimal("0")
            )
            voucher_number = self._next_voucher_number()
            elements.append(Paragraph("AUTORIZAÇÃO PARA PAGAMENTO", title_style))

            header_label = ParagraphStyle(
                "VoucherHeaderLabel",
                parent=label_style,
                fontSize=7,
                leading=8,
            )
            header_value = ParagraphStyle(
                "VoucherHeaderValue",
                parent=value_style,
                fontSize=7,
                leading=8,
            )
            emphasized_value = ParagraphStyle(
                "VoucherEmphasizedValue",
                parent=header_value,
                fontName="Helvetica-Bold",
            )

            def header_text(value: Any, style: ParagraphStyle) -> Paragraph:
                return Paragraph(str(value or "").replace("&", "&amp;"), style)

            header = Table(
                [
                    [header_text("FAVORECIDO", header_label),
                     header_text(producer_name, emphasized_value),
                     header_text("CNPJ", header_label),
                     header_text(producer_document, header_value)],
                    [header_text("ADMINISTRADORA", header_label),
                     header_text(admin_name, emphasized_value),
                     header_text("OPÇÃO SIMPLES", header_label),
                     header_text(first[16], header_value)],
                    [header_text("DATA DE VIGÊNCIA CRÉDITO", header_label),
                     header_text(reference_date.strftime("%d/%m/%Y"), header_value),
                     header_text("VOUCHER", header_label),
                     header_text(voucher_number, header_value)],
                    [header_text("CRÉDITO CONTA CORRENTE", header_label),
                     header_text(first[17], header_value),
                     header_text("AGÊNCIA", header_label),
                     header_text(first[19], header_value)],
                    [header_text("BANCO", header_label),
                     header_text(first[18], header_value),
                     header_text("C/C", header_label),
                     header_text(first[20], header_value)],
                ],
                colWidths=[30 * mm, 82 * mm, 30 * mm, 38 * mm],
            )
            header.setStyle(TableStyle([
                ("BACKGROUND", (0, 0), (-1, -1), blue),
                ("BOX", (0, 0), (-1, -1), 0.8, border),
                ("INNERGRID", (0, 0), (-1, -1), 0.5, border),
                ("FONTNAME", (0, 0), (0, -1), "Helvetica-Bold"),
                ("FONTNAME", (2, 0), (2, -1), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 7),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
            ]))
            elements.append(header)
            elements.append(Spacer(1, 5 * mm))
            details = [
                ["Produto", "Valor de carga", "Valor da taxa", "% de repasse",
                 "Repasse"]
            ]
            for row in admin_rows:
                details.append([
                    str(row[12] or ""),
                    self._money(row[21]),
                    self._money(row[22]),
                    f"{Decimal(str(row[7] or 0)):.2f}%",
                    self._money(row[11]),
                ])
            details.append([
                "TOTAL", self._money(total_base), self._money(total_tax), "",
                self._money(total_commission),
            ])
            detail_table = Table(
                details,
                repeatRows=1,
                colWidths=[50 * mm, 34 * mm, 32 * mm, 30 * mm, 34 * mm],
            )
            detail_table.setStyle(TableStyle([
                ("BACKGROUND", (0, 0), (-1, 0), blue),
                ("BACKGROUND", (0, -1), (-1, -1), colors.HexColor("#A8C5E8")),
                ("BOX", (0, 0), (-1, -1), 0.8, border),
                ("INNERGRID", (0, 0), (-1, -1), 0.5, border),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTNAME", (0, -1), (-1, -1), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 8),
                ("ALIGN", (1, 1), (-1, -1), "RIGHT"),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
            ]))
            elements.append(detail_table)
            elements.append(Spacer(1, 8 * mm))

            receipt = Table(
                [
                    ["RECEBEMOS DE", admin_name],
                    ["VALOR BRUTO", self._money(total_commission)],
                    ["ESTORNO", self._money(0)],
                    ["I . S . S", self._money(0)],
                    ["IMPOSTO DE RENDA", self._money(0)],
                    ["COFINS", self._money(0)],
                    ["CSLL", self._money(0)],
                    ["PIS", self._money(0)],
                    ["VALOR TOTAL", self._money(total_commission)],
                ],
                colWidths=[42 * mm, 135 * mm],
            )
            receipt.setStyle(TableStyle([
                ("BACKGROUND", (0, 0), (-1, -1), blue),
                ("BOX", (0, 0), (-1, -1), 0.8, border),
                ("INNERGRID", (0, 0), (-1, -1), 0.5, border),
                ("FONTNAME", (0, 0), (0, -1), "Helvetica-Bold"),
                ("FONTNAME", (1, 0), (1, -1), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 8),
                ("ALIGN", (1, 1), (1, -1), "RIGHT"),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
                ("BACKGROUND", (0, -1), (-1, -1), colors.HexColor("#A8C5E8")),
            ]))
            elements.append(Paragraph("RECIBO DE PAGAMENTO", title_style))
            elements.append(receipt)
            elements.append(Spacer(1, 5 * mm))
            elements.append(Paragraph(
                "ESTA IMPRESSÃO NÃO É VÁLIDA COMO DOCUMENTO FISCAL",
                ParagraphStyle("Disclaimer", parent=label_style, alignment=TA_CENTER),
            ))
            if page_index < len(administrators) - 1:
                elements.append(PageBreak())

        document = SimpleDocTemplate(
            target,
            pagesize=A4,
            rightMargin=15 * mm,
            leftMargin=15 * mm,
            topMargin=12 * mm,
            bottomMargin=12 * mm,
            title="VoucherVR",
        )
        document.build(elements)
        self.status.set(f"PDF gerado: {target}")
        if messagebox.askyesno(
            "Voucher gerado",
            "PDF gerado com sucesso. Deseja abrir o arquivo agora?",
            parent=self,
        ):
            os.startfile(target)

    def export_csv(self) -> None:
        if not self.rows:
            messagebox.showwarning("Relatorio", "Gere uma previa antes de exportar.", parent=self)
            return
        target = filedialog.asksaveasfilename(
            parent=self,
            title="Salvar relatorio",
            defaultextension=".csv",
            filetypes=[("CSV", "*.csv")],
            initialfile="relatorio_comissoes_vr.csv",
        )
        if not target:
            return
        headers = [
            "CONTROLE_REC", "NUM_RECIBO", "INI_VIGENCIA", "ADMINISTRADORA",
            "PRODUTOR", "NOME_PRODUTO", "PERC_COM", "DESC_COM", "VALOR_BRUTO",
            "VALOR_TAXA", "VALOR_COM", "STATUS", "NOME_ADM", "NOME_PRODUTOR",
            "BENEFICIOS",
        ]
        with Path(target).open("w", encoding="utf-8-sig", newline="") as stream:
            writer = csv.writer(stream, delimiter=";")
            writer.writerow(headers)
            current_admin = None
            current_producer = None
            producer_total = Decimal("0")
            producer_benefits = 0
            for row in self.report_rows:
                admin_name = str(row[12] or row[3] or "")
                producer_name = str(row[13] or row[4] or "")
                if admin_name != current_admin:
                    current_admin = admin_name
                    current_producer = None
                    writer.writerow([f"ADMINISTRADORA: {admin_name}"])
                if producer_name != current_producer:
                    if current_producer is not None:
                        writer.writerow(
                            [
                                f"TOTAL PRODUTOR: {current_producer}",
                                f"{producer_benefits} beneficios",
                                str(producer_total),
                            ]
                        )
                    current_producer = producer_name
                    producer_total = Decimal("0")
                    producer_benefits = 0
                    writer.writerow([f"PRODUTOR: {producer_name}"])
                writer.writerow(row)
                producer_total += Decimal(str(row[10] or 0))
                producer_benefits += int(row[14] or 0)
            if current_producer is not None:
                writer.writerow(
                    [f"TOTAL PRODUTOR: {current_producer}", str(producer_total)]
                    + [f"{producer_benefits} beneficios"]
                )
        self.status.set(f"Relatorio exportado: {target}")

    def clear(self) -> None:
        self.administradora.set("")
        self.produtor.set("")
        self.vigencia.set("")
        self.producer_combo["values"] = ()
        self.rows = []
        self.report_rows = []
        self._clear_grid()
        self.status.set("Pronto")

    def _clear_grid(self) -> None:
        for item in self.grid.get_children():
            self.grid.delete(item)

    def _close(self) -> None:
        if self.connection is not None:
            self.connection.close()
        self.destroy()
