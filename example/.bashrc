# login vs. non-login shell
# interactive vs. non-interactive shell

# At login 
# /etc/profile -- not processed by interactive shells?
# /etc/profile.d/*.sh

# /etc/bashrc -- should be sourced at beginning of all ~/.bashrc

# You should just use ~/.bash_profile and it should not do much more than source ~/.bashrc.
# ~/.bash_profile
# ~/.bash_login
# ~/.profile

# For a non-login shell, this file is sourced for all users:
# /etc/bash.bashrc

# .bashrc
# .bashrc.d/*.sh

# You could set up a .bashrc.d and source each file it contains similar to how /etc/profile sources all in
# /etc/profile.d.  This would make config more modular.

# Strange that Linux developed the convention of having hidden . files and directories for user-specific config rather
# than having a ~/etc directory to shove all that junk into.

# Source global Bash config.
if [ -f /etc/bashrc ]; then
	source /etc/bashrc
fi

# At one time, my .bashrc was a completely unwieldy monolith.  Most of it has now been
# factored to my bash-glory library.
source /usr/share/lib/bash-glory/bash-glory.sh


#===============================================================================
# Environment and Shell Variables
#===============================================================================

# They type of digEplayer: L7, L10, NV8, etc.
export PLAYER_TYPE="unknown"

# For working with the digEcor L7.
L=172.16.40.70
LR=root@$L:/root

# Where we should deploy pkgs we are building.  Used by the 'b' alias.
deployment_target=nv
dt=$deployment_target

L7_DEV="portable"
if [ "$L7_DEV" == "portable" ]; then
	P=root@$L:/root/packages
elif [ "$L7_DEV" == "glide" ]; then
	P=digecor@glide-server:/home/digecor/packages
fi

BL7P='root@build-L7:/root/packages'
BP='root@build-L7:/root/packages'
T='root@build-L7:/root/packages'
BSP='/srv/root/var/lib/bootstrap' # Bootstrap packages.

# Shortcut for use with rsync and scp.
J=janderson@win10:/home/janderson/Desktop

# TO DO: Just use janderson as your user account name on your home laptop.
JL=jadeaxon@xps15:/home/jadeaxon/Desktop

# digEcor release directories.
R=root@build:/var/www/jenkins/releases/current

# This will be set to 1 if running Ubuntu, 0 otherwise.
UBUNTU=$(uname -a|grep Ubuntu || true|wc -l)

# Make sure Vim is used as default text editor.
export EDITOR='vim'
export VISUAL='vim'

# Check to see if we are running Debian Linux.
# TO DO: Might help to know which specific version we are running.
debian=$(uname -a | grep Debian | wc -l)
if (( debian == 1 )); then
	export DEBIAN='true'
fi

prepend_to_path /sbin
prepend_to_path /usr/sbin

# Ant setup.
export ANT_HOME='/usr/local/apache-ant-1.8.4'
append_to_path "$ANT_HOME/bin"

# Gradle setup.  Gradle is yet another build tool like make/Ant/Maven.
export GRADLE_HOME='/cygdrive/c/gradle-1.5'
append_to_path "$GRADLE_HOME/bin"

# Set up Android SDK tools.
export ANDROID_HOME="/cygdrive/c/Users/$USER/AppData/Local/Android/sdk"
append_to_path "$ANDROID_HOME/platform-tools"
append_to_path "$ANDROID_HOME/tools"

export FIREFOX_HOME='/cygdrive/c/Program Files (x86)/Mozilla Firefox'
append_to_path "$FIREFOX_HOME"

# Java setup.
if [ "$HOSTNAME" == "JAnderson-DT" ]; then
	# Ant (run from Cygwin) relies on JAVA_HOME being set to the Windows path (not the Cygwin path).
	# TO DO: Is there a Cygwin Ant package?
	export JAVA_HOME='/cygdrive/c/java/jdk1.7.0_17'
	export PATH="$JAVA_HOME/bin:$PATH"
fi

if [ "$HOSTNAME" == "XPS15" ]; then
	export JAVA_HOME='/cygdrive/c/java/jdk1.7.0_17'
	export PATH="$JAVA_HOME/bin:$PATH"
fi

# ~/bin is the typical place to store you personal utility scripts.  I also like ~/scripts.
# Stuff in ~/bin/override is meant to override normal system commands.
export PATH=${PATH}:~/bin
export PATH=~/bin/override:"$PATH"
export PATH=${PATH}:~/scripts

# Disable Cygwin's DOS file warning.
# Also, we know that if CYGWIN is set, we are running Cygwin.
# COMSPEC is only set on Windows machines.
if [ "$COMSPEC" ]; then
    export CYGWIN=nodosfilewarning 

	# Set up Maven.
	export MAVEN_HOME=/cygdrive/c/apache-maven-3.0.5
	export M2_HOME=$MAVEN_HOME
	export PATH=$MAVEN_HOME:"$PATH"

fi

export VIMRUNTIME=$(find /usr/share/vim/ -maxdepth 1 -type d | egrep vim[0-9]+ | sort -r | head -1)

# Makes it so that you can run X windows apps from Cygwin/mintty.
# You must run startxwin to start the Cygwin X windows server.
export DISPLAY=:0

# Configure bash history.
export HISTCONTROL=erasedups # No duplicates.
export HISTSIZE=100000
export HISTFILESIZE=100000000 # A hundred million.
mkdir -p $HOME/.bash_history.d
HISTFILE=${HOME}/.bash_history.d/.bash_history.${USER}@${HOSTNAME}
shopt -s histappend # Append to history instead of overwriting.
# If you are going to abruptly end a session, do history -a
# TO DO: How would you combine history from multiple machines?

# Append to history after every command.
export PROMPT_COMMAND='history -a'
# STY is only set if this shell is running inside 'screen'.
# The echo command makes the window title be hostname of whatever 
# machine we are on.
if [ "$STY" ] || [ "$SSH_CLIENT" ]; then
	# This doesn't work on Cygwin.	
	PROMPT_COMMAND='history -a; echo -ne "\033k$HOSTNAME\033\\"'
fi
# init_prompt has to happen first so that the red/green smiley works.
PROMPT_COMMAND="init_prompt; $PROMPT_COMMAND"

export MANPAGER=less

append_to_path /usr/games

# Set things like PATH, CLASSPATH, PYTHONPATH, etc.
export PATH=/usr/local/bin:"$PATH"
append_to_path ~/bin
append_to_path ~/scripts

# For shellcheck.
append_to_path ~/.cabal/bin

# Make it so Cygwin can load dynamic libs from /usr/local/lib at runtime.
# Cygwin uses PATH instead of LD_LIBRARY_PATH to do this.
if [ "$CYGWIN" ]; then
	append_to_path /usr/local/lib
fi

# It is considered a security risk to have . in your path, esp. at front, esp. if you are root.
# Use ./<command> to call commands in current directory.  Make ~/bin and ~/scripts.  Add those to front of PATH.
# append_to_path .
unique_path
unique_classpath

# Fix TERM when sshing from Ubuntu 16 to Ubuntu 14.  Ubuntu 14 doesn't recognize
# screen.xterm-256color and reverts to ansi as terminal type (causing Vim to be wonky).
ubuntu_version=$(ubuntu_version)
if (( ubuntu_version == 14 )); then
	if [[ "$TERM" == 'screen.xterm-256color' ]]; then
		TERM='screen'
	fi
fi


#===============================================================================
# Functions
#===============================================================================

# All of these have been factored to the Bash Glory library.


#===============================================================================
# Aliases
#===============================================================================

source /usr/share/lib/bash-glory/interactive/aliases.sh


#===============================================================================
# Main
#===============================================================================

# There are four kinds of shells: login/non-login, interactive/non-interactive.
# Test for prompt variable $PS1 to see if you have an interactive shell. 
# No prompt => non-interactive.
# Why I have to double square bracket this I do not know.  Gives 'binary operator expected' if you don't. 
if [[ -z "$PS1" ]]; then
	: # Do nothing.
	# Bash doesn't let you just leave the then block empty for whatever stupid reason.
	# No, we really need to do nothing at all in non-interactive mode, so return.
	# Note that exiting here makes it so the iecho function really isn't necessary.	
	return

else # Interactive.
	bash --version
	echo
	
	# We now use git@github.com:jadeaxon/home.git as our home directory.
	echo '~/.bashrc from GitHub: Running.'

	# Do no allow EOF, <Ctrl + D>, to log us out.
	set -o ignoreeof

	# Do not allow the use of unset variables.
	# set -o nounset
	# Nice idea, but <Tab> autocompletion fails miserably if you do that.
	# So, it is only good for scripts, not interactive usage.	
	set +o nounset

	# Yes, this is definitely necessary on mintty/Cygwin/vim.
	# Disable terminal stopping.  This allows vim to use <Ctrl + S> to save files without problems.
	stty stop ''

fi

initialize_player_type
iecho "digEplayer type: $PLAYER_TYPE"


#-------------------------------------------------------------------------------
# Shell Options
#-------------------------------------------------------------------------------

# Set shell options.
# This shell option does not exist on the L7 version of Bash.
if [ "$HOSTNAME" != 'digEplayer' ]; then
	major_bashver=$(echo $BASH_VERSION | cut -f1 -d'.')	

	if (( major_bashver >= 4 )); then
		shopt -s globstar # Allows use of ** to recursively match down subdirectories.
	fi
fi
# BUG: bash completion fails if nullglob is set, so don't use it interactively for now.
# shopt -s nullglob # Return empty string when a glob matches nothing (instead of literal glob).

# Set commandline editing to use vi key bindings.
# This removes the eminently useful <Alt + .> binding.  How do I get it back?
# This might eventually be nice but there are display quirks when backspacing in addition to the problem above.
# These key bindings are specificall useful when using a Dvorak keyboard layout with Alt keys next to spacebar.
# Do *not* use the arrow keys to navigate when these bindings are in effect.  Cygwin bash screws them up.
if [ "$HOSTNAME" == 'XPS15' ]; then 
	# set -o vi
	# # This makes it so <Alt + .> inserts last arg of last command (with no extra leading space!).
	# bind '"\e.":"_BiWWa"'
	# # Use <Alt + N> to switch to normal mode (command mode).
	# bind '"\en":""'
	# # Sometimes this freezes at a command.  But, you are now in normal mode and can use + and - to
	# # scroll through history.  Those always work.
	# bind '"\el":previous-history'
	# bind '"\eh":next-history'
 
	# vi mode just fails.
	set -o emacs

fi


#-------------------------------------------------------------------------------
# digEcor
#-------------------------------------------------------------------------------

if ! is_digEplayer; then
	# Add identity key to global keychain.  You'll only have to enter your identity key
	# once per boot of the machine.  Lets you do passwordless ssh stuff.
	# PRE: apt-get install keychain
	if [ "$PS1" ]; then
		eval $(keychain --eval id_dsa jadeaxon@github.rsa)
	fi

	# Set up for Qt and ARM cross-compiling.
	# You'd only do this on a Linux server or VM set up for L7 development.
	if [ -f /opt/linux_dige/setup_Qt_for_L7.sh ]; then
		iecho ".bashrc: Setting up Qt ARM cross-compiling."	
		source /opt/linux_dige/setup_Qt_for_L7.sh
	fi
else # We are on a digEplayer.
	true
fi

# This file only exists on SPSes and CMs.  Makes it so .bashrc can be left alone while its
# extensions are put under package control.
if [ -r ~/.bashrc_digEcor ]; then
	source ~/.bashrc_digEcor
fi

# Set up for NV/Linux development.
if [ "$HOSTNAME" == nvdev ] || [ "$HOSTNAME" == 'bronzeboy-sp1' ]; then
	echo ".bashrc: Setting xcompile target to NV/Linux.  Toolchain will be enabled by build.sh."
	export DIGECOR_TARGET=NV
	export NV_TOOLCHAIN_ENABLED=0 # build.sh should call enable_toolchain().
fi


#-------------------------------------------------------------------------------
# Other
#-------------------------------------------------------------------------------

# Enable tab-completion for Git.
gitcomp=/usr/share/git-core/git-completion.bash
[ -r $gitcomp ] && source $gitcomp

# Allow transition to vi and emacs readline edit modes with <A-v> and <A-e>.
bind '"\ev": vi-editing-mode'
set -o vi
# NOTE: This only works in vi insert mode, so you have to press i<A-e> to transition.
bind '"\ee": emacs-editing-mode'
set -o emacs


#-------------------------------------------------------------------------------
# Linux from Scratch (LFS)
#-------------------------------------------------------------------------------

if [ $(whoami) == 'lfs' ] && [ -z "$LFS" ]; then
	echo ".bashrc: Setting up LFS build environment."	
	export LFS=/mnt/LFS

	# Start with a totally clean environment.
	# The idea here is to protect build env from unwanted vars, but I'm going to keep my setup.	
	# exec env -i LFS=$LFS HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
	
	set +h # No command hashing.
	umask 022
	LC_ALL=POSIX
	LFS_TGT=$(uname -m)-lfs-linux-gnu
	export PATH=/tools/bin:/bin:/usr/bin:~/bin/LFS
	export LFS LC_ALL LFS_TGT PATH
fi


#-------------------------------------------------------------------------------
# Prompt
#-------------------------------------------------------------------------------

export WINDOW_TITLE='\u@\h' # username@host
WINDOW_TITLE=
init_prompt

# Use a better prompt for set -o xtrace (aka set -x).
# Have xtrace tell you file and line number for each line printed.
export PS4='\n+ $0:$LINENO\n+ $BASH_COMMAND =>\n+ '


#-------------------------------------------------------------------------------
# Automatic Package Updates
#-------------------------------------------------------------------------------

# Update bash-glory.  Become new shell if update occurs.
cd ~
if [ ! -f glorified ]; then
	echo ".bashrc: Checking for bash-glory update."
	v1=$(bash-glory version)
	bash-glory update
	v2=$(bash-glory version)
	if [ "$v1" != "$v2" ]; then
		echo ".bashrc: Hallelujah, Lord Jebus!  I am Bourne Again!"
		touch glorified # Prevent infinite exec loop.
		# bash-glory has been updated, so become a new Bash shell.
		exec bash
	fi
else # Already glorified.
	rm -f glorified
fi


