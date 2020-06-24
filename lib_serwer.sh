# /bin/bash
#   lib_serwer.sh

#   instalator i konfigurator systemu HOMSTER
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

source lib_install.sh
source l_checklist.sh
source l_menulist.sh
source l_input.sh
source l_param.sh

function serwer_conf(){
    if [ $LOG_FLAG -eq 0 ] ; then
        cd ${HOME_DIR}
        snum=$( echo `sudo ls | grep -c "${LOG_FILENAME}_$currentDate.log"` )
        if [ $snum -gt 0 ] ; then
            sudo rm ${LOG_FILENAME}_$currentDate.log
            LOG_FLAG=1
        fi
        touch ${LOG_FILENAME}_$currentDate.log
    fi
    sudo dpkg -s nginx &> /dev/null
    if [ $? -eq 0 ] ; then
        echo "--->CONFIG Nginx " |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log
        cd /etc/nginx/sites-available/
        sudo mv default default.back
        sudo touch default

        sudo dd of=default << EOF
##
# You should look at the following URL's in order to grasp a solid understanding
# of Nginx configuration files in order to fully unleash the power of Nginx.
# https://www.nginx.com/resources/wiki/start/
# https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/
# https://wiki.debian.org/Nginx/DirectoryStructure
#
# In most cases, administrators will remove this file from sites-enabled/ and
# leave it as reference inside of sites-available where it will continue to be
# updated by the nginx packaging team.
#
# This file will automatically load configuration files provided by other
# applications, such as Drupal or Wordpress. These applications will be made
# available underneath a path with that package name, such as /drupal8.
#
# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
##

# Default server configuration
#
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	# SSL configuration
	#
	# listen 443 ssl default_server;
	# listen [::]:443 ssl default_server;
	#
	# Note: You should disable gzip for SSL traffic.
	# See: https://bugs.debian.org/773332
	#
	# Read up on ssl_ciphers to ensure a secure configuration.
	# See: https://bugs.debian.org/765782
	#
	# Self signed certs generated by the ssl-cert package
	# Don't use them in a production server!
	#
	# include snippets/snakeoil.conf;

	root $HTML_ROOT;

	# Add index.php to the list if you are using PHP
	index index.php index.html index.htm;

	server_name localhost;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files \$uri \$uri/ /index.php\$is_args\$args;
	}

	# pass PHP scripts to FastCGI server
	#
	location ~ \.php {
	#	include snippets/fastcgi-php.conf;
	#
	#	# With php-fpm (or other unix sockets):
		fastcgi_index index.php;
		fastcgi_pass unix:/run/php/php7.3-fpm.sock;
		fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
		include fastcgi_params;
	#	# With php-cgi (or other tcp sockets):
	#	fastcgi_pass 127.0.0.1:9000;
	}

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	location ~ /\.ht {
		deny all;
	}
}
EOF

    fi
    sudo dpkg -s mariadb-server-10.0 &> /dev/null
    if [ $? -eq 0 ] ; then
        echo " --->CONFIG MariaDB " |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log
        sudo mysql --user=root <<EOF
DROP USER 'root'@'localhost';
CREATE USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASS';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MySQL_PASS';
GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'localhost' WITH GRANT OPTION;
EOF
    fi
    sudo systemctl restart nginx.service
    echo " ---> RESTART nginx " |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log
}
function phpmyadmin_conf(){

    echo " --->CONFIG phpmyadmin " |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log

    sudo phpenmod mbstring
    sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
    local muser=$( echo `sudo mysql -Dmysql -u root -p$MYSQL_ROOT_PASS -N -e"SELECT COUNT(1) FROM user WHERE User='phpmyadmin';"`)
    #echo "mysql -Dmysql -u root -p$MYSQL_ROOT_PASS -N -eSELECT COUNT(1) FROM user WHERE User='phpmyadmin';"
    if [ $muser -eq 0 ] ; then
        sudo mysql --user=root --password=$MYSQL_ROOT_PASS<<EOF
USE mysql;
CREATE USER 'phpmyadmin'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASS';
GRANT ALL PRIVILEGES ON *.* TO 'phpmyadmin'@'localhost' WITH GRANT OPTION;
EOF

    else
        sudo mysql --user=root --password=$MYSQL_ROOT_PASS<<EOF
USE mysql;
DROP USER 'phpmyadmin'@'localhost';
CREATE USER 'phpmyadmin'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASS';
GRANT ALL PRIVILEGES ON *.* TO 'phpmyadmin'@'localhost' WITH GRANT OPTION;
EOF

    fi
echo " ---> RESTART nginx " |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log
sudo systemctl restart nginx.service

echo " ---> REPAIR phpmyadmin " |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log
cd ${HOME_DIR}
cd /install/phpmyadmin_err
echo pwd |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log
sudo cp /usr/share/phpmyadmin/libraries/sql.lib.php /usr/share/phpmyadmin/libraries/sql.lib.php.bak
sudo cp /usr/share/phpmyadmin/libraries/plugin_interface.lib.php /usr/share/phpmyadmin/libraries/plugin_interface.lib.php.bak
sudo cp sql.lib.php /usr/share/phpmyadmin/libraries/sql.lib.php
sudo cp plugin_interface.lib.php /usr/share/phpmyadmin/libraries/plugin_interface.lib.php

}

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
    if [ $LOG_FLAG -eq 0 ] ; then
        cd ${HOME_DIR}
        snum=$( echo `sudo ls | grep -c "${LOG_FILENAME}_$currentDate.log"` )
        if [ $snum -gt 0 ] ; then
            sudo rm ${LOG_FILENAME}_$currentDate.log
            LOG_FLAG=1
        fi
        touch ${LOG_FILENAME}_$currentDate.log
    fi
    TERM=ansi whiptail --title "- Serwer www -" --infobox "Instalacja php" 8 70
    install_prog "php"
    TERM=ansi whiptail --title "- Serwer www -" --infobox "Instalacja php-cli" 8 70
    install_prog "php-cli"
    TERM=ansi whiptail --title "- Serwer www -" --infobox "Instalacja php-fpm" 8 70
    install_prog "php-fpm"
    TERM=ansi whiptail --title "- Serwer www -" --infobox "Instalacja php-mbstring" 8 70
    install_prog "php-mbstring"
    TERM=ansi whiptail --title "- Serwer www -" --infobox "Instalacja php-gettext" 8 70
    install_prog "php-gettext"
    TERM=ansi whiptail --title "- Serwer www -" --infobox "Instalacja php-mysql" 8 70
    install_prog "php-mysql"
    clear
}

function maridb_install(){
    if [ $LOG_FLAG -eq 0 ] ; then
        cd ${HOME_DIR}
        snum=$( echo `sudo ls | grep -c "${LOG_FILENAME}_$currentDate.log"` )
        if [ $snum -gt 0 ] ; then
            sudo rm ${LOG_FILENAME}_$currentDate.log
            LOG_FLAG=1
        fi
        touch ${LOG_FILENAME}_$currentDate.log
    fi
    TERM=ansi whiptail --title "- Serwer www -" --infobox "Instalacja mariadb-server-10.0" 8 70
    install_prog "mariadb-server-10.0"
    TERM=ansi whiptail --title "- Serwer www -" --infobox "Instalacja mariadb-client-10.0" 8 70
    install_prog "mariadb-client-10.0"
    TERM=ansi whiptail --title "- Serwer www -" --infobox "Instalacja php-mysql" 8 70
    clear
}
function phpmyadmin_install(){
    if [ $LOG_FLAG -eq 0 ] ; then
        cd ${HOME_DIR}
        snum=$( echo `sudo ls | grep -c "${LOG_FILENAME}_$currentDate.log"` )
        if [ $snum -gt 0 ] ; then
            sudo rm ${LOG_FILENAME}_$currentDate.log
            LOG_FLAG=1
        fi
        touch ${LOG_FILENAME}_$currentDate.log
    fi
    clear
    sudo dpkg -s "phpmyadmin" &> /dev/null
    if [ $? -eq 0 ] ; then
       echo "---> phpmyadmin JEST JUŻ ZAINSTALOWANY" >> ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
        TERM=ansi whiptail --title "- phpmyadmin -" --infobox "phpmyadmin był już zainstalowany" 8 70
    else
       echo "--->INSTALL" >> ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
        TERM=ansi whiptail --title "INSTALATOR - phpmyadmin" --infobox "Instalacja oprogramowania phpmyadmin." 8 70
        sudo apt-get install phpmyadmin |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log
    fi
    clear
}

function serwer_install(){
    local menux[0]="parametry"
    local menux[1]=" Parametry konfiguracji serwera. "
    local menux[2]="off"
    local menux[3]="Nginx"
    local menux[4]=" Serwer www. "
    local menux[5]="on"
    local menux[6]="PHP"
    local menux[7]=" Interperter skryptów PHP. "
    local menux[8]="on"
    local menux[9]="MariaDB"
    local menux[10]=" Serwer baz danych MySQL. "
    local menux[11]="on"
    local menux[12]="phpmyadmin"
    local menux[13]=" Interfejs www do zarządzania bazami MySQL. "
    local menux[14]="on"
    local menux[15]="konf. serwera www"
    local menux[16]=" Konfiguracja serwera www. "
    local menux[17]="off"
    local menux[18]="konf. phpmyadmin"
    local menux[19]=" Konfiguracja phpmyadmin "
    local menux[20]="off"

    checklist_var -m "Wybierz oprogramowanie do zainstalowania:" -t " | Instalator oprogramowania serwera www | "
    local n=0
    for i in ${INP_VAR[@]} ; do
        local RE[$n]=$(echo "$i" | tr -d \" )
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
        if [ ${RE[$n]} = "phpmyadmin" ] ; then
            phpmyadmin_install
            n=$(( n+1 ))
            continue
        fi
        if [ ${RE[$n]} = "konf. serwera www" ] ; then
            serwer_conf
            n=$(( n+1 ))
            continue
        fi
        if [ ${RE[$n]} = "konf. phpmyadmin" ] ; then
            phpmyadmin_conf
            n=$(( n+1 ))
            continue
        fi
        if [ ${RE[$n]} = "parametry" ] ; then
            serwer_param
            n=$(( n+1 ))
            continue
        fi
    done
    clear
}

