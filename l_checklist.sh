# /bin/bash
#   l_radiolist.sh
#
#   funkcja wyswietlajaca okno dialogowem radiolist
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl
#--
#   definicja tablicy wierszy radiolisty
#       menux[0]="1)"
#       menux[1]="Tytuł usługi."
#       menux[2]="on"
#--
#   wywolanei funkcji:
#       checklist_var -m "Wybierz paramet do zmiany:" -t " | Konfigurator usługi | "
#       -h   wysokość okna  [liczba]
#       -w   szerokość okna  [liczba]
#       -ln  liczba wierszy [liczba]
#       -t  "Tytuł okna"
#       -m  "tekst z informacja"
#--
#   wynik wykonania
#       case $INP_VAR in
#       "1)")
#           echo "Tytuł usługi"
#           ;;
#       "2)")
#           echo "Nazwa usługi"
#           ;;
#       "3)")
#           echo "Nazwa użytkownika"
#           ;;
#       "4)")
#           EX=0
#           ;;
#       esac



INP_VAR=0
EX_STAT=0

function radiolist_var(){
    local tyt="Tytuł"
    local message="Piotr Michna\npm@piotrmichna.pl\n"
    local width=78
    local nline=${#menux[@]}
    nline=$(( nline/3 ))
    local height=$(( nline+8 ))

    for (( i=1 ; i<=${#@} ; i++ )) ; do
        tt=$(echo "\$$i" )
        tvar=$(eval echo "$tt")

        if [ $tvar = "-t" ] ; then
            i=$(( i+1 ))
            tt=$(echo "\$$i" )
            tvar=$(eval echo "$tt")
            tyt=$tvar
            continue
        fi
        if [ $tvar = "-m" ] ; then
            i=$(( i+1 ))
            tt=$(echo "\$$i" )
            tvar=$(eval echo "$tt")
            message=$(echo "$message\n$tvar")
            height=$(( height+2 ))
            continue
        fi
        if [ $tvar = "-h" ] ; then
            i=$(( i+1 ))
            tt=$(echo "\$$i" )
            tvar=$(eval echo "$tt")
            height=$tvar
            continue
        fi

        if [ $tvar = "-w" ] ; then
            i=$(( i+1 ))
            tt=$(echo "\$$i" )
            tvar=$(eval echo "$tt")
            width=$tvar
            continue
        fi
        if [ $tvar = "-ln" ] ; then
            i=$(( i+1 ))
            tt=$(echo "\$$i" )
            tvar=$(eval echo "$tt")
            nline=$tvar
            continue
        fi
    done
    INP_VAR=$(whiptail --radiolist "$message" --title "$tyt" $height $width $nline "${menux[@]}" 3>&1 1>&2 2>&3)
    EX_STAT=$?
}
#menux[0]="1)"
#menux[1]="Tytuł usługi."
#menux[2]="on"
#menux[3]="2)"
#menux[4]="Nazwa usługi."
#menux[5]="off"
#menux[6]="3)"
#menux[7]="Nazwa użytkownika."
#menux[8]="off"
#menux[9]="4)"
#menux[10]="Koniec."
#menux[11]="off"
#radiolist_var -m "Wybierz paramet do zmiany:" -t " | Konfigurator usługi | "
