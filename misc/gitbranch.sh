#!/bin/sh
# usage: gitbranch.sh <source directory>
# Prints the branch of <source directory>/.git for the build directory name; nothing if detached or no .git.
# Reads .git/HEAD instead of running git, which refuses a repository of another user (make install as root).

top=$1
git=$top/.git
if [ -f "$git" ]; then
	# worktree or submodule: ".git" is a file with "gitdir: <path>"
	git=$(sed -n 's/^gitdir: //p' "$git")
	case $git in
	/*) ;;
	*) git=$top/$git ;;
	esac
fi
[ -f "$git/HEAD" ] || exit 0
sed -n 's|^ref: refs/heads/||p' "$git/HEAD" | sed 's|/|--|g; s|[^A-Za-z0-9._-]|_|g'
