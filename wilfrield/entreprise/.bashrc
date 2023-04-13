# Celeonet

PATH="${PATH}:${CONFIG_PATH}/entreprise/bin:/usr/local/mysql/bin:/usr/local/mysql-5.7/bin:/usr/local/pureftpd/bin:/usr/local/pureftpd/sbin:/usr/local/dovecot/bin:/usr/local/bin:/root/celeo-tools/espacedisque:/root/celeo-tools/spamfighters"
SSH_ENV="$HOME/.ssh/environment"

# Aliases (al something)
[ -f ${CONFIG_PATH}/entreprise/aliasme/aliasme.sh ] && source ${CONFIG_PATH}/entreprise/aliasme/aliasme.sh

# Inputrc
bind -f ${CONFIG_PATH}/entreprise/.inputrc

function sshr {
    ssh -t "r.nentousi@noc.celeo.fr"@${1} 'sudo bash -rcfile /home/r.nentoussi@noc.celeo.fr/.config/rahal/std/.bashrc'
}

function sshn {
    ssh -t root@${1} 'bash -rcfile /root/.config/rahal/std/.bashrc'
}

