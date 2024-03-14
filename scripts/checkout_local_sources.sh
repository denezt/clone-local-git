#!/bin/bash
#
#
#
#

error(){
    printf "\033[35mError:\t\033[31m${1}\033[0m\n"
    exit 1
}

extract_value(){
    echo "${1}" | cut -d':' -f2 | cut -d'=' -f2 
}

for argv in $@
do
    case $argv in
        --repo=*|repo:*) REPO_NAME=$(extract_value "${argv}");;
        --sshpass=*|sshpass:*) SSH_PASS=$(extract_value "${argv}");;
        --server=*|server:*) LOCAL_GIT_SERVER=$(extract_value "${argv}");;
        --port=*|port:*) SERVER_PORT=$(extract_value "${argv}");;
        --path=*|path:*) REPO_PATH=$(extract_value "${argv}");;        
    esac
done

if [ -d "${REPO_NAME}" ];
then
    rm -rfv ${REPO_NAME} 
fi

# Check that sshpass program is installed
[ -z "$(command -v sshpass)" ] && error "Missing or unable to find SSHPass Command"
# Check for Git Server Port
[ -z "${SERVER_PORT}" ] && printf "\033[35mWarning: \033[33mno valid port was given.\033[33m\n"

# Check that all other required parameters was given
for VALUE in "REPO_NAME:${REPO_NAME}" "SSH_PASS:${SSH_PASS}" "LOCAL_GIT_SERVER:${LOCAL_GIT_SERVER}" "REPO_PATH:${REPO_PATH}"
do
    [ -z "$(extract_value $VALUE)" ] && error "Missing or did not set $(printf ${VALUE} | cut -d':' -f1)"
done

sshpass -p $SSH_PASS git clone git+ssh://git@${LOCAL_GIT_SERVER}:${SERVER_PORT}${REPO_PATH}.git