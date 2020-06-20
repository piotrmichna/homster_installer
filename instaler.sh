#! /bin/bash

#   instalator i konfigurator systemu HOMSTER
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

#   sprawdzenie czy wykonano konfiguracje raspberry pi
EX_CNF=0
EX_CNF=$( localectl status | grep -c LANG=pl_PL.UTF-8 )

MAIN_TITLE=$( " | HOMSTER - Instalator | " )

#   definicja pozycji menu
if [ $EX_CNF -eq 0 ] ; then
    MAIN_MESSAGE=$( "Piotr Michna\npm@piotrmichna.pl\n\nNależy wykonać wstępną konfiguracje [sudo raspi-config] dla:\nUstawienia językowe\nStrefa czasowa" )
    menux[2]="2)"
    menux[3]="Raspberry konfigurator."
    menux[14]="8)"
    menux[15]="Zamknij instalator."
else
    MAIN_MESSAGE=$( "Piotr Michna\npm@piotrmichna.pl\n\nWybierz zadanie do wykonania:" )
    menux[0]="1)"
    menux[1]="Wykonaj wszystkio bez konfiguracji."
    menux[4]="3)"
    menux[5]="Konfiguracja."
    menux[6]="4)"
    menux[7]="Uaktualnienia i Aktualizacja sytemu."
    menux[8]="5)"
    menux[9]="Instalacja programów narzędziowych"
    menux[10]="6)"
    menux[11]="Instalacja servera www (Nginx, PHP, MySQL)."
    menux[12]="7)"
    menux[13]="Instalacja usługi systemowej."
    menux[14]="8)"
    menux[15]="Zamknij instalator."
fi

