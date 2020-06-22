# /bin/bash
#   lib_service.sh

#   lista parametrow instalatora
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

source l_menulist.sh
source l_input.sh
source l_param.sh


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
