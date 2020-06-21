# /bin/bash

#   instalator i konfigurator systemu HOMSTER
#   autor: Piotr Michna
#   email: pm@piotrmichna.pl

source l_checklist.sh
source l_menulist.sh
source l_input.sh


CUR_DATE=$(date +"%F") #data
SERVICE_DIR="homster_dev"
USR="pi"
SERVICE_NAME="homster.service"
HOME_DIR="/home/pi"
LOG_FILENAME="log"

LOG_FILE="${LOG_FILENAME}_${CUR_DATE}.log"
SRCDO="${HOME_DIR}/${SERVICE_DIR}"
