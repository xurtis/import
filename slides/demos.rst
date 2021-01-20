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
    pcat install_file.sh
    tree
    . ./install_file.sh
    install_file from_dir/file_one to_dir/file_two
    tree
    rm -rf to_dir
    install_many from_dir to_dir file_one file_two file_three
    tree
    pcat install_file.sh

Scoped functions demo
=====================

.. This demonstrates some scoped functions maintain the call stack

.. code:: bash

    cd function-scope

    pcat func_vars.sh
    . ./func_vars.sh
    func1
    # uncomment fn_vars
    . ./func_vars.sh
    func1

    pcat install_file.sh
    . ./install_file.sh
    install_many from_dir to_dir file_one file_two file_three

Modules demo
============

.. This demonstrates module scope, you can import from modules functions
   from modules maintain the module context.

.. code:: bash

   cd modules

   pcat color.sh
   mod_vars
   . ./color.sh
   mod_vars
   echo "This is $(span $FG_CYAN "cyan")"
   echo "This is $(span $FG_RED "red")"
   use color using span FG_CYAN
   mod_vars
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
   pcat main.sh
   ./main.sh
