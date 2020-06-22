# /bin/bash
#   lib_serwer.sh

#   instalator i konfigurator systemu HOMSTER
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

source lib_install.sh
source l_checklist.sh

function php_install(){
    sudo apt-get install php php-cli php-fpm -y &> /dev/null
}

function maridb_install(){
    sudo apt-get install mariadb-server-10.0 mariadb-client-10.0 php-mysql -y &> /dev/null
}
function serwer_install(){
    local menux[0]="nginx"
    local menux[1]="Serwer www."
    local menux[2]="on"
    local menux[3]="php"
    local menux[4]="Interperter skryptów PHP."
    local menux[5]="on"
    local menux[6]="mariadb"
    local menux[7]="Serwer baz danych MySQL. "
    local menux[8]="on"
    local menux[9]="phpmyadmin"
    local menux[10]="Interfejs www do zarządzania bazami MySQL. "
    local menux[11]="on"
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
#serwer_install
