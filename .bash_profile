# For login shells (interactive or not).
# For interactive non-login shells see ~/.bashrc.
# For non-interactive non-login ssh shells see ~/.bashrc.
# For other non-interactive non-login shells see $BASH_ENV.
# At present this is sourced by ~/.bashrc for the ssh case, so
# all ssh sessions act like login sessions.


if [[ -r ~/.bash_vars_`hostname -s` ]]
then
   source ~/.bash_vars_`hostname -s`
else
    source ~/.bash_vars_default
fi

if [ -n "$PS1" -a -r ~/.bashrc ]; then source ~/.bashrc ; fi

