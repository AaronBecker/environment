# .bashrc
# For interactive non-login shells
# and non-interactive non-login ssh shells.
# For login shells (interactive or not) see first of
# ~/.bash_profile, ~/.bash_login and ~/.profile.
# For other non-interactive non-login shells see $BASH_ENV.
# This is sourced by ~/.bash_profile so runs for all
# interactive shells (login or not).
#
# If the shell isn't actually interactive it is an ssh session, and
# we want to source /etc/profile and ~/.profile instead. We can't
# use a simple test of $PS1 and must test $- because /etc/bashrc
# (also sourced when bash detects ssh) sets $PS1. (We empty it
# here.)
if echo $- | grep -q i ; then : ; else
  test -r /etc/profile && source /etc/profile
  PS1=
  test -r ~/.bash_profile && source ~/.bash_profile
  return
fi

# Completion, if available
test -r /etc/bash_completion && source /etc/bash_completion
test -r ~/.git-completion.sh && source ~/.git-completion.sh

# grep options
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'

# python startup
export PYTHONSTARTUP="$HOME/.pythonrc.py"

# readline options
bind "set completion-ignore-case on"
bind "set bell-style none"
bind "set show-all-if-ambiguous On"

shopt -s checkwinsize           # prevent incorrect wrapping on window size
shopt -s dotglob                # include dotfiles in globs

#autojump
# This shell snippet sets the necessary aliases
if [ $SHELL = "/bin/bash" ] && [ -n "$PS1" ]; then
    _autojump()
    {
            local cur
            COMPREPLY=()
            cur=${COMP_WORDS[1]}
            IFS=$'\n' read -d '' -a COMPREPLY < <(autojump --completion "$cur")
            return 0
    }
    complete -F _autojump j
    alias jumpstat="autojump --stat"
    function j { new_path="$(autojump $@)";if [ -n "$new_path" ]; then echo -e "\\033[31m${new_path}\\033[0m"; echo; cd "$new_path";fi }
fi


# List file sizes in the current directory
function ducks {
    if [ $# -eq 0 ]
    then
        du -ks * | sort -n | awk '{print $2}' | xargs du -sh
    else
        du -ks $* | sort -n | awk '{print $2}' | xargs du -sh
    fi
}

alias myip='curl -s http://whatismyip.org/; echo '

# uses linux-style ls, on macs do port install coreutils +with_default_names
export CLICOLOR=1
alias ls="ls --color"
alias sl="ls"
alias l="ls"
alias s="ls"

alias vi="vim"

export COLOR_NC="\[\e[0m\]"
export COLOR_NONE="\[\e[0m\]"
export COLOR_WHITE="\[\e[1;37m\]"
export COLOR_BLACK="\[\e[0;30m\]"
export COLOR_BLUE="\[\e[0;34m\]"
export COLOR_LIGHT_BLUE="\[\e[1;34m\]"
export COLOR_GREEN="\[\e[0;32m\]"
export COLOR_LIGHT_GREEN="\[\e[1;32m\]"
export COLOR_CYAN="\[\e[0;36m\]"
export COLOR_LIGHT_CYAN="\[\e[1;36m\]"
export COLOR_RED="\[\e[0;31m\]"
export COLOR_LIGHT_RED="\[\e[1;31m\]"
export COLOR_PURPLE="\[\e[0;35m\]"
export COLOR_LIGHT_PURPLE="\[\e[1;35m\]"
export COLOR_BROWN="\[\e[0;33m\]"
export COLOR_YELLOW="\[\e[1;33m\]"
export COLOR_GRAY="\[\e[1;30m\]"
export COLOR_LIGHT_GRAY="\[\e[0;37m\]"

function parse_git_branch {
    [[ -d $(git rev-parse --git-dir 2> /dev/null) ]] || return 1
    git_status="$(git status 2> /dev/null)"
    branch_pattern="^# On branch ([^${IFS}]*)"
    remote_pattern="# Your branch is (.*)"
    diverge_pattern="# Your branch and (.*) have diverged"
    if [[ ! ${git_status}} =~ "working directory clean" ]]; then
        state="${COLOR_RED}⚡"
    fi
    # add an else if or two here if you want to get more specific
    if [[ ${git_status} =~ ${remote_pattern} ]]; then
        if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
            remote="${COLOR_YELLOW}↑"
        else
            remote="${COLOR_YELLOW}↓"
        fi
    fi
    if [[ ${git_status} =~ ${diverge_pattern} ]]; then
        remote="${COLOR_YELLOW}↕"
    fi
    if [[ ${git_status} =~ ${branch_pattern} ]]; then
        branch=${BASH_REMATCH[1]}
        echo " (${branch})${remote}${state}"
    fi
}

function prompt_command() {
    PS1="${TITLEBAR}\u@\h:${COLOR_LIGHT_BLUE}\W${COLOR_GREEN}$(parse_git_branch)${COLOR_NONE} \$ "
    autojump -a "$(pwd -P)"
}

PROMPT_COMMAND=prompt_command

export PS2='> '
export PS3='#? '
export PS4='+'

# ssh tunneling convenience function
function tunnel {
    if [ $# -lt 2 ]
    then
        echo "$0 <port> <server>"
        echo "Leading @ signs are allowed on the server."
    fi

    port=$1
    server=${2##*@}

    case "$port" in
        syn)
            port=24800
            ;;
        gk)
            port=19150
            ;;
        [^0-9]*)
            echo "Error: didn't recognize $port"
            exit 1
            ;;
    esac

    runfile=~/.tunnel-$port.pid
    if [ -e $runfile ]
    then
        kill `cat $runfile`
        rm -f $runfile
    fi

    ssh -N -L ${port}:${server}:$port $server &
    echo $! > $runfile
    disown %1
}


# rot13 a given string
function rot13 {
    echo $1 | perl -ple "y/A-Za-z/N-ZA-Mn-za-m/;"
}

