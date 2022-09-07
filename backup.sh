#!/bin/bash
#-eE

PATH_DIR=/home/testo
SCRIPT_DIR=${PATH_DIR}/backup_dir/scripts
BACKUP_DIR=${PATH_DIR}/backup_dir/backup
ARCH_DIR=${PATH_DIR}/backup_dir/archive
DATA_DIR=${PATH_DIR}/.near
DATE=$(date +%Y-%m-%d-%H-%M)

echo "`date` INFO: start Backup"

sudo systemctl stop neard
wait
echo "`date` INFO: NEAR node was stopped"

if [ -d "${BACKUP_DIR}" ]; then
    echo "`date` INFO: Backup started"

    cp -rf ${DATA_DIR}/data/ ${BACKUP_DIR}/

    echo "`date` INFO: Data dir copied"
else
    echo "`date` ERROR: ${BACKUP_DIR} Check your permissions."
	sudo systemctl start neard
    echo "`date` INFO: NEAR node was started"
    exit 0
fi

sudo systemctl start neard
echo "`date` INFO: NEAR node was started"

tar -zcvf ${ARCH_DIR}/near_archive_${DATE}.tar.gz ${BACKUP_DIR}

rm -rf ${BACKUP_DIR}/data

"${SCRIPT_DIR}/Send_msg_toTelBot.sh" "$HOSTNAME Server" "INFO: NEAR node Backup completed, file near_archive_${DATE}.tar.gz" 2>&1 > /dev/null

echo "`date` INFO: NEAR node Backup completed, file near_archive_${DATE}.tar.gz"
