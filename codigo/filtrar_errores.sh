#!/bin/bash

# Detectar la carpeta donde está alojado este script
CARPETA_SCRIPT=$(dirname "$0")

# Armar las rutas relativas a partir de la ubicación del script
ARCHIVO_LOG="$CARPETA_SCRIPT/../recursos/syslog_prueba.txt"
ARCHIVO_SALIDA="$CARPETA_SCRIPT/../logs/reporte_errores_9232.txt"

# Validar que el archivo de prueba exista y se pueda leer
if [ ! -r "$ARCHIVO_LOG" ]; then
    echo "Error: No se encuentra o no se puede leer el archivo de prueba en $ARCHIVO_LOG"
    exit 1
fi

# Crear carpeta de logs si no existe
mkdir -p "$CARPETA_SCRIPT/../logs"

# Imprimir encabezado del reporte
printf "%-12s | %-10s | %-15s | %-50s\n" "FECHA" "HORA" "PROCESO" "MENSAJE" > "$ARCHIVO_SALIDA"
printf "%.100s\n" "----------------------------------------------------------------------------------------------------" >> "$ARCHIVO_SALIDA"

# Procesamiento con awk
awk '
tolower($0) ~ /error|fail|critical/ {

    # Separar el proceso por corchetes o dos puntos usando Regex correcta (//)
    split($5, proc, /\[|:/)
    proceso = proc[1]

    mensaje = ""
    for (i=6; i<=NF; i++) {
        mensaje = mensaje $i " "
    }

    mensaje = substr(mensaje, 1, 50)

    printf "%-12s | %-10s | %-15s | %-50s\n", $1" "$2, $3, proceso, mensaje
}
' "$ARCHIVO_LOG" >> "$ARCHIVO_SALIDA"

echo "Reporte generado exitosamente en: $ARCHIVO_SALIDA"
