#!/bin/bash

#   instalator i konfigurator systemu HOMSTER
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

source l_checklist.sh
source l_menulist.sh
source l_input.sh
source l_param.sh

function vim_config(){
    if [ $LOG_FLAG -eq 0 ] ; then
        local snum=$( echo `ls | grep -c ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log ` )
        if [ $snum -gt 0 ] ; then
            sudo rm ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log
        fi
        touch ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log
        LOG_FLAG=1
    fi
    echo "---->CONFIG Vim " |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    touch ${HOME_DIR}/.vimrc
    cat > ${HOME_DIR}/.vimrc <<EOF
syntax on
set mouse=a
set background=dark
set smartindent
set shiftwidth=2
set tabstop=2
set number
set hlsearch
set incsearch
EOF

sudo cp ${HOME_DIR}/.vimrc /root
}


function git_config(){
    if [ $LOG_FLAG -eq 0 ] ; then
        local snum=$( echo `ls | grep -c ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log ` )
        if [ $snum -gt 0 ] ; then
            sudo rm ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log
        fi
        touch ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log
        LOG_FLAG=1
    fi
    echo "---->CONFIG Git " |& tee -a ${HOME_DIR}/${LOG_FILENAME}_$currentDate.log &> /dev/null
    local editor="nano"
    dpkg -s vim &> /dev/null
    if [ $? -eq 0 ] ; then
        editor="vim"
    fi
    touch ${HOME_DIR}/.gitconfig &> /dev/null
    cat > ${HOME_DIR}/.gitconfig <<EOF
[user]
	email = pm@piotrmichna.pl
	name = Piotr Michna
[core]
	editor = $editor
[alias]
	ll = log -n 30 --all --oneline --graph
	lll = log --all --oneline --graph
	ap = add -p
	cc = commit
	cm = checkout master
	st = status
	cb = checkout -
EOF

}


function parametry_conf(){
    local EX=1

    while [ $EX -eq 1 ] ; do
        local menux[0]=" USR"
        local menux[1]=" Nazwa użytkownika [$USR]. "
        local menux[2]=" SERVICE_DESCRIPTION"
        local menux[3]=" Opis usługi systemowej [$SERVICE_DESCRIPTION]. "
        local menux[4]=" SERVICE_NAME"
        local menux[5]=" Nazwa usługi systemowej [$SERVICE_NAME]. "
        local menux[6]=" SERVICE_DIR"
        local menux[7]=" Katalog usługi systemowej [$SERVICE_DIR]. "
        local menux[8]=" LOG_FILENAME"
        local menux[9]=" Plik do zapisu informacji [$LOG_FILENAME]. "
        local menux[10]=" Wyjście"
        local menux[11]=" Zamknij to okno."
        menulist_var -m "Wybierz parametr do zmiany:" -t " | Konfigurator Parametrów | " -w 100
        case $INP_VAR in
        " USR")
            input_var -t " | USR | " -w 60 -m "Podaj nazwę użytkownika:"  -v "$USR"
            if [ $EX_STAT = 0 ]; then
                USR=$INP_VAR
            fi
            ;;
        " SERVICE_DESCRIPTION")
            input_var -t " | SERVICE_DESCRIPTION | " -w 60 -m "Podaj opis usługi systemowej:"  -v "$SERVICE_DESCRIPTION"
            if [ $EX_STAT = 0 ]; then
                SERVICE_DESCRIPTION=$INP_VAR
            fi
            ;;
        " SERVICE_NAME")
            input_var -t " | SERVICE_NAME | " -w 60 -m "Podaj nazwe usługi stetemowej:"  -v "$SERVICE_NAME"
            if [ $EX_STAT = 0 ]; then
                SERVICE_NAME=$INP_VAR
            fi
            ;;
        " SERVICE_DIR")
            input_var -t " | SERVICE_DIR | " -w 60 -m "Podaj nazwę katalogu usługi:"  -v "$SERVICE_DIR"
            if [ $EX_STAT = 0 ]; then
                SERVICE_DIR=$INP_VAR
            fi
            ;;
        " LOG_FILENAME")
          echo "$LOG_FILENAME"
            input_var -t " | LOG_FILENAME | " -w 60 -m "Podaj nazwe pliku:"  -v "$LOG_FILENAME"
            if [ $EX_STAT = 0 ]; then
                LOG_FILENAME=$INP_VAR
            fi
            ;;
        " Wyjście")
            EX=0
            ;;
        esac
    done
    clear
}

function narzedzia_cnf(){
    local menux[0]="PARAMETRY"
    local menux[1]="Zmień parametry konfiguracyjne."
    local menux[2]="off"
    local n=3
    sudo dpkg -s vim &> /dev/null
    if [ $? -eq 0 ] ; then
        local menux[$n]="vim"
        n=$(( n+1 ))
        local menux[$n]="Konfiguracja vima."
        n=$(( n+1 ))
        local menux[$n]="on"
        n=$(( n+1 ))
    fi
    sudo dpkg -s git &> /dev/null
    if [ $? -eq 0 ] ; then
        local menux[$n]="git"
        n=$(( n+1 ))
        local menux[$n]="Konfiguracja gita."
        n=$(( n+1 ))
        local menux[$n]="on"
        n=$(( n+1 ))
    fi

    checklist_var -m "Wybierz zadanie do wykonania::" -t " | Instalator oprogramowania narzędziowego | "
    local n=0
    for i in ${INP_VAR[@]} ; do
        local RE[$n]=$(echo "$i" | tr -d \" )
        #install_prog ${RE[$n]}
        if [ ${RE[$n]} = "PARAMETRY" ] ; then
            parametry_conf
            n=$(( n+1 ))
            continue
        fi
        if [ ${RE[$n]} = "vim" ] ; then
            vim_config
            n=$(( n+1 ))
            continue
        fi
        if [ ${RE[$n]} = "git" ] ; then
            git_config
            n=$(( n+1 ))
            continue
        fi
        n=$(( n+1 ))
    done
    clear
}
