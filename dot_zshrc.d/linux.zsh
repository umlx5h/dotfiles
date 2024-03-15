#
# Function
#

function tracepoint-format() {
	sudo pwd >/dev/null
	local tracepoint_name=$(sudo perf list tracepoint | grep -oP '\w+:\S+' | fzf)

	local format_path="/sys/kernel/debug/tracing/events/${tracepoint_name//://}/format"

	echo "cat $format_path\n"
	sudo cat "$format_path"
}

function bcc() {
	local cmd=$(cat <(find /usr/sbin/ -type f -name '*-bpfcc' -executable) <(find /usr/share/bcc/tools/ /usr/local/share/bpftrace/tools/ -maxdepth 1 -type f -executable) | awk -F/ '{print $NF}' | sort | fzf)
	[ -n "$cmd" ] && print -z -- "sudo $cmd"
}

#
# Alias
#

alias gm="gomi"
function rm() {
	echo "WARNING: Do not use rm directly\n"
	gomi "$@"
}

#
# Path
#

# PATH
path=(
	/usr/share/bcc/tools
	/usr/local/share/bpftrace/tools
	/usr/local/zig
	$path
)
export PATH
