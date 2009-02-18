export PATH="/opt/local/bin:/sw/bin:$HOME/local/bin:$PATH:/usr/local/bin:$HOME/code/charm.git/bin"
export MANPATH="$MANPATH:/opt/local/man"

export CVS_RSH="ssh"
export CVSROOT=":ext:abecker@charm.cs.uiuc.edu:/cvsroot"
export SVNROOT="https://charm.cs.uiuc.edu/svn/cpsd"
export EDITOR=vim


test -r /sw/bin/init.sh && . /sw/bin/init.sh
test -r ~/.bashrc && . ~/.bashrc

echo -e `hostname`
echo -e `uname -smr`

