# /bin/bash

#   instalator i konfigurator systemu HOMSTER
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

source l_checklist.sh
source l_menulist.sh
source l_input.sh


CUR_DATE=$(date +"%F") #data
USR="piot"
SERVICE_DESCRIPTION="HOMSTER - system sterowania"
SERVICE_NAME="homster.service"
SERVICE_DIR="homster_dev"
HOME_DIR="/home/${USR}"
LOG_FILENAME="log"

LOG_FILE="${LOG_FILENAME}_${CUR_DATE}.log"
SRCDO="${HOME_DIR}/${SERVICE_DIR}"

function parametry_conf(){
    local EX=1

    while [ $EX -eq 1 ] ; do
        local menux[0]=" USR"
        local menux[1]=" Nazwa użytkownika [$USR]. "
        local menux[2]=" SERVICE_DESCRIPTION"
        local menux[3]=" Opis usługi systemowej [$SERVICE_DESCRIPTION]. "
        local menux[4]=" SERVICE_NAME"
        local menux[5]=" Nazwa usługi systemowej [$SERVICE_NAME]. "
        local menux[6]=" SERVICE_DIR"
        local menux[7]=" Katalog usługi systemowej [$SERVICE_DIR]. "
        local menux[8]=" LOG_FILENAME"
        local menux[9]=" Plik do zapisu informacji [$LOG_FILENAME]. "
        local menux[10]=" Wyjście"
        local menux[11]=" Zamknij to okno."
        menulist_var -m "Wybierz parametr do zmiany:" -t " | Konfigurator Parametrów | " -w 100
        case $INP_VAR in
        " USR")
            input_var -t " | USR | " -w 60 -m "Podaj nazwę użytkownika:"  -v "$USR"
            if [ $EX_STAT = 0 ]; then
                USR=$INP_VAR
            fi
            ;;
        " SERVICE_DESCRIPTION")
            input_var -t " | SERVICE_DESCRIPTION | " -w 60 -m "Podaj opis usługi systemowej:"  -v "$SERVICE_DESCRIPTION"
            if [ $EX_STAT = 0 ]; then
                SERVICE_DESCRIPTION=$INP_VAR
            fi
            ;;
        " SERVICE_NAME")
            input_var -t " | SERVICE_NAME | " -w 60 -m "Podaj nazwe usługi stetemowej:"  -v "$SERVICE_NAME"
            if [ $EX_STAT = 0 ]; then
                SERVICE_NAME=$INP_VAR
            fi
            ;;
        " SERVICE_DIR")
            input_var -t " | SERVICE_DIR | " -w 60 -m "Podaj nazwę katalogu usługi:"  -v "$SERVICE_DIR"
            if [ $EX_STAT = 0 ]; then
                SERVICE_DIR=$INP_VAR
            fi
            ;;
        " LOG_FILENAME")
           echo "$LOG_FILENAME"
            input_var -t " | LOG_FILENAME | " -w 60 -m "Podaj nazwe pliku:"  -v "$LOG_FILENAME"
            if [ $EX_STAT = 0 ]; then
                LOG_FILENAME=$INP_VAR
            fi
            ;;
        " Wyjście")
            EX=0
            ;;
        esac
    done
}
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

    checklist_var -m "Wybierz zadanie do wykonania::" -t " | Instalator oprogramowania narzędziowego | "
    local n=0
    for i in ${INP_VAR[@]} ; do
        local RE[$n]=$( echo "$i" | tr -d \" )
        #install_prog ${RE[$n]}
        if [ ${RE[$n]} = "PARAMETRY" ] ; then
            parametry_conf
            n=$(( n+1 ))
            continue
        fi
        if [ ${RE[$n]} = "vim" ] ; then
            vim_config
            n=$(( n+1 ))
            continue
        fi
        if [ ${RE[$n]} = "git" ] ; then
            git_config
            n=$(( n+1 ))
            continue
        fi
        n=$(( n+1 ))
    done
    #clear
}
