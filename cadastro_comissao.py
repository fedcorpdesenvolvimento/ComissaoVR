"""Tela de cadastro de percentuais de comissao de VR."""

from __future__ import annotations

import tkinter as tk
from decimal import Decimal, InvalidOperation
from tkinter import messagebox, ttk
from typing import Any

from database import open_connection


class CadastroComissaoWindow(tk.Toplevel):
    """Implementa o fluxo principal do formulario Delphi original."""

    def __init__(self, parent: tk.Misc) -> None:
        super().__init__(parent)
        self.title("Cadastro de Comissoes de VR")
        self.geometry("980x650")
        self.minsize(850, 560)
        self.transient(parent)

        self.connection = None
        self.mode = "idle"
        self.selected_control: int | None = None
        self.selected_account: int | None = None
        self.administradoras: dict[str, str] = {}
        self.produtores: dict[str, str] = {}
        self.products: dict[str, int] = {}

        self._create_variables()
        self._create_widgets()
        self._set_idle_state()
        self._load_reference_data()
        self.protocol("WM_DELETE_WINDOW", self._close)

    def _create_variables(self) -> None:
        self.apolice = tk.StringVar(value="VR0001")
        self.administradora = tk.StringVar()
        self.produtor = tk.StringVar()
        self.produto = tk.StringVar()
        self.comissao = tk.StringVar(value="0,00")
        self.desconto = tk.StringVar(value="0,00")
        self.sobre_taxa = tk.BooleanVar(value=False)
        self.apenas_cond_taxa = tk.BooleanVar(value=True)
        self.status = tk.StringVar(value="Conectando ao Firebird...")

    def _create_widgets(self) -> None:
        root = ttk.Frame(self, padding=10)
        root.pack(fill=tk.BOTH, expand=True)

        actions = ttk.Frame(root)
        actions.pack(fill=tk.X, pady=(0, 8))
        self.new_button = ttk.Button(actions, text="Novo", command=self._new)
        self.new_button.pack(side=tk.LEFT, padx=(0, 6))
        self.edit_button = ttk.Button(
            actions, text="Alterar", command=self._edit, state=tk.DISABLED
        )
        self.edit_button.pack(side=tk.LEFT, padx=6)
        self.cancel_button = ttk.Button(
            actions,
            text="Excluir/Canc.",
            command=self._cancel,
            state=tk.DISABLED,
        )
        self.cancel_button.pack(side=tk.LEFT, padx=6)
        ttk.Button(actions, text="Limpa", command=self._reset).pack(
            side=tk.LEFT, padx=6
        )
        ttk.Button(actions, text="Sair", command=self._close).pack(
            side=tk.RIGHT
        )

        selection = ttk.LabelFrame(root, text="Identificacao da comissao")
        selection.pack(fill=tk.X, pady=4)
        self._field(selection, "Apolice:", self.apolice, 0, readonly=True)
        self._field(
            selection,
            "Administradora:",
            self.administradora,
            1,
            values=self._administradora_values,
        )
        self._field(
            selection,
            "Produtor:",
            self.produtor,
            2,
            values=self._produtor_values,
        )
        self._field(
            selection,
            "Produto:",
            self.produto,
            3,
            values=self._product_values,
        )

        options = ttk.LabelFrame(root, text="Parametros")
        options.pack(fill=tk.X, pady=4)
        self._field(options, "Comissao (%):", self.comissao, 0)
        self._field(options, "Desconto (%):", self.desconto, 1)
        self.tax_check = ttk.Checkbutton(
            options,
            text="Calcula comissao somente em condicoes com taxas",
            variable=self.apenas_cond_taxa,
        )
        self.tax_check.grid(row=0, column=4, sticky=tk.W, padx=12, pady=5)
        self.rate_check = ttk.Checkbutton(
            options,
            text="Calcula comissao sobre as taxas",
            variable=self.sobre_taxa,
        )
        self.rate_check.grid(row=1, column=4, sticky=tk.W, padx=12, pady=5)
        self.apply_button = ttk.Button(
            options, text="Aplica", command=self._save, state=tk.DISABLED
        )
        self.apply_button.grid(row=0, column=5, rowspan=2, padx=12, pady=5)

        grid_frame = ttk.LabelFrame(root, text="Comissoes cadastradas")
        grid_frame.pack(fill=tk.BOTH, expand=True, pady=4)
        columns = (
            "conta",
            "produto",
            "comissao",
            "desconto",
            "produtor",
            "produtor_codigo",
            "controle",
        )
        self.grid = ttk.Treeview(
            grid_frame, columns=columns, show="headings", selectmode="browse"
        )
        headings = {
            "conta": "Conta",
            "produto": "Produto",
            "comissao": "Comissao",
            "desconto": "Desconto",
            "produtor": "Produtor",
            "controle": "Controle",
            "produtor_codigo": "Codigo produtor",
        }
        for column in columns:
            self.grid.heading(column, text=headings[column])
            self.grid.column(column, width=110, anchor=tk.W)
        self.grid.column("produto", width=250)
        self.grid.column("produtor_codigo", width=0, minwidth=0, stretch=False)
        self.grid.bind("<<TreeviewSelect>>", self._select_row)
        scrollbar = ttk.Scrollbar(
            grid_frame, orient=tk.VERTICAL, command=self.grid.yview
        )
        self.grid.configure(yscrollcommand=scrollbar.set)
        self.grid.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        ttk.Label(root, textvariable=self.status).pack(anchor=tk.W, pady=(4, 0))

    def _field(
        self,
        parent: ttk.LabelFrame,
        label: str,
        variable: tk.StringVar,
        row: int,
        values: Any = None,
        readonly: bool = False,
    ) -> None:
        ttk.Label(parent, text=label).grid(
            row=row, column=0, sticky=tk.W, padx=8, pady=5
        )
        state = "readonly" if readonly else "normal"
        widget: ttk.Combobox | ttk.Entry
        if values is not None:
            widget = ttk.Combobox(
                parent, textvariable=variable, state=state, width=45
            )
            widget["values"] = values
            if variable is self.administradora:
                self.administradora_combo = widget
                widget.bind("<<ComboboxSelected>>", self._on_administradora)
                widget.bind("<FocusOut>", self._on_administradora)
            elif variable is self.produtor:
                self.produtor_combo = widget
                widget.bind("<<ComboboxSelected>>", self._on_produtor)
            elif variable is self.produto:
                self.produto_combo = widget
                widget.bind("<<ComboboxSelected>>", self._on_product)
        else:
            widget = ttk.Entry(parent, textvariable=variable, width=48)
        widget.grid(row=row, column=1, sticky=tk.W, padx=8, pady=5)

    @property
    def _administradora_values(self) -> list[str]:
        return list(self.administradoras)

    @property
    def _produtor_values(self) -> list[str]:
        return list(self.produtores)

    @property
    def _product_values(self) -> list[str]:
        return list(self.products)

    def _load_reference_data(self) -> None:
        try:
            self.connection = open_connection()
            cursor = self.connection.cursor()
            cursor.execute(
                "SELECT APO.administradora, PES.nome "
                "FROM APOLICES APO LEFT JOIN PESSOAS PES "
                "ON PES.pessoa = APO.administradora "
                "WHERE APO.apolice LIKE '%VR%' AND APO.status = 'A' "
                "GROUP BY APO.administradora, PES.nome ORDER BY 2"
            )
            self.administradoras = {
                str(row[1]): str(row[0]) for row in cursor.fetchall() if row[1]
            }
            self.administradora_combo["values"] = self._administradora_values
            self.status.set("Conectado ao Firebird")
        except Exception as exc:
            self.status.set("Falha na conexao com o Firebird")
            messagebox.showerror(
                "Conexao",
                f"Nao foi possivel conectar ao Firebird:\n{exc}",
                parent=self,
            )

    def _on_administradora(self, _event: tk.Event[tk.Misc]) -> None:
        if self.connection is None or not self.administradora.get():
            return
        cursor = self.connection.cursor()
        administrator_id = self.administradoras.get(self.administradora.get())
        if administrator_id is None:
            cursor.execute(
                "SELECT PES.PESSOA FROM PESSOAS PES "
                "WHERE PES.NOME = ? AND PES.STATUS = 'A'",
                (self.administradora.get(),),
            )
            administrator_row = cursor.fetchone()
            administrator_id = (
                str(administrator_row[0]) if administrator_row else None
            )
        if administrator_id is None:
            self.produtores = {}
            self.produtor_combo["values"] = ()
            self.produtor.set("")
            self._clear_products()
            return

        # A apolice informa ate dois produtores nos campos FAVOR e FAVOR2.
        cursor.execute(
            "SELECT APO.FAVOR, APO.FAVOR2 FROM APOLICES APO "
            "WHERE APO.APOLICE = ? AND APO.ADMINISTRADORA = ? "
            "AND APO.STATUS = 'A'",
            (self.apolice.get(), administrator_id),
        )
        ids = {
            str(value)
            for row in cursor.fetchall()
            for value in row
            if value not in (None, "")
        }
        self.produtores = {}
        if ids:
            placeholders = ",".join("?" for _ in ids)
            cursor.execute(
                f"SELECT PESSOA, NOME FROM PESSOAS WHERE PESSOA IN ({placeholders}) "
                "AND STATUS = 'A' ORDER BY NOME",
                tuple(ids),
            )
            self.produtores = {
                str(row[1]): str(row[0]) for row in cursor.fetchall() if row[1]
            }
        self.produtor_combo["values"] = self._produtor_values
        self.produtor.set("")
        self._clear_products()
        self._load_existing()
        if not self.produtores:
            self.status.set("Nenhum produtor ativo encontrado para a apolice")
        else:
            self.status.set("Selecione o produtor")

    def _on_produtor(self, _event: tk.Event[tk.Misc]) -> None:
        self._load_products()
        self._load_existing(filter_producer=True)

    def _on_product(self, _event: tk.Event[tk.Misc]) -> None:
        if self.connection is None or not self.produto.get():
            return
        cursor = self.connection.cursor()
        cursor.execute(
            "SELECT CONTA FROM NOMES_PRODUTOS_VR WHERE NOME_PRODUTO = ?",
            (self.produto.get(),),
        )
        row = cursor.fetchone()
        if row:
            self.status.set(f"Produto selecionado: conta {row[0]}")

    def _load_products(self) -> None:
        if self.connection is None or self.produtor.get() not in self.produtores:
            return
        cursor = self.connection.cursor()
        cursor.execute(
            "SELECT * FROM NOMES_PRODUTOS_VR VR "
            "WHERE VR.CONTA NOT IN ("
            "SELECT TCA.CONTA FROM TAB_COMISSAO_ADM_VR TCA "
            "WHERE TCA.PRODUTOR = ? AND TCA.STATUS = 'A') "
            "ORDER BY VR.NOME_PRODUTO",
            (self.produtores[self.produtor.get()],),
        )
        columns = [str(column[0]).upper() for column in cursor.description]
        self.products = {}
        for row in cursor.fetchall():
            values = dict(zip(columns, row))
            product_name = values.get("NOME_PRODUTO")
            account = values.get("CONTA")
            if product_name and account is not None:
                self.products[str(product_name)] = int(account)
        self.produto_combo["values"] = self._product_values
        self.produto.set("")

    def _load_existing(self, filter_producer: bool = False) -> None:
        if self.connection is None:
            return
        self._clear_grid()
        cursor = self.connection.cursor()
        query = (
            "SELECT NPV.CONTA, NPV.NOME_PRODUTO, TCA.PERC_COM, "
            "TCA.PERC_DESC, PES.NOME, TCA.PRODUTOR, TCA.CONTROLE "
            "FROM NOMES_PRODUTOS_VR NPV "
            "JOIN TAB_COMISSAO_ADM_VR TCA ON TCA.CONTA = NPV.CONTA "
            "LEFT JOIN PESSOAS PES ON PES.PESSOA = TCA.PRODUTOR "
        )
        parameters: list[str] = [
            self.administradoras.get(self.administradora.get(), "")
        ]
        query += "WHERE NPV.STATUS = 'A' AND TCA.ADMINISTRADORA = ? "
        if filter_producer and self.produtor.get():
            query += "AND TCA.PRODUTOR = ? "
            parameters.append(self.produtores.get(self.produtor.get(), ""))
        query += "AND TCA.STATUS = 'A' ORDER BY NPV.CONTA"
        cursor.execute(query, tuple(parameters))
        for row in cursor.fetchall():
            self.grid.insert("", tk.END, values=tuple(row))

    def _save(self) -> None:
        if self.connection is None:
            messagebox.showerror("Cadastro", "Nao ha conexao com o Firebird.", parent=self)
            return
        if not self._validate():
            return
        try:
            commission = self._percentage(self.comissao.get())
            # Desconto e opcional: vazio, zero ou zero com virgula
            # representam percentual 0.
            discount = self._percentage(self.desconto.get() or "0")
        except ValueError as exc:
            messagebox.showerror("Cadastro", str(exc), parent=self)
            return

        administrator = self.administradoras[self.administradora.get()]
        producer = self.produtores[self.produtor.get()]
        account = self.selected_account
        if self.mode == "new":
            account = self.products[self.produto.get()]
        if account is None:
            messagebox.showerror(
                "Cadastro",
                "Nao foi possivel identificar a conta do produto.",
                parent=self,
            )
            return
        cursor = self.connection.cursor()
        try:
            if self.mode == "new":
                cursor.execute(
                    "INSERT INTO TAB_COMISSAO_ADM_VR "
                    "(CONTROLE, ADMINISTRADORA, PRODUTOR, STATUS, CONTA, "
                    "PERC_COM, PERC_DESC, SOBRE_TAXA, APENAS_COND_TAXA) "
                    "VALUES (GEN_ID(CONTROLE_TAB_COMISSAO_VR, 1), ?, ?, 'A', "
                    "?, ?, ?, ?, ?)",
                    (
                        administrator,
                        producer,
                        account,
                        commission,
                        discount,
                        "S" if self.sobre_taxa.get() else "N",
                        "S" if self.apenas_cond_taxa.get() else "N",
                    ),
                )
                message = "Comissao incluida com sucesso."
            else:
                cursor.execute(
                    "UPDATE TAB_COMISSAO_ADM_VR SET PERC_COM = ?, "
                    "PERC_DESC = ?, SOBRE_TAXA = ?, APENAS_COND_TAXA = ? "
                    "WHERE CONTROLE = ?",
                    (
                        commission,
                        discount,
                        "S" if self.sobre_taxa.get() else "N",
                        "S" if self.apenas_cond_taxa.get() else "N",
                        self.selected_control,
                    ),
                )
                message = "Comissao alterada com sucesso."
            self.connection.commit()
        except Exception:
            self.connection.rollback()
            raise
        messagebox.showinfo("Cadastro", message, parent=self)
        self._load_existing()
        self._reset_fields()

    def _cancel(self) -> None:
        if self.connection is None or self.selected_control is None:
            return
        if not messagebox.askyesno(
            "Cancelar comissao",
            "Confirma o cancelamento desta comissao?",
            parent=self,
        ):
            return
        cursor = self.connection.cursor()
        try:
            cursor.execute(
                "UPDATE TAB_COMISSAO_ADM_VR SET STATUS = 'C' WHERE CONTROLE = ?",
                (self.selected_control,),
            )
            self.connection.commit()
        except Exception:
            self.connection.rollback()
            raise
        self._load_existing()
        self._reset_fields()
        messagebox.showinfo("Cadastro", "Comissao cancelada com sucesso.", parent=self)

    def _validate(self) -> bool:
        required = (
            (self.administradora, "Administradora"),
            (self.produtor, "Produtor"),
            (self.produto, "Produto"),
        )
        for variable, label in required:
            if not variable.get():
                messagebox.showwarning("Cadastro", f"{label} e obrigatoria.", parent=self)
                return False
        return True

    @staticmethod
    def _percentage(value: str) -> Decimal:
        normalized = value.strip()
        if not normalized:
            return Decimal("0")
        if "," in normalized:
            # Formato brasileiro: 1.234,56.
            normalized = normalized.replace(".", "").replace(",", ".")
        # Sem virgula, o ponto e o separador decimal usado pelo Firebird.
        try:
            result = Decimal(normalized)
        except InvalidOperation as exc:
            raise ValueError("Percentuais devem ser numeros validos.") from exc
        if result < 0 or result > 100:
            raise ValueError("Percentuais devem estar entre 0 e 100.")
        return result

    def _new(self) -> None:
        self._reset_fields()
        self.mode = "new"
        self.selected_control = None
        self._set_form_state(True)

    def _edit(self) -> None:
        if self.selected_control is not None:
            self.mode = "edit"
            self._set_form_state(True, identity_locked=True)

    def _select_row(self, _event: tk.Event[tk.Misc]) -> None:
        selection = self.grid.selection()
        if not selection:
            return
        values = self.grid.item(selection[0], "values")
        self.selected_account = int(values[0])
        self.produtor.set(values[4])
        self.produtores[values[4]] = str(values[5])
        self.produtor_combo["values"] = self._produtor_values
        self.selected_control = int(values[6])
        self.produto.set(values[1])
        self.comissao.set(str(values[2] or "0"))
        self.desconto.set(str(values[3] or "0"))
        self.edit_button.configure(state=tk.NORMAL)
        self.cancel_button.configure(state=tk.NORMAL)

    def _set_form_state(self, enabled: bool, identity_locked: bool = False) -> None:
        state = tk.NORMAL if enabled else tk.DISABLED
        self.apply_button.configure(state=state)
        self.tax_check.configure(state=state)
        self.rate_check.configure(state=state)
        product_state = "disabled" if not enabled or identity_locked else "readonly"
        self.produto_combo.configure(state=product_state)
        identity_state = (
            "disabled" if not enabled or identity_locked else "readonly"
        )
        self.administradora_combo.configure(state=identity_state)
        self.produtor_combo.configure(state=identity_state)

    def _set_idle_state(self) -> None:
        self._set_form_state(False)

    def _clear_products(self) -> None:
        self.products = {}
        self.produto_combo["values"] = ()
        self.produto.set("")

    def _clear_grid(self) -> None:
        for item in self.grid.get_children():
            self.grid.delete(item)

    def _reset_fields(self) -> None:
        self.produto.set("")
        self.comissao.set("0,00")
        self.desconto.set("0,00")
        self.selected_control = None
        self.selected_account = None
        self.mode = "idle"
        self._set_form_state(False)

    def _reset(self) -> None:
        self.administradora.set("")
        self.produtor.set("")
        self._clear_products()
        self._clear_grid()
        self._reset_fields()

    def _close(self) -> None:
        if self.connection is not None:
            self.connection.close()
        self.destroy()
