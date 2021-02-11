#!/bin/bash
#   l_param.sh

#   lista parametrow instalatora
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

RED="\e[0;31m"
GREEN="\e[0;32m"
BLUE="\e[0;34m"
NC="\e[0m"

LOG_FLAG=0

currentDate=$(date +"%F") #data
USR="pi"
SERVICE_DESCRIPTION="JASPP - system sterowania Garowni"
SERVICE_NAME="jaspp.service"
SERVICE_DIR="jaspp_dev"
HOME_DIR="/home/${USR}"
LOG_FILENAME="log"

LOG_FILE="${LOG_FILENAME}_${currentDate}.log"
SRCDO="${HOME_DIR}/${SERVICE_DIR}"

HTML_ROOT="/var/www/html"
HTML_DOC="."
MYSQL_USER="uSer"
MySQL_PASS="test_password1"
MYSQL_ROOT_PASS="test_password1"
GIT_HTML="html_gar.git"
GIT_BASH="bash_gar.git"

N_SERVICE_NUM=2
N_USR[0]="pi"
N_SERVICE_DESCRIPTION[0]="HOMSTER - system sterowania"
N_SERVICE_NAME[0]="homster.service"
N_SERVICE_DIR[0]="homster_dev"

N_HTML_DOC[0]="."
N_MYSQL_USER[0]="uSer"
N_MySQL_PASS[0]="test_password0"
N_GIT_HTML[0]="html.git"
N_GIT_BASH[0]="bash.git"

N_USR[1]="pi"
N_SERVICE_DESCRIPTION[1]="JASPP - system sterowania Garowni"
N_SERVICE_NAME[1]="jaspp.service"
N_SERVICE_DIR[1]="jaspp_dev"

N_HTML_DOC[1]="."
N_MYSQL_USER[1]="uSer"
N_MySQL_PASS[1]="test_password1"
N_GIT_HTML[1]="html_gar.git"
N_GIT_BASH[1]="bash_gar.git"
