#!/usr/bin/env bash

# Remember that bash is case-sensitive: therefore you can make single capital letter
# aliases too.  Numbers and symbols can be command names too.

# Aliases only apply to the first word in any command.  If that word is quoted, alias expansion will not occur.
# Aliases should always appear on a separate line.  Do not use them inside functions.
# In general, prefer bash functions over aliases.

# PRE: nullglob is not set.

alias G='query_google'

alias td='todo'
alias t='todo'
alias @W='send_waiting_e-mail'

# alias .m='cdm'

# Aliases are expanded before globs, thus you can do this treachery.
# This turns globbing off and then calls our _calc helper function.
# Thus, Bash functions are not always better than aliases!
#
# This guy describes such an alias + helper function combo as a 'magic alias':
# http://www.chiark.greenend.org.uk/~sgtatham/aliases.html
alias calc='set -o noglob; _calc' 

# List directory stack one directory per line.  cdh => cd history.
alias cdh='dirs -p'

alias ra='/etc/init.d/apache2 restart'

alias MDY='mdy'
alias YMD='ymd'
alias YYYY-MM-DD='date +%Y-%m-%d'
alias yyyy-mm-dd='date +%Y-%m-%d'
alias y-m-d='date +%Y-%m-%d'
alias Y-M-D='date +%Y-%m-%d'
alias YYYYMMDD='date +%Y%m%d'
alias yyyymmdd='date +Y%m%d'

alias swap=$'awk \'{print $2, $1}\'' # Swaps the first two words on each line.
alias shuffle='shuf' # Shuffle order of lines of input.
alias vars="set | g = | gv '^\s'" # Print local and env vars, no func defs.
alias dpgk='dpkg' # Misspelling.
alias di='dpkg -i'
alias dups='uniq -d'
alias unmount='umount' # More natural.
alias aliases='alias' # To get a list of all aliases.
alias cls='clear' # Clean the screen.
alias ll='my_ls'
alias l='my_ls'
alias l1='list_single_column'
alias 1='l1'
alias 1d="ls -1ad .*/ */ | ppe 's@/@@' | pcregrep -v '^[.]{1,2}$'" # List only the subdirs as a single column with no trailing /.
alias 1f="find . -maxdepth 1 -type f | cut -c 3-" # List only the files in this dir as a single column.
# alias lm='l --color=never|m' # more does not like ANSI color escapes
alias lm='l|m' # Using the -r option with less solves the color problem.
alias md='mkdir -p'
alias signal='kill' # kill really sends signals to processes; it is badly named.
alias signals='kill -l' # Would be better if it listed one signal per line.
alias calendar='cal' # Displays a little calendar.
alias e='echo'
alias eoch='echo' # Common typo I make.
alias nullify="tr '\n' '\000'" # Convert line endings to null for use with xargs --null.
alias 0="tr '\n' '\000'"
alias exti="exit" # Misspelling.

alias .='do_default_action'
alias E='open_explorer' # Use Windows Explorer to open dir or run file with default program.

# No need. E opens URLs too.
# alias F='firefox' # Open URLs using Firefox.

# cd related aliases.
alias .l='cd_and_list'
alias ..l='cd ..; my_ls'
alias ..='cd ..'
alias ....='cd ../..'
alias ..2='cd ../..'
alias ......='cd ../../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'
alias ..6='cd ../../../../../..'
alias cd..='cd ..'
alias ~='cd ~'

C_DIR='/cygdrive/c'
if (( WSL )); then
	C_DIR='/mnt/c'
fi
alias c:='cd ${C_DIR}'
alias C:='cd ${C_DIR}'

alias cdd='cd ~/Desktop'
# alias cddb='cd ~/Dropbox'
alias cddl='cd ~/Downloads'
# alias cdo='cd ~/Dropbox/Organization'
alias cdp='cd ~/projects'
alias cdpb='cd ${HOME}/projects/bash-glory'
alias cdpm='cd ${HOME}/projects/modes'
alias cdpmp='cd ${HOME}/projects/modes-private'
alias cdph='cd ${HOME}/projects/hello'
# alias cdn='cd ~/Dropbox/Organization/Notes'

# Less can be more.  The -r option passes thru escape sequences so that color output
# is preserved (such as from the ls command).
alias m='less -r'
alias more='less -r'

alias f='find_or_fix'
alias r='rm'
# alias fg='find . | pcregrep' # Look for files matching a regexp in a directory tree.
fg() {
	# Normal job control foreground built-in if no args.
	if (( $# == 0 )); then
		builtin fg
		return
	fi
	find . | pcregrep "$@"
}

alias ff='find "`pwd`"' # List full paths instead of relative.  Quote backticks in case path has spaces.
# Probably should have the options always in alphabetical order for the grep aliases.
ca='--color=always'
alias grep="pcregrep $ca"
alias g="pcregrep $ca" # Perl-compatible regular expression grep.
alias gr="pcregrep -r $ca" # Recursively descent diretories
alias grn="grep_rn $ca"
alias grin="grep_rin $ca"
alias gv="pcregrep -v $ca" # Print lines not containing given pattern.
alias grv="pcregrep -r -v $ca" # Recursive inverted Perl-compatible grep.
alias gi="pcregrep -i $ca" 
alias gvi="pcregrep -v -i $ca" 
alias giv="pcregrep -i -v $ca" 
alias gri="pcregrep -r -i $ca" 
alias gir="pcregrep -i -r $ca" 
alias grvi="pcregrep -r -v -i $ca" 
alias girv="pcregrep -i -r -v $ca" 
alias gH="pcregrep -H $ca" 
alias gHi="pcregrep -H -i $ca" 
alias gHv="pcregrep -H -v $ca" 
alias gHiv="pcregrep -H -i -v $ca" 
unset ca

alias sha1='sha1sum' # SHA-1 checksum.
alias md5='md5sum' # MD5 checksum.
alias sha='sha256sum' # 256-bit SHA checksum.
alias sha256='sha256sum' 

# If you need to debug, use -t (trace) option to print commands as executed.
# NOTE: The trailing space causes the next word on commandline to also be evaluated as an alias.
# This allows you to say things like
# ss?|x sa # Add all unadded files to SVN repo.
alias x='strip_ansi_color | xargs -n 1 ' # One command per stdin token.
alias x{='strip_ansi_color | xargs -i -n 1 ' # Form one command per line from stdin using '{}' as placeholder.
alias x0='strip_ansi_color | xargs --null -n 1 '
alias x{0='strip_ansi_color | xargs --null -i -n 1 '
alias x0{='strip_ansi_color | xargs --null -i -n 1 '

alias bu='backup' # Back up a file or a directory.

# All the aliases you want to use must be defined in root's .bashrc since once you run sudo,
# you become root.
alias sudo='sudo '
alias s='sudo ' # Allow use of aliases with sudo (trailing space causes this).
alias S='ssh' # Along with my ssh(), I can now say 'S 118'.  Bam!

alias C='scp'
alias CJ='scp_to_desktop'

alias R='rsync'
alias Rp='rsync -avz --partial --progress'

# Web development aliases.
alias serve='python3 -m http.server 8888 &'
alias 8888='explorer.exe http://localhost:8888/'
alias 8080='explorer.exe http://localhost:8080/'
alias 8000='explorer.exe http://localhost:8000/'
alias 9999='explorer.exe http://localhost:9999/'
alias 9090='explorer.exe http://localhost:9090/'
alias 9000='explorer.exe http://localhost:9000/'

# Set up ssh agent so that we can automatically log onto and copy files to/from any machine
# that has our public key as an authorized key.
alias ssha='eval $(ssh-agent); ssh-add'

alias map='foreach ' # You are mapping arbitrary code onto each line.
alias feach='foreach ' # Trailing space causes next word to be evaluated as an alias by bash.
alias fe='foreach '

alias pid='pgrep' # Process grep.  Lists all pids for running process names matching regexp.
alias psg='ps aux|g' # Another process grep shorthand.

# Switch between readline editing modes in Bash.
alias sov='set -o vi'
alias soe='set -o emacs'

alias vi='vim'

# For some reason, the title doesn't update when using screen.
# Need the title to update so that AHK can be context-sensitive.
# alias v='vim'
function v() {
	set_title "$1" && vim "$1"
}

if [ -e ~/.vimrc_jeff ]; then
	alias vim='\vim -u ~/.vimrc_jeff'
fi
alias vw='vimwhich'
alias veh='vim /etc/hosts'
alias vkh='vim ~/.ssh/known_hosts'
alias vmc='cd ~; vim My\ Configuration.txt'

alias wrap='fmt' # Wraps long text lines.
alias tab2space='expand --tabs=4' # Expand tabs to spaces.
alias tf='tail -f' # Follow logs as they are written to.
alias ~='cd ~'
alias classpath="echo \$CLASSPATH | perl -pe 's/;/\n/g'"

alias help='man'
alias count='seq' # Doesn't do everything I want a count script to do, but close.

# Slightly tricky: you have to use -- to end option processing for the alias command.
alias -- -='cd -'
alias c='cd_or_cat'
alias reverse='tac'
alias copy='cp'

alias uppercase='tr [:lower:] [:upper:]'
alias uc='uppercase'
alias lowercase='tr [:upper:] [:lower:]'
alias lc='lowercase'

# Use these to get rid of extra trailing whitespace before Git commits.
alias rtrim='sed -i "s/[[:space:]]*$//"'
alias rstrip='sed -i "s/[[:space:]]*$//"'

# Meta-efficiency shortcuts.  They make it more efficient to become more efficient!
alias v.b='vim ~/.bashrc'
alias c.b='git add ~/.bashrc; git commit'
alias v.a='vim ~/projects/bash-glory/src/interactive/aliases.sh'
alias s.a='source ~/projects/bash-glory/src/interactive/aliases.sh'

alias v.i='vim ~/.inputrc'

# This stays the same because the main .bashrc must source .bashrc_jeff on machines where
# I want a custom-but-shared root account.  Really should just use sudo.
alias s.b='source ~/.bashrc'
# alias si.b='cd ~/Dropbox; svn ci .bashrc -m' # Check in ~/.bashrc to SVN.

alias v.v='vim ~/.vimrc'
# alias v.ab='vim ~/Dropbox/vim/abbreviations.vim'
# alias v.ms='vim ~/Dropbox/vim/misspellings.vim'
# alias v.s='v.ms'
# alias v.sp='v.ms'

# alias si.v='cd ~/Dropbox; svn ci .vimrc -m' # Check in ~/.vimrc to SVN.
alias v.g='vim ~/_gvimrc'
alias v_g='vim ~/_gvimrc'

# This should allow the full power of Vim editing when you need it.
# The + tells Vim to open file on last line.
# Edit the command, return to Bash, and then do !!.
alias v.h='vim ~/.bash_history +; history -rc ~/.bash_history'

alias h='history'
alias hc='history | perl -pe "s/^(\d|\s)+//"' # Do a clean history with no line numbers.
alias directory='dirname' # Gives you the directory part of a path.

# alias shortcuts='bind -P'
alias shortcuts='cat ~/bash_shortcuts.txt | less'
alias chx='chmod 755'
alias chr='chmod 644'
alias rehash='hash -r' # Forget hashed command paths.

# Networking aliases.

if [[ -z $CYGWIN ]]; then
	# I am just used to typing ipconfig on Windows.
	alias ipconfig='ifconfig'
else
	alias ifconfig='ipconfig'
fi

alias ipa='ipaddress'

# Pipe to system clipboard functionality.
# TO DO: Implement for other OSes.  Allow piping from remote ssh'd system to local clipboard.
# TO DO: Make it so that cb writes contents of clipboard if not being piped into.
# TO DO: Can a Bash function tell if it is attached to a pipe?
# On Windows/Cygwin, you can dump clipboard: cat /dev/clipboard.
# On Linux, it is supposed to be /dev/clip.
if [ "$CYGWIN" ]; then
	# This is actually a built in Windows command that copies stdin to clipboard!
	# Windows is starting to get things right.
	alias cb='clip'
	alias clipboard='clip'
	alias pcb='cat /dev/clipboard' # Paste clipboard.
	
	# The Node.js interpreter doesn't work right interactively in mintty.  Start in another terminal.
	function node_helper() {
		if (( $# == 0 )); then
			cygstart --maximize /bin/bash -c node
		else
			# Ha, yes, avoiding infinite recursion is a good idea.
			\node "$@"
		fi
	}
	alias node=node_helper
else
	alias cb='echo "Not implemented on this OS yet."'
	alias pcb='cat /dev/clip'
fi

# Git aliases.
alias gs='git status'
alias gss='git status -s' # Short status.  Similar to SVN output.
alias gca='git commit -a' # Adds all changed files under cwd tree and commits them.
alias ga='git add'
alias ga.='git add .'
alias add='git add'
alias unstage='git unstage'
alias gco='git checkout'
alias gc='git commit'
alias gc.='git commit .'
alias go='git commit'
alias gci='git commit'
alias push='git push'
alias pull='git_pull'
alias gpr='git pull --rebase'
alias gb='git branch'
alias gd='git diff nv8-ui develop --'
alias branch='git branch'
alias checkout='git checkout'
alias co='git checkout'
alias cob='git checkout -b' # Create and checkout a new Git branch.
alias ci='git commit'

# Scripting aliases.  Great for one liners.
alias p='perl'
alias pp='perl -p -e'
alias pn='perl -n -e'
alias pe='perl -e'
alias ppe='perl -p -e'
alias pne='perl -n -e'
alias pie='perl -p -i -e'
alias pieb='perl -p -i.bak -e'
alias pibe='perl -p -i.bak -e'
alias pnbe='perl -n -i.bak -e'
alias py='python3'
alias py3='python3'

# Regular Expression Debugger
# Allows you to visually step through a regexp matching against a string.
# cpan
# install Regexp::Debugger
alias rxrx="perl -MRegexp::Debugger -E 'Regexp::Debugger::rxrx(@ARGV)'"

alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"

# Build process aliases.
# alias m.='time make 2>&1 | tee make.out; printf "\nExit status: $?\n"'
# alias m.c='make clean'
# alias m.cd='make distclean'
# alias m.dc='make distclean'
# alias qm='qmake'
# alias qmp='qmake -project'
# alias qm.p='qmake -project'
# alias xs='echo $?' # Exit status.
# alias vq='vim -q make.out' # Create and open Vim quick fix list of all warnings/errors from last build.
# alias mq='make distclean; qmake; m.'
# alias mqd='mq && . d' # Build and deploy digEcor Qt project.

# Network aliases.
# There is an 'ip' command on Linux machines that does something different.
alias ipa=ipaddress
alias ipaddy=ipaddress

# Note that you have to do this as a function.  As a bash script, the cd would affect the subshell
# invoked to run the script, not the calling shell.  A bash function runs in the same shell it is
# defined in.
cdwhich() {
    # Sends escaped quotes and backticks to subshell to deal with spaces in directory names.
    cd "`dirname \"\`which ${1}\`\"`"

}

# cd to wherever the given executable is located.
alias cdw='cdwhich'

alias tc='create_tgz' # Make a .tgz from a given directory.
alias tl='tar tzvf' # List the contents of a .tgz file.

# Poor man's text-to-html.  I use this with the Pidgin digEcor development chat logs.
# ppe 's/<[^>]+>//g' | pne 'print if $_ !~ /^ *$/'
# cat log.html | text2html
alias text2html=$'ppe \'s/<[^>]+>//g\' | pne \'print if $_ !~ /^ *$/\''

# Shuts down or reboots and gets me out of ssh session so it doesn't jam.
alias shn='shutdown -h now'
alias shne='shutdown -h now; exit'
alias srne='shutdown -r now; exit'
alias rex='reboot; exit'

alias b='build_and_deploy'

# Get command history for the 11g version of SQL*Plus that I use.
alias sqlplus='rlwrap sqlplus'


