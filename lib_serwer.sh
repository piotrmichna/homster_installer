# /bin/bash
#   lib_serwer.sh

#   instalator i konfigurator systemu HOMSTER
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

source lib_install.sh
source l_checklist.sh
source l_menulist.sh
source l_input.sh

HTML_ROOT="/var/www/html"
HTML_DOC="."
MYSQL_USER="pituEl"
MySQL_PASS="hi24biscus"
MYSQL_ROOT_PAS="hi24biscus"

function php_install(){
    sudo apt-get install php php-cli php-fpm php-mbstring php-gettext -y &> /dev/null
}

function maridb_install(){
    sudo apt-get install mariadb-server-10.0 mariadb-client-10.0 php-mysql -y &> /dev/null
}

function serwer_install(){
    local menux[0]="Nginx"
    local menux[1]=" Serwer www. "
    local menux[2]="on"
    local menux[3]="PHP"
    local menux[4]=" Interperter skryptów PHP. "
    local menux[5]="on"
    local menux[6]="MariaDB"
    local menux[7]=" Serwer baz danych MySQL. "
    local menux[8]="on"
    local menux[9]="phpmyadmin"
    local menux[10]=" Interfejs www do zarządzania bazami MySQL. "
    local menux[11]="off"
    local menux[12]="konfiguracja"
    local menux[13]=" Konfiguracja serwera www. "
    local menux[14]="on"
    local menux[12]="parametry"
    local menux[13]=" Parametry konfiguracji serwera. "
    local menux[14]="off"
    checklist_var -m "Wybierz oprogramowanie do zainstalowania:" -t " | Instalator oprogramowania serwera www | "
    local n=0
    for i in ${INP_VAR[@]} ; do
        local RE[$n]=$( echo "$i" | tr -d \" )
        if [ ${RE[$n]} = "Nginx" ] ; then
            install_prog "nginx"
            n=$(( n+1 ))
            continue
        fi
        if [ ${RE[$n]} = "PHP" ] ; then
            php_install
            n=$(( n+1 ))
            continue
        fi
        if [ ${RE[$n]} = "MariaDB" ] ; then
            mariadb_install
            n=$(( n+1 ))
            continue
        fi
        if [ ${RE[$n]} = "konfiguracja" ] ; then
            serwer_conf
            n=$(( n+1 ))
            continue
        fi
        if [ ${RE[$n]} = "parametry" ] ; then
            serwer_conf
            n=$(( n+1 ))
            continue
        else
            install_prog ${RE[$n]}
            n=$(( n+1 ))
        fi

        #echo "${RE[$n]}"

    done
    clear
}
#serwer_install
