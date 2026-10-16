#!/bin/bash

# 1. Verificar si el script se ejecuta con privilegios de administrador (root)
if [[ $EUID -ne 0 ]]; then
    echo "Error: Este script debe ejecutarse con privilegios elevados. Utilice 'sudo'." >&2
    exit 1
fi

# 2. Verificar que se haya ingresado exactamente un parámetro (el nuevo nombre)
if [ "$#" -ne 1 ]; then
    echo "Error: Debe ingresar un nuevo nombre de host como parámetro (sin espacios)." >&2
    exit 1
fi

NUEVO_HOSTNAME="$1"
VIEJO_HOSTNAME=$(hostname)

# 3. Modificar /etc/hostname con el nuevo nombre
echo "$NUEVO_HOSTNAME" > /etc/hostname

# 4. Actualizar /etc/hosts utilizando sed
sed -i "s/$VIEJO_HOSTNAME/$NUEVO_HOSTNAME/g" /etc/hosts

# 5. Aplicar el cambio temporalmente en la sesión actual para no tener que reiniciar
hostname "$NUEVO_HOSTNAME"

echo "El nombre de host ha sido cambiado exitosamente de '$VIEJO_HOSTNAME' a '$NUEVO_HOSTNAME'."
