# /bin/bash
#   l_input.sh
#
#   instalator i konfigurator systemu HOMSTER
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl
#--
#   wywolanei funkcji:
#       input_var -t "Hasło" -w 60 -m "Podaj hasło." -p -v "tajne hasło"
#       -p  typ hastla
#       -t  "Tytuł okna"
#       -m  "tekst z informacja"
#       -v  "domyslna wartość zwracanej zmiennej"
#       -w  szerokość okna  [liczba]
#--
#   wynik wykonania:
#       if [ $EX_STAT = 0 ]; then
#           echo "Wprowadzono: " $INP_VAR " i wcisnieto OK"
#       else
#           echo "Anulowano wprowadzanie"
#       fi

INP_VAR=0
EX_STAT=0

function input_var(){
    local typ="i"
    local tyt="Tytuł"
    local message="Komnetarz do zawartosci"
    local valu=""
    local width=78
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
    if [ $typ = "p" ] ; then
        INP_VAR=$(whiptail --passwordbox "$message" 8 $width "$valu" --title "$tyt" 3>&1 1>&2 2>&3)
    else
        INP_VAR=$(whiptail --inputbox "$message" 8 $width "$valu" --title "$tyt" 3>&1 1>&2 2>&3)
    fi
    EX_STAT=$?
}
