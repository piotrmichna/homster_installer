#!/bin/bash
#   lib_narzedzia.sh

#   instalator i konfigurator systemu HOMSTER
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

source lib_install.sh
source l_checklist.sh


function narzedzia_install(){
    local menux[0]="vim"
    local menux[1]="Edytor tekstu dla terminala."
    local menux[2]="on"
    local menux[3]="git"
    local menux[4]="Narzędzie kontroli wersji."
    local menux[5]="on"
    local menux[6]="bc"
    local menux[7]="Osługa działań na liczgach dzisiętnych."
    local menux[8]="on"
    local menux[9]="tmux"
    local menux[10]="Multiplekser terminala."
    local menux[11]="on"
    local menux[12]="gtkterm"
    local menux[13]="Terminal komunikacji UART."
    local menux[14]="on"
    local menux[15]="wiringpi"
    local menux[16]="Biblioteka obsługi GPIO."
    local menux[17]="on"
    checklist_var -m "Wybierz zadanie do wykonania::" -t " | Instalator oprogramowania narzędziowego | "
    local n=0
    for i in ${INP_VAR[@]} ; do
        local RE[$n]=$( echo "$i" | tr -d \" )
        install_prog ${RE[$n]}
        #echo "${RE[$n]}"
        n=$(( n+1 ))
    done
    clear
}
