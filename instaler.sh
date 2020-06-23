#! /bin/bash

#   instalator i konfigurator systemu HOMSTER
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

source l_param.sh
source lib_narzedzia.sh
source lib_config.sh
source lib_serwer.sh
source lib_service.sh
source lib_install.sh

#   sprawdzenie czy wykonano konfiguracje raspberry pi
EX_CNF=0
EX_CNF=$( localectl status | grep -c LANG=pl_PL.UTF-8 )

function install_all(){
    echo -e "--->UPDATE" |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    TERM=ansi whiptail --title "- UPDATE -" --infobox "Aktualizacja systemu" 8 70
    sudo apt-get update |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    echo -e "--->UPGRADE" |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    TERM=ansi whiptail --title "- UPDATE -" --infobox "Uaktualnienie systemu" 8 70
    sudo apt-get upgrade -y |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    echo -e "--->AUTOREMOWE" |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    TERM=ansi whiptail --title "- UPDATE -" --infobox "Usuwanie zbednych pakietów systemu" 8 70
    sudo apt-get autoremove -y |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null

    echo -e "--->NARZĘDZIA" |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    TERM=ansi whiptail --title "- NARZĘDZIA -" --infobox "Instalacja oprogramowania narzędziowego" 8 70
    install_prog "vim"
    install_prog "git"
    install_prog "tmux"
    install_prog "bc"
    install_prog "gtkterm"
    install_prog "wiringpi"
    echo -e "--->KONFIGURACJA NARZĘDZI" |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    TERM=ansi whiptail --title "- KONFIGURACJA -" --infobox "Konfiguracja oprogramowania Vim" 8 70
    vim_config
    git_config
    echo -e "--->INSTALL SERVER" |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    TERM=ansi whiptail --title "- SERVER WWW -" --infobox "Instalacja oprogramowania serwera www" 8 70
    php_install
    maridb_install
    echo -e "--->CONFIG SERWER" |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    TERM=ansi whiptail --title "- CONFIG SERWER -" --infobox "Konfiguracja oprogramowania serwera" 8 70
    serwer_conf

    dpkg -s "phpmyadmin" &> /dev/null
    if [ $? -eq 0 ] ; then
        echo "---> phpmyadmin JEST JUŻ ZAINSTALOWANY" >> ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
        TERM=ansi whiptail --title "- phpmyadmin -" --infobox "phpmyadmin był już zainstalowany" 8 70
    else
        echo "--->INSTALL" >> ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
        TERM=ansi whiptail --title "INSTALATOR - phpmyadmin" --infobox "Oprogramowanie phpmyadmin zostało pomyślnie zainstalowane." 8 70
        sudo apt-get install phpmyadmin -y |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    fi
    clear
    phpmyadmin_conf

    echo -e "--->INSTALL SERVICE" |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    TERM=ansi whiptail --title "- UPDATE -" --infobox "Aktualizacja systemu" 8 70
    service_install
    echo -e "--->END" |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    clear
}

function main(){
    MAIN_TITLE=" | HOMSTER - Instalator | "
    local EX=1
    #   petla wyswietlania menu instalatora
    while [ $EX -eq 1 ] ; do
    #   definicja pozycji menu
        if [ $EX_CNF -eq 0 ] ; then
            MAIN_MESSAGE="Piotr Michna\npm@piotrmichna.pl\n\nNależy wykonać wstępną konfiguracje [sudo raspi-config] dla:\nUstawienia językowe\nStrefa czasowa"
            menux[2]=" 2)"
            menux[3]=" Raspberry konfigurator. "
            menux[14]=" 8)"
            menux[15]=" Koniec."
        else
            MAIN_MESSAGE="Piotr Michna\npm@piotrmichna.pl\n\nWybierz zadanie do wykonania:"
            menux[0]=" 1)"
            menux[1]=" Instaluj wszystkio domyślnie bez konfiguracji. "
            menux[4]=" 3)"
            menux[5]=" Konfiguracja Narzędzi."
            menux[6]=" 4)"
            menux[7]=" Uaktualnienia i Aktualizacja sytemu. "
            menux[8]=" 5)"
            menux[9]=" Instalator programów narzędziowych (VIM, Git, Tmux, bc...) "
            menux[10]=" 6)"
            menux[11]=" Instalacja servera www (Nginx, PHP, MySQL). "
            menux[12]=" 7)"
            menux[13]=" Instalacja usługi systemowej [$SERVICE_DESCRIPTION] "
            menux[14]=" 8)"
            menux[15]=" Koniec."
        fi
        CHOICE=$( whiptail --title "$MAIN_TITLE" --menu "$MAIN_MESSAGE" 20 120 7 "${menux[@]}" 3>&2 2>&1 1>&3 )
        case $CHOICE in
        " 1)")
            install_all
            ;;
        " 2)")
            sudo raspi-config
            EX=0
            ;;
        " 3)")
            clear
            narzedzia_cnf
            ;;
        " 4)")
            clear
            sudo apt-get update | TERM=ansi whiptail --title "HOMSTER - Instalator" --infobox "Aktualizacja systemu..." 8 78
            sudo apt-get upgrade | TERM=ansi whiptail --title "HOMSTER - Instalator" --infobox "Uaktualnianie systemu..." 8 78
            sudo apt-get autoremove | TERM=ansi whiptail --title "HOMSTER - Instalator" --infobox "Usuwanie zbędnych pakietów..." 8 78
            ;;
        " 5)")
            clear
            narzedzia_install
            ;;
        " 6)")
            serwer_install
            ;;
        " 7)")
            service_main
            ;;
        " 8)")
            EX=0
            ;;
        esac
    done
    clear
}
main
