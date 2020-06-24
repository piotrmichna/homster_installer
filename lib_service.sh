# /bin/bash
#   lib_service.sh

#   lista parametrow instalatora
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

source l_menulist.sh
source l_input.sh
source l_param.sh

function service_install(){
    if [ $LOG_FLAG -eq 0 ] ; then
        cd ${HOME_DIR}
        snum=$( echo `sudo ls | grep -c "${LOG_FILENAME}_$currentDate.log"` )
        if [ $snum -gt 0 ] ; then
            sudo rm ${LOG_FILENAME}_$currentDate.log
            LOG_FLAG=1
        fi
        touch ${LOG_FILENAME}_$currentDate.log
    fi
    echo "--->INSTALL ${SERVICE_DESCRIPTION}" |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    TERM=ansi whiptail --title "- ${SERVICE_DESCRIPTION} -" --infobox "Instalacja usługi systemowej" 8 70
    cd /var/www/
    sudo rm -R -f html
    sudo mkdir html
    sudo chown -R www-data:www-data /var/www
    sudo chown -R www-data:www-data /var/www/html
    sudo chmod -R 777 /var/www/html
    cd html
    if [ $HTML_DOC != "." ] ; then
        sudo mkdir $HTML_DOC
        sudo chown -R www-data:www-data /var/www/$HTML_DOC
        sudo chown -R www-data:www-data /var/www/html/$HTML_DOC
        sudo chmod -R 777 /var/www/html/$HTML_DOC
        cd $HTML_DOC
    fi
    echo "--->INSTALL ${SERVICE_DESCRIPTION} git html" |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    TERM=ansi whiptail --title "- ${SERVICE_DESCRIPTION} -" --infobox "Pobieranie repozytorium html" 8 70
    git clone https://Chivito78:hi24biscus@bitbucket.org/Chivito78/${GIT_HTML} . |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null

    dpkg -s phpmyadmin &> /dev/null
    if [ $? -eq 0 ] ; then
        sudo phpenmod mbstring
        sudo phpenmod gettext
        sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
    fi
    sudo systemctl restart nginx.service

    mkdir $SRCDO
    chmod 766 $SRCDO
    cd $SRCDO
    echo "--->INSTALL ${SERVICE_DESCRIPTION} git bash" |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    TERM=ansi whiptail --title "- ${SERVICE_DESCRIPTION} -" --infobox "Pobieranie repozytorium bash" 8 70
    git clone https://Chivito78:hi24biscus@bitbucket.org/Chivito78/${GIT_BASH}  . |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    echo "--->INSTALL ${SERVICE_DESCRIPTION} konfiguracja" |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    TERM=ansi whiptail --title "- ${SERVICE_DESCRIPTION} -" --infobox "Konfiguracja usługi systemowej" 8 70
    chmod 766 ${SRCDO}/.git
    chmod 766 ${SRCDO}/*.*
    local snum=$(echo `ls | grep -c .service` )
    if [ $snum -gt 0 ] ; then
        sudo mkdir back
        sudo mv *.service back/
    fi
    sudo dd of=${SRCDO}/${SERVICE_NAME} <<EOF
    [Unit]
    Description=${SERVICE_DESCRIPTION}
    After=network-online.target

    [Service]
    Type=idle
    User=$USR
    ExecStart=/bin/bash ${SRCDO}/h_main.sh
    WorkingDirectory=${SRCDO}/
    StandardOutput=inherit
    StandardError=inherit
    Restart=always

    [Install]
    WantedBy=multi-user.target
EOF

    sudo chmod 766 ${SRCDO}/${SERVICE_NAME}
    sudo cp ${SRCDO}/${SERVICE_NAME} /lib/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable ${SERVICE_NAME}
    clear
}

function service_edit(){
    local EX=1
    while [ $EX -eq 1 ] ; do
        local menux[0]=" USR"
        local menux[1]=" Nazwa użytkownika systemowego [$USR] "
        local menux[2]=" SERVICE_DESCRIPTION"
        local menux[3]=" Opis usługi [$SERVICE_DESCRIPTION] "
        local menux[4]=" SERVICE_NAME"
        local menux[5]=" Nazwa usługi [$SERVICE_NAME] "
        local menux[6]=" SERVICE_DIR"
        local menux[7]=" Katalog usługi [$SERVICE_DIR] "
        local menux[8]=" HTML_DOC"
        local menux[9]=" Katalog www dla usługi [$HTML_DOC] "
        local menux[10]=" MYSQL_USER"
        local menux[11]=" Użytkownik usługi [$MYSQL_USER] "
        local menux[12]=" MySQL_PASS"
        local menux[13]=" Hasło użytkownika usługi [$MySQL_PASS] "
        local menux[14]=" GIT_HTML"
        local menux[15]=" Repozytorium html usługi [$GIT_HTML] "
        local menux[16]=" GIT_BASH"
        local menux[17]=" Repozytorim bash usługi [$GIT_BASH] "
        local menux[18]=" Koniec"
        local menux[19]=" Powrót do konfiguratora usługi. "
        menulist_var -m "Wybierz wybierz paametr do edycji" -t " | Lista parametrów usługi systemowej | " -w 100
        case $INP_VAR in
        " USR")
            input_var -t " | USR | " -w 60 -m "Podaj nazwe użytkownika:"  -v "$USR"
            if [ $EX_STAT = 0 ]; then
                USR=$INP_VAR
            fi
            ;;
        " SERVICE_DESCRIPTION")
            input_var -t " | SERVICE_DESCRIPTION | " -w 60 -m "Podaj opis usługi stetemowej:"  -v "$SERVICE_DESCRIPTION"
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
            input_var -t " | SERVICE_DIR | " -w 60 -m "Podaj nazwe katalogu dla usługi:"  -v "$SERVICE_DIR"
            if [ $EX_STAT = 0 ]; then
                SERVICE_DIR=$INP_VAR
            fi
            ;;
        " HTML_DOC")
            input_var -t " | HTML_DOC | " -w 60 -m "Podaj nazwe katalogu www usługi (. oznacza katalog główny serwera):"  -v "$HTML_DOC"
            if [ $EX_STAT = 0 ]; then
                HTML_DOC=$INP_VAR
            fi
            ;;
        " MYSQL_USER")
            input_var -t " | MYSQL_USER | " -w 60 -m "Podaj nazwe uźytkownika dla usługi:"  -v "$MYSQL_USER"
            if [ $EX_STAT = 0 ]; then
                MYSQL_USER=$INP_VAR
            fi
            ;;
        " MySQL_PASS")
            input_var -t " | MySQL_PASS | " -w 60 -m "Podaj hasło użytkownika dla usługi:"  -v "$MySQL_PASS"
            if [ $EX_STAT = 0 ]; then
                MySQL_PASS=$INP_VAR
            fi
            ;;
        " GIT_HTML")
            input_var -t " | GIT_HTML | " -w 60 -m "Podaj hasło użytkownika dla usługi:"  -v "$GIT_HTML"
            if [ $EX_STAT = 0 ]; then
                GIT_HTML=$INP_VAR
            fi
            ;;
        " GIT_BASH")
            input_var -t " | GIT_BASH | " -w 60 -m "Podaj hasło użytkownika dla usługi:"  -v "$GIT_BASH"
            if [ $EX_STAT = 0 ]; then
                GIT_BASH=$INP_VAR
            fi
            ;;
        " Koniec")
            EX=0
            ;;
        esac
    done
}

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
            MYSQL_ROOT_PASS=${N_MySQL_PASS[$INP_VAR]}
            GIT_HTML=${N_GIT_HTML[$INP_VAR]}
            GIT_BASH=${N_GIT_BASH[$INP_VAR]}
            HOME_DIR="/home/${USR}"
            LOG_FILE="${LOG_FILENAME}_${CUR_DATE}.log"
            SRCDO="${HOME_DIR}/${SERVICE_DIR}"
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
            service_install
            ;;
        " Koniec")
            EX=0
            ;;
        esac
    done
}
