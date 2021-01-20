#!/usr/bin/dash

# Set up import
_="${0%/*}/../local-init.sh"
. "${0%/*}/../local-init.sh"

import slides using slide present
from color use \
	span \
	style \
	unstyle \
	BOLD \
	ITALIC \
	UNDERLINE \
	BR_GREEN_FG \
	BR_CYAN_FG \
	BR_WHITE_FG \
	RED_FG \
	BR_YELLOW_FG \
	BR_BLACK_FG

# 0 Introduction

# 0.1 Title

slide <<- __slide
	   $(span $BOLD $BR_GREEN_FG "Overcoming the limitations")
	   $(span $BOLD $BR_GREEN_FG "of the POSIX command shell")


	          $(span $ITALIC $BR_WHITE_FG "18 May 2020")
	         $(span $ITALIC $BR_WHITE_FG "Curtis Millar")

	$(span $UNDERLINE $BR_CYAN_FG "https://github.com/xurtis/import")
__slide

slide <<- __slide
	     $(span $BOLD $BR_GREEN_FG "How I learned to stop")
	    $(span $BOLD $BR_GREEN_FG "worrying and  love") $(span $ITALIC $BOLD $BR_GREEN_FG "eval")


	          $(span $ITALIC $BR_WHITE_FG "18 May 2020")
	         $(span $ITALIC $BR_WHITE_FG "Curtis Millar")

	$(span $UNDERLINE $BR_CYAN_FG "https://github.com/xurtis/import")
__slide

# 0.2 Who am I?

slide <<- __slide
	          $(span $BOLD $BR_WHITE_FG "Who am I?")

	        Curtis Millar

	     Research Engineer at
	 UNSW Sydney & CSIRO's Data61

	Work on the seL4 microkernel &
	     surrounding systems
__slide

# 0.5 Today's talk topic

slide <<- __slide
	      $(span $BOLD $BR_WHITE_FG "Today's talk")

	* POSIX
	* Command Shell Language
	* Global variable scope
	* Extending scope
	  * Functions
	  * Namespaces (modules)
	* import
	* Lessons learnt
__slide

# 1 POSIX & The POSIX Shell

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "The POSIX Command Shell")
__slide

# 1.1 POSIX is an operating system interface

slide <<- __slide
	            $(span $BOLD $BR_WHITE_FG "What is POSIX?")

	* Operating system interface standard
	* Distilled from UNIX and derivatives
	* Includes
	  * C lanugage API
	  * Filesystem layout requirements
	  * Shell command language
	    specification
	  * Many other components...
__slide

# 1.2 The POSIX Shell Command Language

slide <<- __slide
	       $(span $BOLD $BR_WHITE_FG "Command Shell Language")

	* High-level language specification
	* Invokes and communicates between
	  other applications
	* Lives at /bin/sh
	* All POSIX must have it & must be
	  compliant
	* Often extended (e.g. bash, zsh...)
__slide

# 1.3 Why is it important

slide <<- __slide
	         $(span $BOLD $BR_WHITE_FG "Why is it useful?")

	* Platform & architecture agnostic
	* Known & reliable behaviour
	* Know how to invoke it
	  * #!/bin/sh
	  * /bin/sh /path/to/script [arg...]
	* Stanard way to run arbitrary code
__slide

# You can inspect the system to search for other dependencies
# You can interact with a user

# 1.4 What can it do?

# - Features

slide <<- __slide
	   $(span $BOLD $BR_WHITE_FG "Features of the POSIX shell")   

	* $(span $UNDERLINE $BR_WHITE_FG "Variables")
	* $(span $UNDERLINE $BR_WHITE_FG "Loops")
	* $(span $UNDERLINE $BR_WHITE_FG "Conditional branches")
	* $(span $UNDERLINE $BR_WHITE_FG "Parameter expansion")
	* $(span $UNDERLINE $BR_WHITE_FG "Command substitution")
	* $(span $UNDERLINE $BR_WHITE_FG "Functions")
	* Token aliasing
	* Arithemtic expansion
__slide

slide <<- __slide
	   $(span $BOLD $BR_WHITE_FG "Features of the POSIX shell")   

	* $(span $RED_FG "Field splitting")
	* $(span $RED_FG "Pathname expansion")
	* $(span $RED_FG "Quote removal")
	* Redirection
	* Here-documents
	* Pipelines
	* File descriptor manipulation
	* Command / statement Lists
__slide

# 1.5 How is it used?

slide <<- __slide
	          $(span $BOLD $BR_WHITE_FG "How is it used?")

	* Code distribution
	* Called by other tools (via $(span $ITALIC system))
	* Any time high-level code is needed
	  that only depends on the OS
	  interface
__slide

# - Any time you want to write high level code with only a dependency on
#   the operating system interface (e.g. to detect/check second-order
#	dependencies)

# 2 The limitations of the POSIX shell

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "Global scope")
__slide

# 2.1 POSIX Shell only has global variable scope

slide <<- __slide
	   $(span $BOLD $BR_WHITE_FG "There is only global scope")

	* A variable name always refers
	  to the same variable
	* New instances for all variables
	  in new subshells
	* Need to know every use of any
	  variable name used
	* Overlaps with environment
	  variables
__slide

# 2.2 Example 1 - common variables in functions
slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "Function demo")
__slide

# 3 Function scope

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "Function scope")
__slide

# 3.1 What is function scope?

slide <<- __slide
	   $(span $BOLD $BR_WHITE_FG "What is function scope?")

	* Create new variable context
	  when calling a function
	* Only variables in that
	  context can be modified
	* Returning destroys the
	  active variable context
	* Restore previous active
	  context on return
__slide

# 3.2 How do we model function scope?

slide <<- __slide
	   $(span $BOLD $BR_WHITE_FG "Modelling function scope")

	* Use a (call) stack!
	* Function entry
	  * Save variables to context
	  * Push context onto stack
	  * Remove all variables
	* Function exit
	  * Remove all varaibles
	  * Pop context from stack
	  * Set variables from context
__slide

# 3.4 How do we implement function scope

slide <<- __slide
	         $(span $BOLD $BR_WHITE_FG "Implementing function scope")

	$(span $RED_FG "eval") "STACK_$(span $BR_YELLOW_FG "\${depth}")_$(span $BR_YELLOW_FG "\${varname}")=\\\$$(span $BR_YELLOW_FG "\${varname}")"

	$(span $RED_FG "unset") -v "$(span $BR_YELLOW_FG "\${varname}")"
__slide

slide <<- __slide
	   $(span $BOLD $BR_WHITE_FG "Implementing function scope")

	* Use a list as stack of contexts
	* Use $(span $RED_FG "scope") to mark function entry
	* Track variables in scope with
	  $(span $RED_FG "var") declarations
	* Use $(span $RED_FG "scope_return") to mark return
__slide

# 3.5 Demo

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "Scoped functions demo")
__slide

# 4 Module scope

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "Modules")
__slide

# 4.1 What is module scope?

slide <<- __slide
	       $(span $BOLD $BR_WHITE_FG "What is a module?")

	* A set of named items
	  * Variables
	  * Constants
	  * Functions
	* You can introduce some or all
	  of the items into the current
	  scope
	* Functions from the module
	  include the other items in
	  their scope
__slide

# - Module instantiation (on a stack)
# - Including module scope in functions from the module

# 4.2 How do we model module scope?

slide <<- __slide
	        $(span $BOLD $BR_WHITE_FG "Modelling modules")

	* The module is the result of
	  executing the script in which
	  it is defined
	* Use a stack to track the module
	  being constructed
	* Tie named variables in other
	  modules and scopes to the ones
	  from the modules
__slide

# 4.3 How do we implement module scope?

slide <<- __slide
	            $(span $BOLD $BR_WHITE_FG "Functions in modules")


	$(span $RED_FG "eval") $(span $RED_FG "alias") "$(span $BR_YELLOW_FG "\${fn_name}")=__$(span $BR_YELLOW_FG "\${module}")_$(span $BR_YELLOW_FG "\${fn_name}")"

	$(span $RED_FG "unalias") "$(span $BR_YELLOW_FG "\${fn_name}")"
__slide

slide <<- __slide
	      $(span $BOLD $BR_WHITE_FG "Implementing modules")

	* Use a list as stack of modules
	* Use $(span $RED_FG "module") to mark new module
	* Track variables in module with
	  $(span $RED_FG "var") declarations
	* Track constants in module with
	  $(span $RED_FG "const") declarations
	* Track functions in module with
	  $(span $RED_FG "fn") declarations
	* Use $(span $RED_FG "end_module") to mark return
	* Add module to scope with $(span $RED_FG "use")
__slide

# 4.4 Demo

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "Modules demo")
__slide

# 5 import

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG $ITALIC "import")
__slide

# 5.1 What is import

slide <<- __slide
	       $(style $BOLD $BR_WHITE_FG)What is $(style $ITALIC)import$(style $REGULAR $BOLD)?$(unstyle)

	* Function scoping
	* POSIX Shell modules
	* Module resolution & loading
	* Can use remote module store
	* Can use module store on
	  local filesystem
__slide

# A system for managing re-usable POSIX shell modules

# 5.2 How do we use it?

slide <<- __slide
	$(pygmentize -O style=monokai import_load_example.sh)
__slide

slide <<- __slide
	$(pygmentize -O style=monokai import_load_local_example.sh)
__slide

slide <<- __slide
	$(head -n 12 modules/color.sh \
		| pygmentize -O style=monokai -l sh)
	$(span $BR_BLACK_FG "# ...")
__slide

slide <<- __slide
	$(span $BR_BLACK_FG "# ...")
	$(tail -n +13 modules/color.sh \
		| pygmentize -O style=monokai -l sh)
__slide

# 5.3 Demo

slide <<- __slide
	$(style $BOLD $BR_WHITE_FG $ITALIC)import$(style $REGULAR $BOLD) demo$(unstyle)
__slide

# 5.4 Should we use this?

slide <<- __slide
	    $(span $BOLD $BR_WHITE_FG "Should we use this?")

	* Ergonomic
	* Convenient
	* Needs code signing
	* Needs auditing
	* Adds substantial overheads
	* Requires strict POSIX
	  compliance
__slide

# 6 What does this teach us?

slide <<- __slide
	         $(span $BOLD $BR_WHITE_FG "Lessons learnt")

	* High-level language as part of
	  OS interface is very useful
	* Command Language scales poorly
	* Need to know all uses of
	  every variable
	* Changes to sourced scripts can
	  easily break dependent scripts
	* Probably best do make minimal
	  use of shell
__slide

# 7 Questions

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "Questions?")
__slide

# 8 fin

slide <<- __slide
	       $(span $BOLD $BR_WHITE_FG "Thanks for watching")

	    The slides can be found at
	    $(span $UNDERLINE $BR_CYAN_FG "https://xurtis.pw/lca2021")

	The import project can be found at
	 $(span $UNDERLINE $BR_CYAN_FG "https://github.com/xurtis/import")
__slide

# Where to find import

# Where to find the slides

present
exit 0

# -- OLD SLIDES PAST HERE ---

slide <<- __slide
	   The shell is the  tool that allows
	    us to build complex systems from
	  small independant component programs
__slide

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "Have you ever  had this problem?")








__slide

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "Have you ever  had this problem?")

	   Someone asks for your help
	and you go to use their terminal





__slide

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "Have you ever  had this problem?")

	   Someone asks for your help
	and you go to use their terminal

	 And you find  that none of the
	 tools you're used to are there



__slide

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "Have you ever  had this problem?")

	   Someone asks for your help
	and you go to use their terminal

	 And you find  that none of the
	 tools you're used to are there

	   Becuase they only use $(span $BOLD $ITALIC "dash")
__slide

slide <<- __slide
	$(style $BOLD $BR_WHITE_FG)$(cowsay -f "flaming-sheep" "I have many problems, but that isn't one of them.")$(unstyle)
__slide

slide <<- __slide
	      $(span $BOLD $BR_WHITE_FG "  Have you ever needed to")
	      $(span $BOLD $BR_WHITE_FG "distribute a  shell script?")

	* They make it easy to communicate a
	  build process

	* Can be used to set up a tool-chain

	* Make long and complex processes easily
	  repeatable
__slide

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "What shell are your users using?")

	            * $(span $BOLD $ITALIC "bash")
	            * $(span $BOLD $ITALIC "ksh")
	            * $(span $BOLD $ITALIC "tcsh")
	            * $(span $BOLD $ITALIC "zsh")
	            * $(span $BOLD $ITALIC "fish")
	            * $(span $BOLD $ITALIC "dash")
	            * $(span $BOLD $ITALIC "ash")
__slide

slide <<- __slide
	  $(span $BOLD $BR_WHITE_FG "The POSIX shell command language")

	* A standard

	* Part of the larger POSIX /
	  Single UNIX Standard

	* Most shells are satisfy (most) of
	  the requirements of the standard

	* The lowest common denominator
__slide

slide <<- __slide
	   $(span $BOLD $BR_WHITE_FG "Features of the POSIX shell")   

	* $(span $UNDERLINE $BR_WHITE_FG "Variables")
	* $(span $UNDERLINE $BR_WHITE_FG "Loops")
	* $(span $UNDERLINE $BR_WHITE_FG "Conditional branches")
	* $(span $UNDERLINE $BR_WHITE_FG "Parameter expansion")
	* $(span $UNDERLINE $BR_WHITE_FG "Command substitution")
	* $(span $UNDERLINE $BR_WHITE_FG "Functions")
	* Token aliasing
	* Arithemtic expansion
__slide

slide <<- __slide
	* Basically everything needed for a
	  complete programming language

	* Interpreter already installed on
	  a wide range of machines

	* Completely portable

	* What if we try and use it like a
	  programming language?
__slide

slide <<- __slide
	$(pygmentize -O style=monokai gcd.sh)
__slide

slide <<- __slide
	$(pygmentize -O style=monokai rec_gcd.sh)
__slide

slide <<- __slide
	  $(span $BOLD $BR_WHITE_FG "But what about the things for")
	$(span $BOLD $BR_WHITE_FG "which actually use shell scripts?")
__slide

slide <<- __slide
	$(pygmentize -O style=monokai install_file.sh)
__slide

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "POSIX shell only has global scope")

	  * Only one instance of every
	    variable

	  * Need to be aware of every
	    possible usage of every
	    variable
__slide

slide <<- __slide
	$(pygmentize -O style=monokai factorial.sh)
__slide

slide <<- __slide
	  $(span $BOLD $BR_WHITE_FG "Can we improve  the situation?")

	$(span $BOLD $BR_WHITE_FG "Could we") $(span $BOLD $BR_WHITE_FG $ITALIC "implement") $(span $BOLD $BR_WHITE_FG "function scope?")
__slide

slide <<- __slide
	1. Hook function entry & exit

	2. Hook variable declaration

	3. Save variables on a stack

	4. ...?

	5. Profit
__slide

slide <<- __slide
	     $(span $BOLD $BR_WHITE_FG "Hook function entry & exit")     

	* Introduce $(span $BOLD $ITALIC "scope") and $(span $BOLD $ITALIC "end_scope") statements

	* Alias $(span $BOLD $ITALIC "scope_return") to
	  $(span $BOLD $ITALIC "end_scope && return")

	* Call $(span $BOLD $ITALIC "scope") on function entry

	* Use $(span $BOLD $ITALIC "scope_return") to return
__slide

slide <<- __slide
	$(pygmentize -O style=monokai hook_fn.sh)
__slide

slide <<- __slide
	  $(span $BOLD $BR_WHITE_FG "Hook variable declaration")  

	* Force variable declaration
	  before use

	* Create $(span $BOLD $ITALIC "var") function
	  to handle declaration
__slide

slide <<- __slide
	$(pygmentize -O style=monokai hook_var.sh)
__slide

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "Save variables on a stack")

	* Save variables not currently
	  in scope

	* Associate saved variables
	  with a 'stack frame'

	* Track which variable names
	  are declared in each scope
__slide

slide <<- __slide
	          $(span $BOLD $BR_WHITE_FG "Using shell metaprogramming")          

	$(span $RED_FG "eval") "STACK_$(span $BR_YELLOW_FG "\${depth}")_$(span $BR_YELLOW_FG "\${varname}")=\\\$$(span $BR_YELLOW_FG "\${varname}")"

	$(span $RED_FG "unset") -v "$(span $BR_YELLOW_FG "\${varname}")"
__slide

slide <<- __slide
	When entring a new scope:

	* Save the variables from the current scope
	* Unset all variables in current scope
	* Push a new frame onto the stack

	When leaving a scope
	* Unset all variables in current scope
	* Pop the frame from the stack

	* Associate saved variables
	  with a 'stack frame'

	* Track which variable names
	  are declared in each scope
__slide

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "SCOPES DEMO")
__slide

slide <<- __slide
	            $(span $BOLD $BR_WHITE_FG "Code reuse")

	* Don't want to rewrite code
	  snippets that get reused

	* Want to be able to use libraries
	  of common functions

	* Don't want to need to know about
	  implementation details
__slide

slide <<- __slide
	       $(span $BOLD $BR_WHITE_FG "Can we have modules?")       

	* Groups of variables, constants,
	  and functions

	* Import from module into current
	  scope

	* Functions include their whole
	  module in scope
__slide

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "Modules construct static objects")

	* Construct modules before importing
	  them into a scope (lazily)

	* Track which module is currently
	  being constructed

	* Record names & kinds of every
	  item in each module
__slide

slide <<- __slide
	          $(span $BOLD $BR_WHITE_FG "Using shell more metaprogramming")          

	$(span $RED_FG "eval") $(span $RED_FG "alias") "$(span $BR_YELLOW_FG "\${fn_name}")=__$(span $BR_YELLOW_FG "\${module}")_$(span $BR_YELLOW_FG "\${fn_name}")"

	$(span $RED_FG "unalias") "$(span $BR_YELLOW_FG "\${fn_name}")"
__slide

slide <<- __slide
	$(pygmentize -O style=monokai color.sh)
__slide

slide <<- __slide
	    $(span "So should  we use this?")










__slide

slide <<- __slide
	    $(span "So should  we use this?")

	              No








__slide

slide <<- __slide
	    $(span "So should  we use this?")

	              No

	    It's horrendously slow






__slide

slide <<- __slide
	    $(span "So should  we use this?")

	              No

	    It's horrendously slow

	  It takes  longer to render
	  these slides  than it does
	        to compile seL4


__slide

slide <<- __slide
	    $(span $BR_WHITE_FG $BOLD "So should  we use this?")    

	              No

	    It's horrendously slow

	  It takes  longer to render
	  these slides  than it does
	        to compile seL4

	And string  maniuplation is...
__slide

present
