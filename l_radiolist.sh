# /bin/bash
#   l_radiolist.sh
#
#   funkcja wyswietlajaca okno dialogowem radiolist
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl
#--
#   wywolanei funkcji:
#       radiolist_var -m "Wybierz paramet do zmiany:" -t " | Konfigurator usługi | "
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

menux[0]="1)"
menux[1]="Tytuł usługi."
menux[2]="on"
menux[3]="2)"
menux[4]="Nazwa usługi."
menux[5]="off"
menux[6]="3)"
menux[7]="Nazwa użytkownika."
menux[8]="off"
menux[9]="4)"
menux[10]="Koniec."
menux[11]="off"

