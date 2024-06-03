#!/bin/bash

# ==================================================================================================
# ========================| Comprobamos si ejecutas el script como root. |==========================
# ==================================================================================================
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script debe ser ejecutado con privilegios de superusuario (sudo)"
    exit 1
fi
# ==================================================================================================



# ==================================================================================================
# =====================| Pedimos nombre de usuario para hacer las operaciones |=====================
# ==================================================================================================
echo "¿Cual es el nombre del usuario que estas usando ahora mismo?"
read usuario
# ==================================================================================================



# ==================================================================================================
# ===================| Actualizamos los repositorios y actualizamos el sistema. |===================
# ==================================================================================================
clear
echo "Actualizando sistema y repositorio..."
sleep 3

dnf update -y
dnf upgrade -y
# ==================================================================================================



# ==================================================================================================
# ======================| Eliminamos los paquetes innecesarios del sistema. |=======================
# ==================================================================================================
bloat_packages=(
    libreoffice* rhythmbox gnome-system-monitor firefox* thunderbird*
    gnome-boxes gnome-tour snapshot 
)

clear
echo "Desinstalando bloat del sistema..."
sleep 3

for package in "${bloat_packages[@]}"; do
    dnf remove "$package" -y
done
# ==================================================================================================



# ==================================================================================================
# ======================| Limpiamos todo lo que haya podido quedar por ahí. |=======================
# ==================================================================================================
clear
echo "Eliminando archivos o paquetes residuales..."
sleep 3

dnf autoremove -y
# ==================================================================================================



# ==================================================================================================
# ===================| Función para verificar si Google Chrome está instalado. |====================
# ==================================================================================================
is_installed() {
    rpm -q "$1" &> /dev/null
}
# ==================================================================================================



# ==================================================================================================
# =================| Instalar Google Chrome en el caso de que no este instalado. |==================
# ==================================================================================================
clear
if ! is_installed "google-chrome-stable"; then
    echo "Descargando Google Chrome..."
    sleep 3
    wget -O googleChrome.rpm https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
    
    clear
    echo "Instalando Google Chrome..."
    sleep 3
    dnf install wget -y
    dnf install ./googleChrome.rpm -y
else
    clear
    echo "Google Chrome ya está instalado, saltando este paso."
    sleep 3
fi
# ==================================================================================================



# ==================================================================================================
# ==========================| Instalación de otras aplicaciones útiles. |===========================
# ==================================================================================================
clear
echo "Instalando aplicaciones de interés."
sleep 3

dnf install neofetch -y
echo 'neofetch' >> /home/$usuario/.bashrc

dnf install gnome-extensions-app -y
dnf install plymouth-plugin-script -y
dnf install gnome-music -y
dnf install bpytop -y
dnf install make -y
# ==================================================================================================



# ==================================================================================================
# ======================| Aquí se aplican los cambios estéticos a Fedora 40 |=======================
# ==================================================================================================
clear
echo "Aplicando configuración estética en el sistema..."
sleep 1

cp ./user /home/$usuario/.config/dconf/

echo "Aplicando nueva fuente en el sistema..."
sleep 1

cp ./user /home/$usuario/.config/dconf/
mkdir -p /usr/share/fonts/truetype/productSans
cp ./productSans.ttf /usr/share/fonts/truetype/productSans/
# ==================================================================================================



# ==================================================================================================
# ==================================| Fondos de pantalla nuevos. |==================================
# ==================================================================================================
echo "Aplicando nuevo fondo de escritorio..."
sleep 1

rm /usr/share/backgrounds/f40/default/*
cp ./Backgrounds/* /usr/share/backgrounds/f40/default/
# ==================================================================================================



# ==================================================================================================
# ========================| Cambiamos el Plymouth de arranque del sistema. |========================
# ==================================================================================================
echo "Aplicando nuevo Plymouth de arranque del sistema..."
sleep 1

mkdir /usr/share/plymouth/themes/deb10
cp ./Plymouth/* /usr/share/plymouth/themes/deb10/
rm /etc/default/grub
cp ./System/grub /etc/default/
rm /usr/share/plymouth/plymouthd.defaults
cp ./System/plymouthd.defaults /usr/share/plymouth/
rm /etc/plymouth/plymouthd.conf
cp ./System/plymouthd.conf /etc/plymouth/
dracut -f
# ==================================================================================================



# ==================================================================================================
# ================================| Aplicamos la barra de tareas. |=================================
# ==================================================================================================
echo "Aplicando configuración de la barra de tareas..."
sleep 1

mkdir /home/$usuario/.local/share/gnome-shell/extensions/
cp -r ./Extensions/dash-to-dock@micxgx.gmail.com /home/$usuario/.local/share/gnome-shell/extensions/
# ==================================================================================================



# ==================================================================================================
# =========| El script ha terminado su ejecución, el equipo se reiniciara en 5 segundos. |==========
# ==================================================================================================
clear
echo "Fin del script de personalización de Fedora 40!"
echo "Reiniciando en 5 segundos para aplicar cambios..."
sleep 5
reboot
# ==================================================================================================
