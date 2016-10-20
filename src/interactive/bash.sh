#!/usr/bin/env bash

#==============================================================================
# Functions
#==============================================================================

# Initializes the Bash prompt.
init_prompt() {
	local EXIT="$?"
	
	GIT_BRANCH=$(git branch 2> /dev/null | grep '^[*]' | cut -f2 -d' ')	
	PS1_SET_TITLE='\[\e]0;\u@\h:\w\a\]'
	# \[\e]0;$WINDOWTITLE:\w\a\]

	# ANSI terminal control sequences for setting foreground text color.
	black='\[\e[30m\]'
	red='\[\e[31m\]'
	green='\[\e[32m\]'
	yellow='\[\e[33m\]'
	blue='\[\e[34m\]'
	magenta='\[\e[35m\]'
	cyan='\[\e[36m\]'
	white='\[\e[37m\]'
	## init='\[\e]0;\w\a\]' # Not exactly sure what this is doing; the ]0 should probably be [0.
	## init='\[\e]0;'$WINDOW_TITLE'\w\a\]'
	if [ -z "$WINDOW_TITLE" ]; then
		# If WINDOW_TITLE is blank, use the default of the working directory as the title.
		# Not exactly sure what this is doing.  
		# The \w adds the working directory to the window title.
		init='\[\e]0;\w\a\]' 
	else # We have explicitly defined a window title.
		init='\[\e]0;'$WINDOW_TITLE'\a\]'
	fi

	reset='\[\e[0m\]' # Resets terminal to default settings.


	# PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w \[\e[34m\]!\! \[\e[35m\]\T \[\e[0m\]\n\$ '
	smiley=""
	if (( EXIT == 0 )); then
		smiley='\[\e[32m\]:)\[\e[0m\]'
	else
		smiley='\[\e[31m\]:(\[\e[0m\]'	
	fi

	if [ -z "$GIT_BRANCH" ]; then	
		PS1="${init}\n${green}\u@\h ${yellow}\w ${blue}!\! ${magenta}\T ${smiley} ${reset}\n\$ "
	else # We are on a Git branch.
		PS1="${init}\n${green}\u@\h ${white}${GIT_BRANCH} ${yellow}\w ${blue}!\! ${magenta}\T ${smiley} ${reset}\n\$ "
	fi

	# This would usually set the Cygwin window title to 'Title'.  However, as PS1 is defined, this 
	# somehow overrides this.
	# echo -e "\033]2;Title\007"

} # init_prompt()


# A convenience filter for applying a Bash command to each line of input.
# Takes a single arg command.  You should pass it in as a single-quoted arg using $L, $E, $I, or $O.
# You can also use the lowercase version of each variable.
# to refer to the current line being processed.
# count 10 | foreach 'echo $(( L + 1 ))'
#
# This lets you run an arbitrary Bash command on each line of input.
foreach() {
	# L is a line of input piped in to this foreach command.
	# The command arg is written in terms a generic variable (L) representing the input line.
	# count 1 10 | foreach 'echo "Number $0."'
	local command="$1"
	local L="" 
	while read L; do
		# This just makes it so we can use a variable letter appropriate to whatever kind of
		# things we are iterating over.
		local l="$L" # Line.
		local E="$L" # Element.
		local e="$L"
		local O="$L" # Object.
		local o="$L"
		local I="$L" # Item.
		local i="$L"
		local S="$L" # String.
		local s="$L"
		local F="$L" # File.
		local f="$L"
		eval "$command"
	done
} # foreach


# Sets the Cygwin window title.
# However, my current PS1 (bash prompt) somehow overwrites this.
# Still, 
title() {
	# This should set the title fine in programs other than bash.
	# These both work somehow.
	echo -ne "\e]2;$@\a\e]1;$@\a"
	# echo -e "\033]2;$1\007"
	
	# This will get the prompt right in bash.
	WINDOW_TITLE="$1"
	if [ "$PS1" ]; then
		init_prompt
	fi
} # title()


# Runs either find or fix (thefuck alias).
# Aliased to f.
find_or_fix() {
    if (( $# == 0 )); then
        # Detect if stdout piped.
        exec 9>&1
        case $(readlink /dev/fd/9) in
            pipe:\[*\])
                find
                ;;
            *)
                fix
                ;;
            esac

    else
        find "$@"
    fi
} # find_or_fix()


# Do the default action for a file.
# Change directory to arg if a directory.
# Source arg if a file.
# Meant to be used with '.' as an alias for it.
do_default_action() {
	local F="${FUNCNAME}()"
	ext=$(extension "$1")

	# If there are no args, we run ./default.sh if it exists.
	# If not, we do the default default action for all dirs.
	# Note that '. <dir>' simply cds to <dir>.  This default
	# action for a directory only triggers via lone dot.
	if (( $# == 0 )); then
		## echo "$F: Doing default action for *this* directory."
		if [ -x default.sh ]; then
			./default.sh
		else # No override default.sh defined.
			do_default_default_dir_action
		fi
		return 0
	fi

	# Make it so we can do default action for a list of files.
	for arg in "$@"; do
		arg_ext=$(extension "$arg")
		if [ "$arg_ext" != "$ext" ]; then
			echo "do_default_action: All args must have same extension."
			return 1
		fi
	done

	if [ -d "$1" ]; then
		cd "$1"
	elif [ "$ext" == "txt" ]; then
		vim "$@"
	elif [ "$ext" == "cpp" ]; then
		vim "$@"
	elif [ "$ext" == "c" ]; then
		vim "$@"
	elif [ "$ext" == "h" ]; then
		vim "$@"
	elif [ "$ext" == "py" ]; then
		vim "$@"
	elif [ "$ext" == "pm" ]; then
		vim "$@"
	elif [ "$ext" == "java" ]; then
		vim "$@"
	elif [ "$ext" == "html" ]; then
		firefox "$@"
	elif [ "$ext" == "htm" ]; then
		firefox "$@"
	elif [ "$ext" == "json" ]; then
		vim "$@"
	elif [ "$ext" == "sh" ]; then
		# The source builtin only processes the first arg.
		for script in "$@"; do
			source "$script"
		done
	elif [ "$ext" == "deb" ]; then
		dpkg -i "$@"
	elif [ "$ext" == "ahk" ]; then
		open_explorer "$@" # Launch script using Explorer assosciated app.
	elif [ "$ext" == "mkv" ]; then
		open_explorer "$@"
	elif [ "$ext" == "mp4" ]; then
		open_explorer "$@"
	elif [ "$ext" == "wmv" ]; then
		open_explorer "$@"
	elif [ "$ext" == "webm" ]; then
		open_explorer "$@"
	else # It's not a directory and has no explicitly handled extension.
		# The source builtin only processes the first arg.
		for script in "$@"; do
			source "$script"
		done
	fi

} # do_default_action()


# Does the default default dir action.  This is triggered when you run
# a lone '.' command in a directory in which there is no default.sh script.
# PRE: pipefail and nullglob
do_default_default_dir_action() {	
	local F="do_default_action()"	
	
	shopt -s nullglob
	local source_files=$(echo *.c)
	shopt -u nullglob
	if [ -z "$source_files" ]; then
		ls -lahF --color
		return 0
	fi

	# TO DO: If no main.c, we should try to compile and run the last modified .c file.
	if gcc -Werror main.c |& tee make.out; then
		rm make.out
		if [ -x a.out ]; then # Linux
			./a.out
		elif [ -x a.exe ]; then # Cygwin
			./a.exe
		else # No executable found.
			echo "$F: ERROR: No executable found!"
			exit 1
		fi
	else # Compilation failed.
		# Edit errors as a Vim quicklist.
		vim -q make.out
	fi

} # do_default_default_dir_action()


#==============================================================================
# Tests
#==============================================================================


