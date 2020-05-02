#!/bin/sh

# Library to construct modules
#
# This library is automatically imported
#
# A namespace can simply be created using (must come before all imports):
#
# module "foo"
# import baz from bar
# import all_from foobar
#
# ...
#
# end module
#
# exporting a constant can be done with (must come after):
#
# var "VAR_NAME" "$value"
# pub var "VAR_NAME" "$value"
#
# const "CONST_NAME" "$value"
# pub const "CONST_NAME" "$value"
#
# exporting a function can be done with
#
# fn func_one
# func_one () {
#	  scope in "foo"
#	  var foo = 1
#     echo "$foo"
#     true
#     return
# }
# pub fn func_two
# func_two () {
#	  scope in "foo"
#     true
#     return true
# }
#
# Items from a namespace can then be used from an imported namespace
# with:
#
# import namespace use
# use "foo" "VAR_NAME" "func_name"
#

import util
import list

# Note: This entire idea is just a horrible misuse of `alias` to give
# the illusion of scope

# Declaration namespaces
# ======================
#
# These describe where all new global items and variables are created

# Push a new namespace onto the namespace stack
__module_push () {
	name=$1; shift
	true
}

# Pop the current namespace from the stack
__module_pop () {
	true
}

# Get the current namespace used for declaration
__module_current () {
	true
}

# Context namespaces
# ==================
#
# These describe an overlay of the global scope

# Load the context of a given namespace
__module_load () {
	name=$1; shift
	true
}

# Unload the context of a given namespace
__module_unload () {
	true
}

# Get the name of the currently loaded namespace
__module_context () {
	true
}

# Scopes
# ======
#
# These describe the scope of all variables in a function

__module_SCOPE_DEPTH=0

# scope_stack := [ ; <scope> ] ...
#
# scope := [ , <decl> ] ...
#
# decl
#   := : <name> : var
#   |  : <name> : <name> : alias
#   |  : <name> : fn
#
__module_SCOPE_STACK=""

# Create a new scope
__module_scope_push () {
	if __module_in_scope; then
		__module_decls_foreach __module_scope_save_decl
	fi

	__module_scope_new
}

__module_scope_new () {
	__module_SCOPE_DEPTH=$(($__module_SCOPE_DEPTH + 1))
	__module_SCOPE_STACK=$(list_push ';' "${__module_SCOPE_STACK}" "")
}

__module_scope_save_decl () {
	__module_scope_id="${__module_SCOPE_DEPTH}"

	case "$1" in
		"var")
			eval "__module_SCOPE_CONTEXT_${__module_scope_id}_$2=\$$2"
			unset -v "$2"
			;;
		"alias")
			unalias "$2"
			;;
	esac

	unset __module_scope_id
}

# Remove the current scope
__module_scope_pop () {
	if __module_in_scope; then
		__module_decls_foreach __module_scope_discard_decl
		__module_scope_remove

		if __module_in_scope; then
			__module_decls_foreach __module_scope_restore_decl
		fi
	fi
}

__module_scope_remove () {
	__module_SCOPE_STACK=$(list_start ';' "${__module_SCOPE_STACK}")
	__module_SCOPE_DEPTH=$(($__module_SCOPE_DEPTH - 1))
}

# Discard the contents of the current scope
__module_scope_discard_decl () {
	case "$1" in
		"var")
			unset -v "$2"
			;;
		"fn")
			unset -f "$2"
			;;
		"alias")
			unalias "$2"
			;;
	esac
}

# Restore the contents of the current scope
__module_scope_restore_decl () {
	__module_scope_id="${__module_SCOPE_DEPTH}"

	case "$1" in
		"var")
			eval "$2=\$__module_SCOPE_CONTEXT_${__module_scope_id}_$2"
			unset -v "__module_SCOPE_CONTEXT_${__module_scope_id}_$2"
			;;
		"alias")
			eval alias "$2=$3"
			;;
	esac

	unset __module_scope_id
}

# Perform an operation on every declaration in a list of decls
__module_decls_foreach () {
	__module_current_decls=$(list_last ';' "${__module_SCOPE_STACK}")

	list_foreach \
		',' "${__module_current_decls}" \
		__module_decl_apply_foreach "$@"

	unset __module_current_decls
}

__module_decl_apply_foreach () {
	__module_apply_rotate=$(($# - 1))

	while [ "${__module_apply_rotate}" -gt 0 ]; do
		__module_apply_rotate_first="$1"; shift
		set -- "$@" "${__module_apply_rotate_first}"
		__module_apply_rotate=$(($__module_apply_rotate - 1))
	done

	__module_decl_apply "$@"
}

# Generate a declaration
__module_decl_new () {
	case "$#" in
		0)
			echo ""
			;;
		*)
			__module_decl_part=$1; shift
			list_push \
				':' "$(__module_decl_new "$@")" \
				"${__module_decl_part}"
			unset __module_decl_part
			;;
	esac
}

# Apply a declaration to a function
__module_decl_apply () {
	__module_applied_decl=$1; shift
	if list_empty "${__module_applied_decl}"; then
		"$@"
	else
		__module_decl_applied_part=$(list_last ':' "${__module_applied_decl}")
		__module_applied_decl=$(list_start ':' "${__module_applied_decl}")
		__module_decl_apply \
			"${__module_applied_decl}" \
			"$@" "${__module_decl_applied_part}"
		unset __module_applied_part
	fi
	unset __module_applied_decl
}

# Add a declaration to the current scope
__module_scope_decl_add () {
	__module_SCOPE_STACK=$(
		list_push \
			',' "${__module_SCOPE_STACK}" \
			"$(__module_decl_new "$@")" \
	)
}

# Check if in a function scope
__module_in_scope () {
	test "${__module_SCOPE_DEPTH}" -ne 0
}

# External commands

# Module declaration
module () {
	true
}

end_module () {
	true
}

# Extended import use
use () {
	true
}

# Public declarations
pub () {
	true
}

# global and local variable declarations
var () {
	__module_var_name=$1; shift
	shift # Skip '='
	__module_var_value=$1; shift

	if __module_in_scope; then
		__module_scope_decl_add "var" "${__module_var_name}"
	fi

	eval "${__module_var_name}=${__module_var_value}"

	unset __module_var_name
	unset __module_var_value
}

# function declarations
fn () {
	__module_fn_name=$1; shift

	if __module_in_scope; then
		__module_current_scope="${__module_SCOPE_DEPTH}"
		__module_fn_real_name="__module_SCOPE_FN_${__module_current_scope}_${__module_fn_name}"
		eval "alias ${__module_fn_name}=${__module_fn_real_name}"

		__module_scope_decl_add "fn" "${__module_fn_real_name}"
		__module_scope_decl_add "alias" "${__module_fn_name}" "${__module_fn_real_name}"

		unset __module_fn_real_name
	fi

	unset __module_fn_name
	unset __module_current_scope
}

# function scopes
scope () {
	__module_scope_push
}

end_scope () {
	__module_scope_pop
}

# function return
alias scope_return="end_scope && return"
