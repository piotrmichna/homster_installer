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
MYSQL_ROOT_PASS="hi24biscus"

function serwer_param(){
    local EX=1
    while [ $EX -eq 1 ] ; do
        local menux[0]=" HTML_ROOT "
        local menux[1]=" Katalog główny serwera www [$HTML_ROOT] "
        local menux[2]=" HTML_DOC "
        local menux[3]=" Katalog usługi www [$HTML_DOC] "
        local menux[4]=" MYSQL_USER "
        local menux[5]=" Użytkownik usługi MySQL [$MYSQL_USER] "
        local menux[6]=" MySQL_PASS "
        local menux[7]=" Hasło użytkownika usługi MySQL [$MySQL_PASS] "
        local menux[8]=" MYSQL_ROOT_PASS "
        local menux[9]=" Hasło root serwera MySQL [$MYSQL_ROOT_PASS] "
        local menux[10]=" Koniec "
        local menux[11]=" Powrót do poprzedniego menu. "
        menulist_var -m "Wybierz paramet do zmiany:" -t " | Konfigurator usługi | "

        case $INP_VAR in
        " HTML_ROOT ")
            input_var -t " | HTML_ROOT | " -w 60 -m "Podaj ścieżkę do katalogu głównego dla serwera www." -v "$HTML_ROOT"
            if [ $EX_STAT = 0 ]; then
                HTML_ROOT=$INP_VAR
            fi
            ;;
        " HTML_DOC ")
            input_var -t " | HTML_DOC | " -w 60 -m "Podaj katalog usługi www. \'.\' oznacza katalog główny serwera www." -v "$HTML_DOC"
            if [ $EX_STAT = 0 ]; then
                HTML_DOC=$INP_VAR
            fi
            ;;
        " MYSQL_USER ")
            input_var -t " | MYSQL_USER | " -w 60 -m "Podaj nazwę użytkownik MySQL dla usługi www." -v "$MYSQL_USER"
            if [ $EX_STAT = 0 ]; then
                MYSQL_USER=$INP_VAR
            fi
            ;;
        " MySQL_PASS ")
            input_var -t " | MySQL_PASS | " -w 60 -m "Podaj hasło użytkownik MySQL dla usługi www." -v "$MySQL_PASS"
            if [ $EX_STAT = 0 ]; then
                MySQL_PASS=$INP_VAR
            fi
            ;;
        " MYSQL_ROOT_PASS ")
            input_var -t " | MYSQL_ROOT_PASS | " -w 60 -m "Podaj hasło użytkownik root dla MySQL." -v "$MYSQL_ROOT_PASS"
            if [ $EX_STAT = 0 ]; then
                MYSQL_ROOT_PASS=$INP_VAR
            fi
            ;;
        " Koniec ")
            EX=0
            ;;
       esac
    done
}

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
            serwer_param
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
