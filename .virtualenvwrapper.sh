#
# Shell functions to act as wrapper for Ian Bicking's virtualenv
# (http://pypi.python.org/pypi/virtualenv)
#

#
# Setup:
#
#  1. Add a line like "export WORKON_HOME=$HOME/.virtualenvs"
#     to your .bashrc.
#  2. Add a line like "source /path/to/this/file/virtualenvwrapper_bashrc"
#     to your .bashrc.
#  3. Run: source ~/.bashrc
#  4. Run: workon
#  5. A list of environments, empty, is printed.
#  6. Run: mkvirtualenv temp
#  7. Run: workon
#  8. This time, the "temp" environment is included.
#  9. Run: workon temp
# 10. The virtual environment is activated.
#

# Make sure there is a default value for WORKON_HOME.
# You can override this setting in your .bashrc.
if [ "$WORKON_HOME" = "" ]
then
    export WORKON_HOME="$HOME/.virtualenvs"
fi

# Verify that the WORKON_HOME directory exists
function virtualenvwrapper_verify_workon_home () {
    if [ ! -d "$WORKON_HOME" ]
    then
        echo "ERROR: Virtual environments directory '$WORKON_HOME' does not exist."
        return 1
    fi
    return 0
}

# Verify that the requested environment exists
function virtualenvwrapper_verify_workon_environment () {
    typeset env_name="$1"
    if [ ! -d "$WORKON_HOME/$env_name" ]
    then
       echo "ERROR: Environment '$env_name' does not exist. Create it with 'mkvirtualenv $env_name'."
       return 1
    fi
    return 0
}

# Verify that the active environment exists
function virtualenvwrapper_verify_active_environment () {
    if [ ! -n "${VIRTUAL_ENV}" ] || [ ! -d "${VIRTUAL_ENV}" ]
    then
        echo "ERROR: no virtualenv active, or active virtualenv is missing"
        return 1
    fi
    return 0
}

function virtualenvwrapper_source_hook () {
    scriptname="$1"
    if [ -f "$scriptname" ]
    then
        source "$scriptname"
    fi
}

function virtualenvwrapper_run_hook () {
    scriptname="$1"
    shift
    if [ -x "$scriptname" ]
    then
        "$scriptname" "$@"
    fi
}

# Create a new environment, in the WORKON_HOME.
#
# Usage: mkvirtualenv [options] ENVNAME
# (where the options are passed directly to virtualenv)
#
function mkvirtualenv () {
    eval "envname=\$$#"
    virtualenvwrapper_verify_workon_home || return 1
    (cd "$WORKON_HOME"; 
        virtualenv "$@"; 
        virtualenvwrapper_run_hook "./premkvirtualenv" "$envname"
        )
    workon "$envname"
    virtualenvwrapper_source_hook "$WORKON_HOME/postmkvirtualenv"
}

# Remove an environment, in the WORKON_HOME.
function rmvirtualenv () {
    typeset env_name="$1"
    virtualenvwrapper_verify_workon_home || return 1
    if [ "$env_name" = "" ]
    then
        echo "Please specify an enviroment."
        return 1
    fi
    env_dir="$WORKON_HOME/$env_name"
    if [ "$VIRTUAL_ENV" = "$env_dir" ]
    then
        echo "ERROR: You cannot remove the active environment ('$env_name')."
        echo "Either switch to another environment, or run 'deactivate'."
        return 1
    fi
    virtualenvwrapper_run_hook "$WORKON_HOME/prermvirtualenv" "$env_dir"
    rm -rf "$env_dir"
    virtualenvwrapper_run_hook "$WORKON_HOME/postrmvirtualenv" "$env_dir"
}

# List the available environments.
function virtualenvwrapper_show_workon_options () {
    virtualenvwrapper_verify_workon_home || return 1
	find "$WORKON_HOME" -maxdepth 1 -mindepth 1 -type d -exec basename '{}' \; | sort
}

# List or change working virtual environments
#
# Usage: workon [environment_name]
#
function workon () {
	typeset env_name="$1"
	if [ "$env_name" = "" ]
    then
        virtualenvwrapper_show_workon_options
        return 1
    fi

    virtualenvwrapper_verify_workon_home || return 1
    virtualenvwrapper_verify_workon_environment $env_name || return 1
    
    activate="$WORKON_HOME/$env_name/bin/activate"
    if [ ! -f "$activate" ]
    then
        echo "ERROR: Environment '$WORKON_HOME/$env_name' does not contain an activate script."
        return 1
    fi
    
    virtualenvwrapper_source_hook "$VIRTUAL_ENV/bin/predeactivate"
    
    source "$activate"
    
    virtualenvwrapper_source_hook "$WORKON_HOME/postactivate"

    virtualenvwrapper_source_hook "$VIRTUAL_ENV/bin/postactivate"    
    
	return 0
}

#
# Set up tab completion.  (Adapted from Arthur Koziel's version at 
# http://arthurkoziel.com/2008/10/11/virtualenvwrapper-bash-completion/)
# 

if [ -n "$BASH" ] ; then
    _virtualenvs ()
    {
        local cur="${COMP_WORDS[COMP_CWORD]}"
        COMPREPLY=( $(compgen -W "`virtualenvwrapper_show_workon_options`" -- ${cur}) )
    }

    complete -o default -o nospace -F _virtualenvs workon
    complete -o default -o nospace -F _virtualenvs rmvirtualenv
elif [ -n "$ZSH_VERSION" ] ; then
    compctl -g "`virtualenvwrapper_show_workon_options`" workon rmvirtualenv
fi

# Path management for packages outside of the virtual env.
# Based on a contribution from James Bennett and Jannis Leidel.
#
# add2virtualenv directory1 directory2 ...
#
# Adds the specified directories to the Python path for the
# currently-active virtualenv. This will be done by placing the
# directory names in a path file named
# "virtualenv_path_extensions.pth" inside the virtualenv's
# site-packages directory; if this file does not exist, it will be
# created first.
#
function add2virtualenv () {

    virtualenvwrapper_verify_active_environment || return 1
    
    pyvers="`python -c 'import sys; print sys.version[:3]'`"
    site_packages="$VIRTUAL_ENV/lib/python${pyvers}/site-packages"
    
    if [ ! -d "${site_packages}" ]
    then
        echo "ERROR: currently-active virtualenv does not appear to have a site-packages directory"
        return 1
    fi
    
    path_file="$site_packages/virtualenv_path_extensions.pth"

    if [ "$*" = "" ]
    then
        echo "Usage: add2virtualenv dir [dir ...]"
        if [ -f "$path_file" ]
        then
            echo
            echo "Existing paths:"
            cat "$path_file"
        fi
        return 1
    fi

    touch "$path_file"
    for pydir in "$@"
    do
        echo "$pydir" >> "$path_file"
    done
    return 0
}

#
# cdsitepackages
#
# Does a ``cd`` to the site-packages directory of the currently-active
# virtualenv.
#

function cdsitepackages () {
    virtualenvwrapper_verify_active_environment || return 1
    pyvers="`python -c 'import sys; print sys.version[:3]'`"
    site_packages="$VIRTUAL_ENV/lib/python${pyvers}/site-packages"
    cd $site_packages
}

#
# cdvirtualenv
#
# Does a ``cd`` to the root of the currently-active virtualenv.
#

function cdvirtualenv () {
    virtualenvwrapper_verify_active_environment || return 1
    cd $VIRTUAL_ENV
}
