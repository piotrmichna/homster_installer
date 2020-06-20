# /bin/bash
#   lib_narzedzia.sh

#   instalator i konfigurator systemu HOMSTER
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

source lib_install.sh

function narzedzia_install(){
    local MSG="Piotr Michna\npm@piotrmichna.pl\n\nWybierz zadanie do wykonania:"
    local RESS=$(
    whiptail --checklist --title " | Instalator programów narzędziowych | " "$MSG" 20 70 6 \
    "vim" "Edytor tekstu." on \
    "git" "System kontroli wersji." on \
    "bc" "Osługa działań na liczgach dzisiętnych." on \
    "phpmyadmin" "Interfejs www do zarządzania bazami MySQL.  " off \
    "tmux" "Multiplekser terminala." on 3>&2 2>&1 1>&3
    )

    local RES=($RESS)
    local n=0
    for i in ${RES[@]} ; do
        RE[$n]=$( echo "$i" | tr -d \" )
        install_prog ${RE[$n]}
        n=$(( n+1 ))
    done
    clear
}
narzedzia_install
