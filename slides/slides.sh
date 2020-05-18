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
	BR_YELLOW_FG

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

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "Questions?")
__slide

slide <<- __slide
	$(span $BOLD $BR_WHITE_FG "fin")
__slide

present
