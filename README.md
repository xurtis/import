# Shell Imports

This is a handy utility for accessing a number of shell libraries across
a number of scripts.

To use it just add the following line to any POSIX-compatible shell
script:

```sh
which import 2&>1 > /dev/null \
		|| source <(curl -Ls https://xurtis.pw/import/import.sh)
```

Once that line is added any of the libraries provided by this repository
can be added using the `import` command.

For example:

```sh
import color

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

## Libraries

 * [color](color.md)
