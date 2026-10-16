#!/bin/bash

# Toma el archivo pasado como argumento, o usa el syslog real por defecto
ARCHIVO_LOG=${1:-/var/log/syslog}
ARCHIVO_SALIDA="logs/reporte_errores_9232.txt"

# Crear carpeta de logs si no existe
mkdir -p logs

# Imprimir encabezado del reporte
printf "%-12s | %-10s | %-15s | %-50s\n" "FECHA" "HORA" "PROCESO" "MENSAJE" > "$ARCHIVO_SALIDA"
printf "%.100s\n" "----------------------------------------------------------------------------------------------------" >> "$ARCHIVO_SALIDA"

# Procesamiento con awk
awk '
# 1. Filtrar líneas (ignorando mayúsculas/minúsculas)
tolower($0) ~ /error|fail|critical/ {

    # 2. Limpiar el nombre del proceso (Columna 5)
    split($5, proc, "[\[:]")
    proceso = proc[1]

    # 3. Reconstruir el mensaje a partir de la columna 6
    mensaje = ""
    for (i=6; i<=NF; i++) {
        mensaje = mensaje $i " "
    }

    # 4. Recortar a un máximo de 50 caracteres
    mensaje = substr(mensaje, 1, 50)

    # 5. Imprimir con formato de ancho fijo (printf)
    printf "%-12s | %-10s | %-15s | %-50s\n", $1" "$2, $3, proceso, mensaje
}
' "$ARCHIVO_LOG" >> "$ARCHIVO_SALIDA"

echo "Reporte generado exitosamente en: $ARCHIVO_SALIDA"
