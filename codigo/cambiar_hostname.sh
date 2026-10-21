#!/bin/bash

# 1. Verificar si el script se ejecuta con privilegios de administrador (root)
if [[ $EUID -ne 0 ]]; then
    echo "Error: Este script debe ejecutarse con privilegios elevados. Uso: sudo $0 <nuevo_hostname>" >&2
    exit 1
fi

# Capturar el primer argumento
NUEVO_HOSTNAME="$1"

# Guardar el nombre actual en una variable antes de cambiarlo
VIEJO_HOSTNAME=$(hostname)

# 2. Validar que no se haya enviado vacío
if [ -z "$NUEVO_HOSTNAME" ]; then
    echo "Error: Debe ingresar un nombre. Uso: sudo $0 <nuevo_hostname>"
    exit 1
fi

# 3. Validar la nomenclatura mediante una Expresión Regular (Regex)
if [[ ! "$NUEVO_HOSTNAME" =~ ^[a-zA-Z0-9]([a-zA-Z0-9\-]*[a-zA-Z0-9])?$ ]]; then
    echo "Error: Nomenclatura inválida. El hostname solo puede contener letras, números y guiones intermedios."
    exit 1
fi

# 4. Crear backups de los archivos críticos antes de modificarlos
echo "Generando copias de seguridad (backup):"
echo " -> El archivo /etc/hostname se respaldó en: /etc/hostname.bak"
echo " -> El archivo /etc/hosts se respaldó en: /etc/hosts.bak"

cp /etc/hostname /etc/hostname.bak
cp /etc/hosts /etc/hosts.bak

# 5. Cambiar el hostname en el sistema
echo "Aplicando el nuevo nombre de host: $NUEVO_HOSTNAME"
hostnamectl set-hostname "$NUEVO_HOSTNAME"

# 6. Reemplazar el nombre viejo por el nuevo en /etc/hosts
sed -i "s/127.0.1.1.*/127.0.1.1\t$NUEVO_HOSTNAME/g" /etc/hosts

echo "El hostname se ha cambiado exitosamente de '$VIEJO_HOSTNAME' a '$NUEVO_HOSTNAME'"
echo " Puede que necesite reiniciar la terminal para ver los cambios."
