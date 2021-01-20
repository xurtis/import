======================
 LCA2021 Demo Scripts
======================

:Author: Curtis Millar
:Date: 25 January 2021

Function demo
=============

.. This demonstrates that functions that re-use the same variable names
   in fact re-use the same variables.

.. code:: bash

    cd function
    pcat install_file.sh | less -R
    tree
    . ./install_file.sh
    install_file from_dir/file_one to_dir/file_two
    tree
    rm -rf to_dir
    install_many from_dir to_dir file_one file_two file_three
    tree
    pcat install_file.sh | less -R

Scoped functions demo
=====================

.. This demonstrates some scoped functions maintain the call stack

.. code:: bash

    cd function-scope

    pcat func_vars.sh | less -R
    . ./func_vars.sh
    func1
    # uncomment set | grep '^__module_SCOPE'
    . ./func_vars.sh
    func1

    pcat install_file.sh | less -R
    . ./install_file.sh
    install_many from_dir to_dir file_one file_two file_three

Modules demo
============

.. This demonstrates module scope, you can import from modules functions
   from modules maintain the module context.

.. code:: bash

   cd modules

   pcat color.sh | less -R
   uncomment set | grep '^__module'
   . ./color.sh
   uncomment set | grep '^__module'
   echo "This is $(span $FG_CYAN "cyan")"
   echo "This is $(span $FG_RED "red")"
   use color using span FG_CYAN
   uncomment set | grep '^__module'
   echo "This is $(span $FG_CYAN "cyan")"
   echo "This is $(span $FG_RED "red")"
   echo "This is $(span $color_FG_RED "red")"
   echo "This is $(color_span $color_FG_RED "red")"
   echo "This is $(color_span $color_FG_CYAN "cyan")"

import demo
===========

.. This demonstrates how import packages these ideas together.

.. code:: bash

   cd modules
   pcat main.sh | less -R
   ./main.sh

----

Recursion demo
==============

.. This demonstrates that subshelled functions only use *copies* of
   variables so can't mutate the outer scope

.. Maybe drop this one?

.. code:: bash

    cd recursion
    pcat factorial.sh | less -R
    . ./factorial.sh
    factorial 5

Source demo
===========

.. This demonstrates that variables used in other scripts can cause
   issue when sourced.

   Maybe drop this one too?
