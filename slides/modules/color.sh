module color

pub const BOLD = 1

const FG_BASE = 30
pub const FG_RED = $((FG_BASE + 1))
pub const FG_CYAN = $((FG_BASE + 6))

fn unstyle
unstyle () {
	printf "\033[0m"
}

pub fn span
span () {
	scope color using unstyle
	var style = "$1"; shift

	printf "\033[%sm%s" "${style#;}" "$*"
	unstyle

	scope_return
}

end_module
