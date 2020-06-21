# /bin/bash
#   l_radiolist.sh
#
#   funkcja wyswietlajaca okno dialogowem radiolist
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl
#--
#   wywolanei funkcji:
#       radiolist_var -h 20 -w 60 -ln 4 -m "Podaj hasło." -t "Hasło"
#       -h   wysokość okna  [liczba]
#       -w   szerokość okna  [liczba]
#       -ln  liczba wierszy [liczba]
#       -t  "Tytuł okna"
#       -m  "tekst z informacja"
#--

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

