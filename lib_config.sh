# /bin/bash

#   instalator i konfigurator systemu HOMSTER
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

source l_checklist.sh
source l_menulist.sh
source l_input.sh


CUR_DATE=$(date +"%F") #data
SERVICE_DIR="homster_dev"
USR="pi"
SERVICE_NAME="homster.service"
HOME_DIR="/home/pi"
LOG_FILENAME="log"

LOG_FILE="${LOG_FILENAME}_${CUR_DATE}.log"
SRCDO="${HOME_DIR}/${SERVICE_DIR}"

function narzedzia_cnf(){
    local menux[0]="PARAMETRY"
    local menux[1]="Zmień parametry konfiguracyjne."
    local menux[2]="off"
    local n=3
    dpkg -s vim &> /dev/null
    if [ $? -eq 0 ] ; then
        local menux[$n]="vim"
        n=$(( n+1 ))
        local menux[$n]="Konfiguracja vima."
        n=$(( n+1 ))
        local menux[$n]="on"
        n=$(( n+1 ))
    fi
    dpkg -s git &> /dev/null
    if [ $? -eq 0 ] ; then
        local menux[$n]="git"
        n=$(( n+1 ))
        local menux[$n]="Konfiguracja gita."
        n=$(( n+1 ))
        local menux[$n]="on"
        n=$(( n+1 ))
    fi
    dpkg -s phpmyadmin &> /dev/null
    if [ $? -eq 0 ] ; then
        local menux[$n]="phpmyadmin"
        n=$(( n+1 ))
        local menux[$n]="Konfiguracja phpmyadmin."
        n=$(( n+1 ))
        local menux[$n]="off"
        n=$(( n+1 ))
    fi

    checklist_var -m "Wybierz zadanie do wykonania::" -t " | Instalator oprogramowania narzędziowego | "
    local n=0
    for i in ${INP_VAR[@]} ; do
        local RE[$n]=$( echo "$i" | tr -d \" )
        #install_prog ${RE[$n]}
        echo "${RE[$n]}"
        n=$(( n+1 ))
    done
    #clear
}
narzedzia_cnf
