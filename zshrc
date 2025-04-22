autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'
setopt PROMPT_SUBST
setopt EXTENDED_HISTORY

NEWLINE=$'\n'
PROMPT='%F{green}%*%f %B%F{blue}%n@%1m:%~%f%b %F{red}${vcs_info_msg_0_}%f${NEWLINE}$ '

docker_cleanup() {
    docker rm -v $(docker ps -a -q 2>/dev/null) 2>/dev/null
    docker rmi $(docker images -a -q 2>/dev/null) --force 2>/dev/null
}

docker_stop_all() {
    docker ps | awk '{ if (NR > 1) { print $1 } }' | xargs docker stop
}

cleanup_old_git_branches() {
    git branch -vv | grep "\: gone" | awk '{print $1}' > /tmp/branchesToRemove.txt && vi /tmp/branchesToRemove.txt && xargs git branch -D </tmp/branchesToRemove.txt
    rm /tmp/branchesToRemove.txt
}
