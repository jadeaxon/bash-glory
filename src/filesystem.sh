#!/usr/bin/env bash

#=============================================================================
# Functions
#=============================================================================

# Print the size in bytes of given file on stdout.
sizeof() {
	local file="$1"
	stat -c "%s" "$file"
}


# Outputs to stdout just the file name for a path.  No directory or extension.
# There is a basename utility program, so I don't call this function basename.
# Does not try to resolve relative paths to absolute paths.
filename() {
	path="$1"
	path="${path%.*}" # Remove shortest suffix beginning with '.'.
	path="${path##*/}" # Remove longest prefix ending with '/'.
	echo "$path"

}


# Outputs just the extension (not including leading dot) for a given path.
extension() {
	path="$1"
	echo "${path##*.}" # Remove longest prefix ending with '.'.
}


# This is already aliased to dirname.
# Outputs just the directory name for a given path.  If the path is that of a directory, it
# prints the path of the parent directory.
# Does not try to resolve relative paths to absolute paths.
# directory() {
#	dirname "$1"
# }


# Outputs the absolute path for the given relative path.
# TO DO: This is not efficient at all.
absolute_path() {
	path="$1"
	directory="$(directory "$path")"
	# echo "directory: $directory"
	filename="$(filename "$path")"
	# echo "filename: $filename"
	extension="$(extension "$path")"
	# echo "extension: $extension"
	absolute_directory="$(cd "$directory"; pwd)"
	# echo "absolute_directory: $absolute_directory"
	absolute_path="${absolute_directory}/${filename}.${extension}"
	echo "$absolute_path"

	# TO DO: Resolve single trailing /. or /..
	# /path/to/some/dir/..
	# /path/to/some/dir/.
	# Seems to handle other cases correctly.

	# TO DO: Handle files like .bashrc
	# Does it properly detect that it has no extension?
	# This is more of a to do for the extension() function.
} # absolute_path()


#=============================================================================
# Tests
#=============================================================================


