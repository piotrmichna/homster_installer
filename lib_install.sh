#! /bin/bash
#   lib_install.sh

#   instalator i konfigurator systemu HOMSTER
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

function install_prog(){
    local mess=""
    dpkg -s $1 &> /dev/null
    if [ $? -eq 0 ] ; then
        TERM=ansi whiptail --title "- $1 -" --infobox "$1 był już zainstalowany" 8 70
    else
        sudo apt-get install -y $1 &> /dev/null
        TERM=ansi whiptail --title "INSTALATOR - $1" --infobox "Oprogramowanie $1 zostało pomyślnie zainstalowane." 8 70
    fi
}
