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
    echo "ilosc parametrow ${#@}"
    for (( i=1 ; i<=${#@} ; i++ )) ; do
        tt=$(echo "\$$i" )
        tvar=$(eval echo "$tt")
        if [ $tvar = "-p" ] ; then
            typ="p"
            continue
        fi

        if [ $tvar = "-t" ] ; then
            i=$(( i+1 ))
            tt=$(echo "\$$i" )
            tvar=$(eval echo "$tt")
            tyt=$tvar
            continue
        fi
        if [ $tvar = "-v" ] ; then
            i=$(( i+1 ))
            tt=$(echo "\$$i" )
            tvar=$(eval echo "$tt")
            valu=$tvar
            continue
        fi
        if [ $tvar = "-m" ] ; then
            i=$(( i+1 ))
            tt=$(echo "\$$i" )
            tvar=$(eval echo "$tt")
            message=$tvar
            continue
        fi
        if [ $tvar = "-w" ] ; then
            i=$(( i+1 ))
            tt=$(echo "\$$i" )
            tvar=$(eval echo "$tt")
            width=$tvar
            continue
        fi
    done
    echo "parametry ->"
    echo "typ=$typ"
    echo "tyt=$tyt"
    echo "message=$message"
    echo "valu=$valu"
    echo "width=$width"
    #if [ $typ = "p" ] ; then
    #    INP_VAR=$(whiptail --passwordbox "$message" 8 $width "$valu" --title "$tyt" 3>&1 1>&2 2>&3)
    #else
    #    INP_VAR=$(whiptail --inputbox "$message" 8 $width "$valu" --title "$tyt" 3>&1 1>&2 2>&3)
    #fi
    EX_STAT=$?
}

   if [ $EX_STAT = 0 ]; then
       echo "Wprowadzono: " $INP_VAR " i wcisnieto OK"
   else
       echo "Anulowano wprowadzanie"
   fi
