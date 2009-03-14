# For login shells (interactive or not).
# For interactive non-login shells see ~/.bashrc.
# For non-interactive non-login ssh shells see ~/.bashrc.
# For other non-interactive non-login shells see $BASH_ENV.
# At present this is sourced by ~/.bashrc for the ssh case, so
# all ssh sessions act like login sessions.

test -r /sw/bin/init.sh && . /sw/bin/init.sh
export PERL5LIB="" # unset broken fink perl5 libraries
export PATH="$HOME/local/bin:/opt/local/bin:$PATH:/usr/local/bin:$HOME/code/charm.git/bin"
export MANPATH="/opt/local/man:$HOME/local/man:$MANPATH"

export CVS_RSH="ssh"
export CVSROOT=":ext:abecker@charm.cs.uiuc.edu:/cvsroot"
export SVNROOT="https://charm.cs.uiuc.edu/svn/cpsd"
export EDITOR=vim

if [ -n "$PS1" -a -r ~/.bashrc ]; then source ~/.bashrc ; fi

