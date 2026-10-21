#!/bin/bash

# Definición dinámica de rutas para asegurar portabilidad
DIR_BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARCHIVO_LOG="$DIR_BASE/logs/ping_report_9232.log"

# Asegurar que el directorio logs exista
mkdir -p "$DIR_BASE/logs"

# Obtener fecha/hora y la IP del gateway por defecto
FECHA_HORA=$(date +'%Y-%m-%d %H:%M:%S')
GATEWAY=$(ip route | grep default | awk '{print $3}')

# Registrar en el log y hacer 4 pings al gateway
echo "[$FECHA_HORA] Iniciando diagnóstico de red al gateway: $GATEWAY" >> "$ARCHIVO_LOG"
ping -c 4 "$GATEWAY" >> "$ARCHIVO_LOG"
echo "---------------------------------------------------" >> "$ARCHIVO_LOG"




