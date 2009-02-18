# Completion, if available
test -r /etc/bash_completion && . /etc/bash_completion

# grep options
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'

# python startup
export PYTHONSTARTUP="$HOME/.pythonrc.py"

# readline options
bind "set completion-ignore-case on"
bind "set bell-style none"
bind "set show-all-if-ambiguous On"

# List file sizes in the current directory
alias ducks='du -sk ./* | sort -n | awk '\''BEGIN{ pref[1]="K"; pref[2]="M"; pref[3]="G";} { total = total + $1; x = $1; y = 1; while( x > 1024 ) { x = (x + 1023)/1024; y++; } printf("%g%s\t%s\n",int(x*10)/10,pref[y],$2); } END { y = 1; while( total > 1024 ) { total = (total + 1023)/1024; y++; } printf("Total: %g%s\n",int(total*10)/10,pref[y]); }'\'''

alias myip='curl -s http://whatismyip.org/; echo '

# uses linux-style ls, on macs do port install coreutils +with_default_names
export CLICOLOR=1
alias ls="ls --color"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.flac=01;35:*.mp3=01;35:*.mpc=01;35:*.ogg=01;35:*.wav=01;35:';

export COLOR_NC='\e[0m' # No Color
export COLOR_WHITE='\e[1;37m'
export COLOR_BLACK='\e[0;30m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_GRAY='\e[1;30m'
export COLOR_LIGHT_GRAY='\e[0;37m'

# Prompts
export PS1="\u@\h:\[${COLOR_LIGHT_BLUE}\]\W\[${COLOR_NC}\] \$ "
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


