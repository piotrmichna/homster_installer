# /bin/bash
#   l_input.sh

INP_VAR=0
EX_STAT=0

function input_var(){
    local typ="i"
    local tyt="Tytuł"
    local message="Komnetarz do zawartosci"
    local valu=""
    local width=78

    if [ $typ = "p" ] ; then
        INP_VAR=$(whiptail --passwordbox "$message" 8 $width "$valu" --title "$tyt" 3>&1 1>&2 2>&3)
    else
        INP_VAR=$(whiptail --inputbox "$message" 8 $width "$valu" --title "$tyt" 3>&1 1>&2 2>&3)
    fi
    EX_STAT=$?
}
