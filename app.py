"""Aplicacao principal do cadastro e relatorio de comissoes de VR.

As telas de cadastro e relatorio ficam separadas da janela principal para
permitir que sejam conectadas ao Firebird sem alterar o menu.
"""

from __future__ import annotations

import tkinter as tk
from tkinter import ttk

from cadastro_comissao import CadastroComissaoWindow
from relatorio_comissoes import RelatorioComissoesWindow


class ComissaoVRApp(tk.Tk):
    """Janela principal do sistema de comissoes de VR."""

    def __init__(self) -> None:
        super().__init__()

        self.title("Comissoes de VR")
        self.geometry("760x460")
        self.minsize(640, 380)

        self._configure_style()
        self._create_menu()
        self._create_layout()

    def _configure_style(self) -> None:
        style = ttk.Style(self)
        if "vista" in style.theme_names():
            style.theme_use("vista")

        style.configure("Title.TLabel", font=("Segoe UI", 18, "bold"))
        style.configure("Subtitle.TLabel", font=("Segoe UI", 10))
        style.configure("Menu.TButton", font=("Segoe UI", 11), padding=(18, 12))

    def _create_menu(self) -> None:
        menu_bar = tk.Menu(self)

        menu_operacoes = tk.Menu(menu_bar, tearoff=False)
        menu_operacoes.add_command(
            label="Cadastrar percentuais de comissao",
            command=self.open_cadastro,
        )
        menu_operacoes.add_command(
            label="Relatorio de comissoes",
            command=self.open_relatorio,
        )
        menu_operacoes.add_separator()
        menu_operacoes.add_command(label="Sair", command=self.destroy)

        menu_bar.add_cascade(label="Operacoes", menu=menu_operacoes)
        self.configure(menu=menu_bar)

    def _create_layout(self) -> None:
        container = ttk.Frame(self, padding=32)
        container.pack(fill=tk.BOTH, expand=True)

        ttk.Label(
            container,
            text="Comissoes de VR",
            style="Title.TLabel",
        ).pack(pady=(20, 4))
        ttk.Label(
            container,
            text="Selecione uma operacao para continuar",
            style="Subtitle.TLabel",
        ).pack(pady=(0, 28))

        buttons = ttk.Frame(container)
        buttons.pack()

        ttk.Button(
            buttons,
            text="Cadastrar percentuais\nde comissao",
            style="Menu.TButton",
            command=self.open_cadastro,
            width=26,
        ).grid(row=0, column=0, padx=10, pady=10)
        ttk.Button(
            buttons,
            text="Relatorio de\ncomissoes",
            style="Menu.TButton",
            command=self.open_relatorio,
            width=26,
        ).grid(row=0, column=1, padx=10, pady=10)

        self.status_text = tk.StringVar(value="Pronto")
        ttk.Label(container, textvariable=self.status_text).pack(
            side=tk.BOTTOM,
            pady=(24, 0),
        )

    def _open_placeholder(self, title: str, description: str) -> None:
        window = tk.Toplevel(self)
        window.title(title)
        window.geometry("620x360")
        window.minsize(520, 300)
        window.transient(self)

        content = ttk.Frame(window, padding=28)
        content.pack(fill=tk.BOTH, expand=True)

        ttk.Label(content, text=title, style="Title.TLabel").pack(
            anchor=tk.W,
            pady=(0, 12),
        )
        ttk.Label(
            content,
            text=description,
            wraplength=540,
            justify=tk.LEFT,
        ).pack(anchor=tk.W, pady=(0, 24))

        ttk.Label(
            content,
            text="Esta tela sera conectada ao banco Firebird na proxima etapa.",
            wraplength=540,
            justify=tk.LEFT,
        ).pack(anchor=tk.W)

        ttk.Button(content, text="Fechar", command=window.destroy).pack(
            anchor=tk.E,
            side=tk.BOTTOM,
        )

    def open_cadastro(self) -> None:
        self.status_text.set("Cadastro de percentuais de comissao")
        CadastroComissaoWindow(self)

    def open_relatorio(self) -> None:
        self.status_text.set("Relatorio de comissoes")
        RelatorioComissoesWindow(self)


def main() -> None:
    app = ComissaoVRApp()
    app.mainloop()


if __name__ == "__main__":
    main()
