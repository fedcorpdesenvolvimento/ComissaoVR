"""Conexao Firebird usada pelo modulo de comissoes de VR."""

from __future__ import annotations

import os
from pathlib import Path

from firebird.driver import Connection, connect


def _load_env() -> dict[str, str]:
    values: dict[str, str] = {}
    env_path = Path(__file__).with_name(".env")
    if not env_path.exists():
        return values

    for raw_line in env_path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip().strip('"').strip("'")
    return values


def open_connection() -> Connection:
    """Abre uma conexao usando o mesmo formato de variaveis do .env."""
    values = _load_env()
    host = values.get("FB_HOST") or os.getenv("FB_HOST", "localhost")
    port = values.get("FB_PORT") or os.getenv("FB_PORT", "3050")
    database = values.get("FB_DATABASE") or os.getenv("FB_DATABASE", "")
    user = values.get("FB_USER") or os.getenv("FB_USER", "")
    password = values.get("FB_PASSWORD") or os.getenv("FB_PASSWORD", "")
    charset = values.get("FB_CHARSET") or os.getenv("FB_CHARSET", "WIN1252")
    # O .env legado informa ASCII, mas os textos deste banco contem
    # caracteres acentuados armazenados em uma pagina de codigo Windows.
    if charset.upper() == "ASCII":
        charset = "WIN1252"

    if not database:
        raise ValueError("FB_DATABASE nao foi configurado no arquivo .env.")

    database_url = f"{host}/{port}:{database}"
    return connect(
        database_url,
        user=user,
        password=password,
        charset=charset,
    )
