autoload -U compinit

# Grab the current filepath, use shortcuts: ~/Desktop
# Append the current git branch, if in a git repository
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""

# Do nothing if the branch is clean (no changes).
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Add a red M if the branch is dirty
ZSH_THEME_GIT_PROMPT_DIRTY=""

git_branch() {
	local git_root="$1"
	local line="$2"
	local branch="???"
	local ahead=''
	local behind=''

	case "$line" in
		\#\#\ HEAD*)
			branch="$(git -C "$git_root" tag --points-at HEAD)"
			[ -z "$branch" ] && branch="$(git -C "$git_root" rev-parse --short HEAD)"
			branch="%{$fg[yellow]%}${branch}%{$reset_color%}"
			;;
		*)
			branch="${line#\#\# }"
			branch="%{$fg[green]%}${branch%%...*}%{$reset_color%}"
			ahead="$(echo $line | sed -En -e 's|^.*(\[ahead ([[:digit:]]+)).*\]$|\2|p')"
			behind="$(echo $line | sed -En -e 's|^.*(\[.*behind ([[:digit:]]+)).*\]$|\2|p')"
			[ -n "$ahead" ] && ahead="%{$fg_bold[white]%}↑%{$reset_color%}$ahead"
			[ -n "$behind" ] && behind="%{$fg_bold[white]%}↓%{$reset_color%}$behind"
			;;
	esac

	print "${branch}${ahead}${behind}"
}

git_status() {
	local untracked=0
	local modified=0
	local deleted=0
	local staged=0
	local branch=''
	local output=''

	for line in "${(@f)$(git -C "$1" status --porcelain -b 2>/dev/null)}"
	do
		case "$line" in
			\#\#*) branch="$(git_branch "$1" "$line")" ;;
			\?\?*) ((untracked++)) ;;
			U?*|?U*|DD*|AA*|\ M*|\ D*) ((modified++)) ;;
			?M*|?D*) ((modified++)); ((staged++)) ;;
			??*) ((staged++)) ;;
		esac
	done

	output="$branch"

	[ $staged -gt 0 ] && output="${output} %{$fg_bold[green]%}S%{$fg_no_bold[black]%}:%{$reset_color$fg[green]%}$staged%{$reset_color%}"
	[ $modified -gt 0 ] && output="${output} %{$fg_bold[red]%}M%{$fg_no_bold[black]%}:%{$reset_color$fg[red]%}$modified%{$reset_color%}"
	[ $deleted -gt 0 ] && output="${output} %{$fg_bold[red]%}D%{$fg_no_bold[black]%}:%{$reset_color$fg[red]%}$deleted%{$reset_color%}"
	[ $untracked -gt 0 ] && output="${output} %{$fg_bold[yellow]%}?%{$fg_no_bold[black]%}:%{$reset_color$fg[yellow]%}$untracked%{$reset_color%}"

	echo "$output"
}

job_info() {
	JOB_COUNT="$(jobs | wc -l | tr -d '[:blank:]')"
	if [ "$JOBS_COUNT" = "0" ]
	then
		printf ''
	else
		printf ' (%s)' "$JOB_COUNT"
	fi
}

# Put it all together!
SERVER="%{$fg_bold[green]%}%m"
PWD="%{$fg_bold[blue]%}%~"
USER="%{$fg_bold[green]%}%n"
RESET_COLOR="%{$reset_color%}"
PROMPT="$SERVER: $PWD $USER@$(git_status) $RESET_COLOR" 

