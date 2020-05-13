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

__module_NAMESPACE_STACK=""

# Each namespace gets a set of declarations
#
# __module_DECLS_<namespace> := [ ; <ns-decl> ] ...
#
# ns-decl
#   := : <name> : <visibility> : fn
#   |  : <name> : <visibility> : const
#   |  : <name> : <name> : <visibiltiy> : alias

# Push a new namespace onto the namespace stack
__module_namespace_push () {
	__module_namespace_name=$1; shift
	__module_NAMESPACE_STACK=$( \
		list_push \
			';' "${__module_NAMESPACE_STACK}" \
			"ns-${__module_namespace_name}"
	)
	# Set the given namespace to be empty
	eval "$(__module_ns_new_global "DECLS")=\"\""
	unset __module_namespace_name
}

__module_namespace_push_empty () {
	__module_NAMESPACE_STACK=$( \
		list_push \
			';' "${__module_NAMESPACE_STACK}" \
			"no-ns"
	)
}

# Pop the current namespace from the stack
__module_namespace_pop () {
	__module_NAMESPACE_STACK=$( \
		list_start ';' "${__module_NAMESPACE_STACK}" \
	)
}

# Get the current namespace used for declaration
__module_namespace_current () {
	if __module_in_namespace; then
		__module_namespace_current_name=$(\
			list_last ';' "${__module_NAMESPACE_STACK}" \
		)
		echo "${__module_namespace_current_name#ns\-}"
		unset __module_namespace_current_name
	fi
}

__module_in_namespace () {
	if list_empty "${__module_NAMESPACE_STACK}"; then
		return 1
	elif [ "$(list_last ';' "${__module_NAMESPACE_STACK}")" = "no-ns" ]; then
		return 1
	else
		return 0
	fi
}

# Add a declaration to the current namespace
__module_namespace_decl_add () {
	eval "__module_namespace_decls=\$$(__module_ns_new_global "DECLS")"
	__module_namespace_decls=$(
		list_push \
			';' "${__module_namespace_decls}" \
			"$(__module_decl_new "$@")" \
	)
	eval "$(__module_ns_new_global "DECLS")=\$__module_namespace_decls"
	unset __module_namespace_decls
}

# Generate a name for a global namespace item
__module_ns_global_name () {
	__module_namespace_gen_name="__module_NS"
	while [ "$#" -gt 0 ]; do
		__module_namespace_gen_name="${__module_namespace_gen_name}_$1"
		shift
	done
	echo "${__module_namespace_gen_name}"
	unset __module_namespace_gen_name
}

__module_ns_new_global () {
	__module_ns_global_name "$(__module_namespace_current)" "$@"
}

# Context namespaces
# ==================
#
# These describe an overlay of the global scope

# Load the context of a given namespace
__module_load () {
	__module_load_name=$1; shift
	__module_load_prefix=$1; shift
	__module_load_visibility=$1; shift

	eval "__module_load_decl_list=\$$(__module_ns_global_name "${__module_load_name}" "DECLS")"

	# Importing the explicit items first means that explicit variable
	# imports will over-write implicit variable imports
	__module_load_specifics \
		"${__module_load_name}" \
		"${__module_load_visibility}" \
		"$@"

	list_foreach \
		';' "$__module_load_decl_list" \
		__module_decl_apply_foreach \
			__module_load_single \
				"${__module_load_name}" \
				"${__module_load_prefix}" \
				"${__module_load_visibility}"

	unset __module_load_name
	unset __module_load_prefix
	unset __module_load_visibility
	unset __module_load_decl_list
	unset __module_load_decl_item
}

__module_load_specifics () {
	__module_load_specifics_name=$1; shift
	__module_load_specifics_visibility=$1; shift

	eval "__module_load_specifics_decl_list=\$$(__module_ns_global_name "${__module_load_specifics_name}" "DECLS")"

	# Importing the explicit items first means that explicit variable
	# imports will over-write implicit variable imports
	while [ "$#" -gt 0 ]; do
		__module_load_specifics_decl_item=$1; shift
		list_foreach \
			';' "$__module_load_specifics_decl_list" \
			__module_decl_apply_foreach \
				__module_load_single_direct \
					"${__module_load_specifics_name}" \
					"${__module_load_specifics_visibility}" \
					"${__module_load_specifics_decl_item}"
	done

	unset __module_load_specifics_name
	unset __module_load_specifics_visibility
	unset __module_load_specifics_decl_list
	unset __module_load_specifics_decl_item
}

# Load a single item from a module
__module_load_single () {
	__module_load_single_name=$1; shift
	__module_load_single_prefix=$1; shift
	__module_load_single_accept_visibility=$1; shift
	__module_load_single_kind=$1; shift
	__module_load_single_visibility=$1; shift
	__module_load_single_item=$1; shift

	# Don't expose private members
	if [ "${__module_load_single_accept_visibility}" = "public" ]; then
		if [ "${__module_load_single_visibility}" != "public" ]; then
			unset __module_load_single_name
			unset __module_load_single_prefix
			unset __module_load_single_kind
			unset __module_load_single_visibility
			unset __module_load_single_item
			return
		fi
	fi

	case "${__module_load_single_kind}" in
		"const")
			if __module_in_namespace; then
				__module_namespace_decl_add \
					"const" \
					"private" \
					"${__module_load_single_prefix}${__module_load_single_item}"
				eval "$(__module_ns_new_global "CONST" "${__module_load_single_prefix}${__module_load_single_item}")=\$$(__module_ns_global_name "${__module_load_single_name}" "CONST" "${__module_load_single_item}")"
			fi
			__module_scope_decl_add \
				"var" \
				"${__module_load_single_prefix}${__module_load_single_item}"
			eval "${__module_load_single_prefix}${__module_load_single_item}=\$$(__module_ns_global_name "${__module_load_single_name}" "CONST" "${__module_load_single_item}")"
			;;
		"var")
			if __module_in_namespace; then
				__module_namespace_decl_add \
					"dup" \
					"private" \
					"${__module_load_single_prefix}${__module_load_single_item}" \
					"$(__module_ns_global_name "${__module_load_single_name}" "VAR" "${__module_load_single_item}")"
			fi
			__module_scope_decl_add \
				"dup" \
				"${__module_load_single_prefix}${__module_load_single_item}" \
				"$(__module_ns_global_name "${__module_load_single_name}" "VAR" "${__module_load_single_item}")"
			eval "${__module_load_single_prefix}${__module_load_single_item}=\$$(__module_ns_global_name "${__module_load_single_name}" "VAR" "${__module_load_single_item}")"
			;;
		"fn")
			if __module_in_namespace; then
				__module_namespace_decl_add \
					"alias" \
					"private" \
					"${__module_load_single_prefix}${__module_load_single_item}" \
					"$(__module_ns_global_name "${__module_load_single_name}" "FN" "${__module_load_single_item}")"
			fi
			__module_scope_decl_add \
				"alias" \
				"${__module_load_single_prefix}${__module_load_single_item}" \
				"$(__module_ns_global_name "${__module_load_single_name}" "FN" "${__module_load_single_item}")"
			eval alias "${__module_load_single_prefix}${__module_load_single_item}=$(__module_ns_global_name "${__module_load_single_name}" "FN" "${__module_load_single_item}")"
			;;
		"alias")
			__module_load_single_target=$1; shift
			__module_scope_decl_add \
				"alias" \
				"${__module_load_single_prefix}${__module_load_single_item}" \
				"${__module_load_single_target}"
			eval alias "${__module_load_single_prefix}${__module_load_single_item}=${__module_load_single_target}"
			;;
		"dup")
			__module_load_single_target=$1; shift
			__module_scope_decl_add \
				"dup" \
				"${__module_load_single_prefix}${__module_load_single_item}" \
				"${__module_load_single_target}"
			eval "${__module_load_single_prefix}${__module_load_single_item}=\$${__module_load_single_target}"
			;;
	esac


	unset __module_load_single_name
	unset __module_load_single_prefix
	unset __module_load_single_accept_visibility
	unset __module_load_single_kind
	unset __module_load_single_visibility
	unset __module_load_single_item
	unset __module_load_single_target
}

__module_load_single_direct () {
	__module_load_single_name=$1; shift
	__module_load_single_accept_visibility=$1; shift
	__module_load_single_match=$1; shift
	__module_load_single_kind=$1; shift
	__module_load_single_visibility=$1; shift
	__module_load_single_item=$1; shift

	if [ "${__module_load_single_match}" = "${__module_load_single_item}" ]; then
		__module_load_single \
			"${__module_load_single_name}" \
			"" \
			"${__module_load_single_accept_visibility}" \
			"${__module_load_single_kind}" \
			"${__module_load_single_visibility}" \
			"${__module_load_single_item}" \
			"$@"
	fi

	unset __module_load_single_name
	unset __module_load_single_accept_visibility
	unset __module_load_single_match
	unset __module_load_single_kind
	unset __module_load_single_visibility
	unset __module_load_single_item
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
#   |  : <name> : <name> : dup
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
	case "$1" in
		"var")
			eval "$(__module_scope_name "VAR" "$2")=\$$2"
			unset -v "$2"
			;;
		"alias")
			unalias "$2"
			;;
		"dup")
			eval "$3=\$$2"
			unset -v "$2"
			;;
	esac
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
		"dup")
			eval "$3=\$$2"
			unset -v "$2"
			;;
	esac
}

# Restore the contents of the current scope
__module_scope_restore_decl () {
	case "$1" in
		"var")
			eval "$2=\$$(__module_scope_name "VAR" "$2")"
			unset -v "$(__module_scope_name "VAR" "$2")"
			;;
		"alias")
			eval alias "$2=$3"
			;;
		"dup")
			eval "$2=\$$3"
			;;
	esac
}

__module_scope_name () {
	__module_scope_gen_name="__module_SCOPE_${__module_SCOPE_DEPTH}"
	while [ "$#" -gt 0 ]; do
		__module_scope_gen_name="${__module_scope_gen_name}_$1"
		shift
	done
	echo "${__module_scope_gen_name}"
	unset __module_scope_gen_name
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
		unset __module_apply_rotate_first
	done

	__module_decl_apply "$@"
	unset __module_apply_rotate
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
		unset __module_decl_applied_part
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
	test "${__module_SCOPE_DEPTH}" -ge 0
}

# Log the current state of module
if [ "${__module_STATE_LOG+set}" != "set" ]; then
	__module_STATE_LOG="$(realpath -e "$PWD")/.module-state"
fi
__module_log_state () {
	set | grep -e "^__module" | sort > "${__module_STATE_LOG}"
}
__module_log_state

# External commands

# Module declaration
module () {
	__module_scope_push
	__module_module_name=$1; shift
	__module_namespace_push "${__module_module_name}"
	unset __module_module_name
	__module_log_state
}

end_module () {
	if [ "${__module_SCOPE_DEPTH}" -gt 0 ]; then
		__module_namespace_pop
		__module_scope_pop
		__module_log_state
	fi
}

# Extended import use
use () {
	__module_use_name=$1; shift

	if [ "$1" = "as" ]; then
		shift;
		__module_use_alias=$1; shift
	else
		__module_use_alias=$__module_use_name
	fi

	# Ensure $@ refers to the items to import
	if [ "$1" = "using" ]; then
		shift;
	else
		set --
	fi

	__module_load \
		"${__module_use_name}" \
		"${__module_use_alias}_" \
		"public" \
		"$@"

	unset __module_use_name
	unset __module_use_alias
	__module_log_state
}

# Only use specific items
from () {
	__module_use_name=$1; shift

	if [ "$1" = "use" ]; then
		shift # skip 'use'
	else
		set --
	fi

	instantiate_library "${__module_use_name}"

	__module_load_specifics \
		"${__module_use_name}" \
		"public" \
		"$@"

	unset __module_use_name
	__module_log_state
}

# Public declarations
pub () {
	"$@" "public"
	__module_log_state
}

# global and local variable declarations
var () {
	__module_var_name=$1; shift
	shift # Skip '='
	__module_var_value=$1; shift
	__module_var_visibility=${1:-private};

	if __module_in_scope; then
		if __module_in_namespace; then
			__module_namespace_decl_add "var" "${__module_var_visibility}" "${__module_var_name}"
			eval "$(__module_ns_new_global "VAR" "${__module_var_name}")=\"${__module_var_value}\""
		else
			__module_scope_decl_add "var" "${__module_var_name}"
		fi
	fi

	eval "${__module_var_name}=\"${__module_var_value}\""

	unset __module_var_name
	unset __module_var_value
	unset __module_var_visibility
	__module_log_state
}

# Module constant definitions
const () {
	__module_const_name=$1; shift
	shift # Skip '='
	__module_const_value=$1; shift
	__module_const_visibility=${1:-private};

	if __module_in_namespace; then
		__module_namespace_decl_add "const" "${__module_const_visibility}" "${__module_const_name}"
		eval "$(__module_ns_new_global "CONST" "${__module_const_name}")=\"${__module_const_value}\""
	fi

	if __module_in_scope; then
		__module_scope_decl_add "var" "${__module_const_name}"
	fi

	eval "${__module_const_name}=\"${__module_const_value}\""

	unset __module_const_name
	unset __module_const_value
	unset __module_const_visibility
	__module_log_state
}

# function declarations
fn () {
	__module_fn_name=$1; shift
	__module_fn_visibility=${1:-private};

	if __module_in_scope; then
		if __module_in_namespace; then
			__module_fn_real_name="$(__module_ns_new_global "FN" "${__module_fn_name}")"
			__module_namespace_decl_add "fn" "${__module_fn_visibility}" "${__module_fn_name}"
		else
			__module_fn_real_name="$(__module_scope_name "FN" "${__module_fn_name}")"
			__module_scope_decl_add "fn" "${__module_fn_real_name}"
		fi

		eval "alias ${__module_fn_name}=${__module_fn_real_name}"

		__module_scope_decl_add "alias" "${__module_fn_name}" "${__module_fn_real_name}"

		unset __module_fn_real_name
	fi

	unset __module_fn_name
	unset __module_fn_visibility
	__module_log_state
}

# function scopes
scope () {
	if [ "$#" -gt 0 ]; then
		__module_scope_ns=$1; shift
	else
		__module_scope_ns="__global"
	fi

	__module_namespace_push_empty
	__module_scope_push

	if [ "$1" = "using" ]; then
		shift
		__module_load_specifics "${__module_scope_ns}" "private" "$@"
	else
		__module_load "${__module_scope_ns}" "" "private"
	fi

	unset __module_scope_ns
	__module_log_state
}

end_scope () {
	if [ "${__module_SCOPE_DEPTH}" -gt 0 ]; then
		__module_scope_pop
		__module_namespace_pop
		__module_log_state
	fi
}

# function return
alias scope_return="end_scope && return"

# Initialisation
__module_namespace_push "__global"
