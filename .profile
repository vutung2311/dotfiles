# for WSL2
# set github environment value
export GITHUB_ACTOR=redacted
export GITHUB_TOKEN=redacted

# Github
git config \
    --global \
    --replace-all \
    url."https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/finblox/".insteadOf \
    "https://github.com/finblox/"

# setup awscli environment values
export AWS_PROFILE=redacted

# use code for kubectl
export KUBE_EDITOR='code -w'

# tty for GPG
export GPG_TTY=$(tty)

# for docker-compose
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1 