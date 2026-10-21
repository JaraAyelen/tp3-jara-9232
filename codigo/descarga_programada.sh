#!/bin/bash

# Validar parámetros de entrada
if [ "$#" -ne 1 ]; then
    echo "Error: Debe ingresar una URL como parámetro." >&2
    exit 1
fi

URL="$1"

# Detectar dinámicamente la ruta absoluta del repositorio
DIR_BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIR_DESCARGAS="$DIR_BASE/descargas"

# Asegurar que la carpeta descargas exista
mkdir -p "$DIR_DESCARGAS"

# Descargar el archivo usando wget y guardarlo en ese directorio
wget -P "$DIR_DESCARGAS" "$URL"

# Validar si el comando wget se ejecutó correctamente
if [ $? -eq 0 ]; then
    echo "Descarga finalizada con éxito."
else
    echo "Error: Falló la descarga desde la URL proporcionada." >&2
    exit 2
fi
