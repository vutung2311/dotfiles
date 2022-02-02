
# for WSL2
# alias for pbcopy and pbpaste
alias pbcopy="clip.exe"
alias pbpaste="powershell.exe -command 'Get-Clipboard' | head -n -1"

# start dockerd
if [ ! -d /sys/fs/cgroup/systemd ]; then
    sudo mkdir -p /sys/fs/cgroup/systemd
    sudo mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd
fi
sudo service docker start

# kubectl shell autocompletion
source <(kubectl completion bash)

add_key_if_not_exist() {
	ssh-add -l | grep "$(ssh-keygen -lf $1 | head -c 20)" -q || ssh-add $1 2>/dev/null
}
# loading ssh key for tung.v@vtijs.com
# add_key_if_not_exist $HOME/.ssh/tung.v@vtijs.com.private

# terraform bash autocomplete
complete -C /usr/bin/terraform terraform

git_tag_and_push() {
  export TAG=$1; \
    git tag --delete $TAG; \
    git tag $TAG; \
    git push --delete origin $TAG; \
    git push origin $TAG
}

# set DISPLAY variable to the IP automatically assigned to WSL2
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
sudo service dbus start >/dev/null 2>&1

# relay GPG agent socket and GPG SSH agent socket
# detect what we have
set -ex
if [ $(uname -a | grep -c "Microsoft") -eq 1 ]; then
    export ISWSL=1 # WSL 1
elif [ $(uname -a | grep -c "microsoft") -eq 1 ]; then
    export ISWSL=2 # WSL 2
else
    export ISWSL=0
fi
if [ ${ISWSL} -eq 1 ]; then
    # WSL 1 could use AF_UNIX sockets from Windows side directly
    if [ -n ${WSL_AGENT_HOME} ]; then
        export GNUPGHOME=${WSL_AGENT_HOME}
        export SSH_AUTH_SOCK=${WSL_AGENT_HOME}/S.gpg-agent.ssh
    fi
elif [ ${ISWSL} -eq 2 ]; then
    powershell.exe 'agent-gui.exe' &
    ${HOME}/.local/bin/win-gpg-agent-relay start
    export SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh
fi
set +ex