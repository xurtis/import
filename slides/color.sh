module color

pub const BOLD = 1
pub const FG_RED = 31
pub const FG_CYAN = 36

pub fn span
span () {
	scope color
	var style = "$1"; shift

	printf "\033[%sm%s\033[0m" "${style#;}" "$*"

	scope_return
}

end_module
