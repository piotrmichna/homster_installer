#! /bin/bash

#   instalator i konfigurator systemu HOMSTER
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

#   sprawdzenie czy wykonano konfiguracje raspberry pi
EX_CNF=0
EX_CNF=$( localectl status | grep -c LANG=pl_PL.UTF-8 )

MAIN_TITLE=" | HOMSTER - Instalator | "

#   definicja pozycji menu
if [ $EX_CNF -eq 0 ] ; then
    MAIN_MESSAGE="Piotr Michna\npm@piotrmichna.pl\n\nNależy wykonać wstępną konfiguracje [sudo raspi-config] dla:\nUstawienia językowe\nStrefa czasowa"
    menux[2]="2)"
    menux[3]="Raspberry konfigurator."
    menux[14]="8)"
    menux[15]="Koniec."
else
    MAIN_MESSAGE="Piotr Michna\npm@piotrmichna.pl\n\nWybierz zadanie do wykonania:"
    menux[0]="1)"
    menux[1]="Wykonaj wszystkio bez konfiguracji."
    menux[4]="3)"
    menux[5]="Konfiguracja."
    menux[6]="4)"
    menux[7]="Uaktualnienia i Aktualizacja sytemu."
    menux[8]="5)"
    menux[9]="Instalacja programów narzędziowych (VIM, Git, Tmux, bc...)"
    menux[10]="6)"
    menux[11]="Instalacja servera www (Nginx, PHP, MySQL)."
    menux[12]="7)"
    menux[13]="Instalacja usługi systemowej."
    menux[14]="8)"
    menux[15]="Koniec."
fi

EX=1
#   petla wyswietlania menu instalatora
while [ $EX -eq 1 ] ; do
    CHOICE=$( whiptail --title "$MAIN_TITLE" --menu "$MAIN_MESSAGE" 20 120 7 "${menux[@]}" 3>&2 2>&1 1>&3 )
    case $CHOICE in
        "1)")
            whiptail \
            --backtitle "Backtitle" \
            --title " | Wykonaj wszystkio bez konfiguracji | " \
            --msgbox "Jeszcze nie zdefiniowane..." \
            8 78
            ;;
        "2)")
            sudo raspi-config
            EX=0
            ;;
        "3)")
            whiptail \
            --backtitle "Backtitle" \
            --title " | Konfiguracja | " \
            --msgbox "Jeszcze nie zdefiniowane..." \
            8 78
            ;;
        "4)")
            sudo apt-get update | TERM=ansi whiptail --title "HOMSTER - Instalator" --infobox "Aktualizacja systemu..." 8 78
            sudo apt-get upgrade | TERM=ansi whiptail --title "HOMSTER - Instalator" --infobox "Uaktualnianie systemu..." 8 78
            sudo apt-get autoremove | TERM=ansi whiptail --title "HOMSTER - Instalator" --infobox "Usuwanie zbędnych pakietów..." 8 78
            ;;
        "5)")
            whiptail \
            --backtitle "Backtitle" \
            --title " | Instalacja programów narzędziowych | " \
            --msgbox "Jeszcze nie zdefiniowane..." \
            8 78
            ;;
        "6)")
            whiptail \
            --backtitle "Backtitle" \
            --title " | Instalacja servera www | " \
            --msgbox "Jeszcze nie zdefiniowane..." \
            8 78
            ;;
        "7)")
            whiptail \
            --backtitle "Backtitle" \
            --title " | Instalacja usługi systemowej | " \
            --msgbox "Jeszcze nie zdefiniowane..." \
            8 78
            ;;
        "8)")
            EX=0
        ;;
    esac
done
