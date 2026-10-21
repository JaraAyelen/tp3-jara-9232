#!/bin/bash

# Variables de identificación
LEGAJO="9232"
TOKEN="92322079"

# Detectar dinámicamente la ruta absoluta del repositorio
DIR_BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARCHIVO_LOG="$DIR_BASE/logs/usuarios_activos_${LEGAJO}.log"

# Asegurar que el directorio logs exista usando la ruta absoluta
mkdir -p "$DIR_BASE/logs"

# Agregar el encabezado si el archivo es nuevo
if [ ! -f "$ARCHIVO_LOG" ]; then
    echo "Legajo: $LEGAJO - Token: $TOKEN" > "$ARCHIVO_LOG"
fi

# Obtener fecha y hora
FECHA_HORA=$(date +'%Y-%m-%d %H:%M:%S')

# Contar el número de usuarios activos conectados
USUARIOS_ACTIVOS=$(who | wc -l)

# Anexar los datos al archivo de log
echo "[$FECHA_HORA] Usuarios activos conectados: $USUARIOS_ACTIVOS" >> "$ARCHIVO_LOG"
