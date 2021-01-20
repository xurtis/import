# Dash profile script

tabs 4

pcat () {
	pygmentize -O style=monokai $1 | less -x4 -R
}

alias fn_vars="set | grep '^__module_SCOPE'"
alias mod_vars="set | grep '^__module'"

_="../local-init.sh"
. "$_"

clear
