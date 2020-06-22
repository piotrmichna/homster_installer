# /bin/bash
#   lib_service.sh

#   lista parametrow instalatora
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

source l_menulist.sh
source l_input.sh
source l_param.sh

function service_list(){
    local EX=1
    while [ $EX -eq 1 ] ; do
        local n=0
        for (( i=0 ; i<N_SERVICE_NUM ; i++ )) ; do
            local menux[$n]="$i"
            n=$(( n+1 ))
            local menux[$n]=" ${N_SERVICE_DESCRIPTION[$i]}. "
            n=$(( n+1 ))
        done
        local menux[$n]="Koniec"
        n=$(( n+1 ))
        local menux[$n]=" Powrót do konfiguratora usługi. "
        menulist_var -m "Wybierz usługę systemową do zainstalowania" -t " | Lista usług systemowych | " -w 100
        if [ "$INP_VAR" = "Koniec" ] ; then
            EX=0
        else
            USR=${N_USR[$INP_VAR]}
            SERVICE_DESCRIPTION=${N_SERVICE_DESCRIPTION[$INP_VAR]}
            SERVICE_NAME=${N_SERVICE_NAME[$INP_VAR]}
            SERVICE_DIR=${N_SERVICE_DIR[$INP_VAR]}
            HTML_DOC=${N_HTML_DOC[$INP_VAR]}
            MYSQL_USER=${N_MYSQL_USER[$INP_VAR]}
            MySQL_PASS=${N_MySQL_PASS[$INP_VAR]}
            EX=0
        fi
    done
}

function service_main(){
    local EX=1
    while [ $EX -eq 1 ] ; do
        local menux[0]=" Zmień"
        local menux[1]=" $SERVICE_DESCRIPTION. "
        local menux[2]=" Parametry"
        local menux[3]=" Edytuj parametry wybranej usługi. "
        local menux[4]=" Wykonaj"
        local menux[5]=" Instaluj wybraną usługę systemową. "
        local menux[6]=" Koniec"
        local menux[7]=" Powrót do głównego instalatora. "
        menulist_var -m "Wybierz zadanie do wykonania:" -t " | Konfigurator usługi systemowej | " -w 100
        case $INP_VAR in
        " Zmień")
            service_list
            ;;
        " Parametry")
            service_edit
            ;;
        " Wykonaj")
            input_var -t " | SERVICE_NAME | " -w 60 -m "Podaj nazwe usługi stetemowej:"  -v "$SERVICE_NAME"
            if [ $EX_STAT = 0 ]; then
                SERVICE_NAME=$INP_VAR
            fi
            ;;
        " Koniec")
            EX=0
            ;;
        esac
    done
}
service_main
