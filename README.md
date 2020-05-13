# Shell Imports

This is a handy utility for accessing a number of shell libraries across
a number of scripts.

To use it just add the following line to any POSIX-compatible shell
script:

```sh
if ! which shell_import_defined 2&>1 > /dev/null; then
	import_script=$(mktemp)
	curl -Ls -o "${import_script}" https://xurtis.pw/import/import.sh
	_="${import_script}"
	. "${import_script}"
	rm "${import_script}"
fi
```

Once that line is added any of the libraries provided by this repository
can be added using the `import` command.

For example:

```sh
import color using span BOLD YELLOW_FG

echo "This is $(span $YELLOW_FG $BOLD "exciting")!"
```

You can also run command scripts from this repository with the `run`
command.

## Local install

You can maintain a local install of `import` by running the following in
any terminal:

```sh
curl -Ls "https://xurtis.pw/import/local-import.sh" | sh
```

The command will print an alternative to add to scripts to use your
local copy of install rather than the one loaded from the internet.

Adding that line to your init script should also override all uses of
`import` to use your locally maintained version rather than fetching
from the internet every time.

You can then update you install by either running the command `run
import-update` with `import` already sourced as described above.

## Writing scripts

This tool implements two concepts on top of the standard POSIX shell
command language: scopes and namespaces (modules).

### Writing functions with scopes

Writing functions with scopes is easy:
	
 * Start every function with a `scope` statement, and
 * Always use `scope_return` to leave a function.

```sh
foo () {
	scope

	if [ "$#" -gt 0 ]; then
		echo "Too many arguments" > /dev/stderr
		scope_return 1
	fi

	echo "This is foo"

	scope_return
}
```

Function scopes help to constrain local variables. Every variable should
be declared using a `var` statement as in the following example.

```sh
factorial () {
	scope
	var factor = "$1"; shift

	case "$factor" in
		0)
			echo "1"
			;;
		*)
			var sub_factor = "$(factorial "$(($factor - 1))")"
			echo "$(($factor * $sub_factor))"
			;;
	esac
	scope_return
}
```

### Constructing namespaced modules

A module is a collection of items including variables, constants, and
functions.

To create a module, at the start of a script use the `module` statement
and at the end use the `end_module` statement.

```sh
# Within foo.sh

module foo

# ... item declarations ...

pub fn bar
bar () {
	scope foo

	# ...

	scope_return
}

pub const BAZ = 1

pub const QUX = 2

end_module
```

To then use the public items from any of the modules declared in import
libs, use an `import` statement.

```sh
# Imports bar and BAZ directly and QUZ as foo_QUX
import foo using bar BAZ
```

Any item can be made *public* by prefixing its declaration with `pub`.

Only public items can be used outside of the module.

All items from a module are implicitly imported with the prefix
`<name>_` where `<name>` was the argument of the `module` statement that
was used to declare the module. This will usually be the same as the
name of the script.

An `import` statement can be extended with a `using` statement followed
by a list of item names to be imported without prefixing their names.

#### Constants

The easiest items to create in a module are constants. An imported
constant cannot be used to change its global value.

```sh
# Private constant, only visible within the module
const FOO = 1

# Public constant that cab be imported
pub const BAR = 2
```

#### Functions

Most items in modules will be functions. These are reusable sections of
script that can be invoked as commands that use the same shell context.

**Note:** Some shell implementations such as `zsh` prevent the use of a
(fairly sketchy) part of the POSIX shell standard that is required to
implement the scoping of functions.

A function declaration in a module must be preceeded by a `fn` or `pub
fn` statement as follows.

```sh
module qux

# Private function foo
fn foo
foo () {
	scope qux
	# ...
	scope_return
}

# Public function bar
pub fn bar
bar () {
	scope qux using foo
	# ...
	scope_return
}

# Public function baz, only uses foo from the module
pub fn baz
baz () {
	scope qux using foo
	# ...
	scope_return
}

end_module
```

Scope statements within functions should use the module name where they
require any items provided by the module (including private items).

Where a function only requires a subset of the items from the module,
the `scope` statement can be extended by adding `using` followed by the
list of items required from the module. This may speed up functions from
libraries with large numbers of items.

#### Variables

Modules can also export variables which will be updated globally.

```sh
module qux

# Private variable foo
var foo = 12

# Public variable bar
pub var bar = 12

end_module
```

When importing variables directly (i.e. with a `using` statement) any
changes to the prefixed import will be ignored.

## Libraries

 * [color](docs/color.md)
