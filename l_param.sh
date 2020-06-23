# /bin/bash
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
USR="piot"
SERVICE_DESCRIPTION="HOMSTER - system sterowania"
SERVICE_NAME="homster.service"
SERVICE_DIR="homster_dev"
HOME_DIR="/home/${USR}"
LOG_FILENAME="log"

LOG_FILE="${LOG_FILENAME}_${currentDate}.log"
SRCDO="${HOME_DIR}/${SERVICE_DIR}"

HTML_ROOT="/var/www/html"
HTML_DOC="."
MYSQL_USER="pituEl"
MySQL_PASS="hi24biscus"
MYSQL_ROOT_PASS="hi24biscus"
GIT_HTML="html.git"
GIT_BASH="bash.git"

N_SERVICE_NUM=2
N_USR[0]="piot"
N_SERVICE_DESCRIPTION[0]="HOMSTER - system sterowania"
N_SERVICE_NAME[0]="homster.service"
N_SERVICE_DIR[0]="homster_dev"

N_HTML_DOC[0]="."
N_MYSQL_USER[0]="pituEl"
N_MySQL_PASS[0]="hi24biscus"
N_GIT_HTML[0]="html.git"
N_GIT_BASH[0]="bash.git"

N_USR[1]="pi"
N_SERVICE_DESCRIPTION[1]="JASPP - system sterowania Garowni"
N_SERVICE_NAME[1]="jaspp.service"
N_SERVICE_DIR[1]="jaspp_dev"

N_HTML_DOC[1]="."
N_MYSQL_USER[1]="pituEl"
N_MySQL_PASS[1]="hi24biscus"
N_GIT_HTML[1]="html_gar.git"
N_GIT_BASH[1]="bash_gar.git"
