#! /bin/bash
#   lib_install.sh

#   instalator i konfigurator systemu HOMSTER
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

source l_param.sh

function install_prog(){
    local mess=""
    dpkg -s $1 &> /dev/null
    if [ $? -eq 0 ] ; then
        echo "---> $1 JEST JUŻ ZAINSTALOWANY" |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
        TERM=ansi whiptail --title "- $1 -" --infobox "$1 był już zainstalowany" 8 70
        clear
    else
        echo "--->INSTALL" >> ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
        TERM=ansi whiptail --title "INSTALATOR - $1" --infobox "Trwa instalacja oprogramowania $1." 8 70
        sudo apt-get install -y $1 |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
        clear
    fi
}
