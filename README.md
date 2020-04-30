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

## Libraries

 * [color](color.md)
