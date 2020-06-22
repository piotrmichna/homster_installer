# /bin/bash
#   l_param.sh

#   lista parametrow instalatora
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

CUR_DATE=$(date +"%F") #data
USR="piot"
SERVICE_DESCRIPTION="HOMSTER - system sterowania"
SERVICE_NAME="homster.service"
SERVICE_DIR="homster_dev"
HOME_DIR="/home/${USR}"
LOG_FILENAME="log"

LOG_FILE="${LOG_FILENAME}_${CUR_DATE}.log"
SRCDO="${HOME_DIR}/${SERVICE_DIR}"

HTML_ROOT="/var/www/html"
HTML_DOC="."
MYSQL_USER="pituEl"
MySQL_PASS="hi24biscus"
MYSQL_ROOT_PASS="hi24biscus"
