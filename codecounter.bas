
'-------------------------------------------------------------------------------------------------------
'
' codecounter.bas
'
' Purpose:      Recursively count lines of source code and comments in C, BASIC, and general web files.
' Copyright:    Martin Latter, November 2011.
' Credit:       Richard D. Clark (rdc): walkDir() recursive function.
' Version:      1.1
' License:      GNU GPL version 3.0 (GPL v3); http://www.gnu.org/licenses/gpl.html
' URL:          https://github.com/Tinram/CodeCounter.git
'
'-------------------------------------------------------------------------------------------------------


#INCLUDE "dir.bi" ' provides constants to match attributes against

DECLARE SUB header()
DECLARE SUB walkDir(BYVAL sFolder AS STRING, BYREF sC AS STRING)
DECLARE SUB displayTotals()

CONST ATTRIBUTE_MASK = fbNormal OR fbDirectory ' = &h37 | set input attribute mask to allow files that are normal, hidden, system or directory
CONST AS STRING CC_VERSION = "1.1"

DIM AS STRING sCommand = LCASE(COMMAND(1))
DIM SHARED AS UINTEGER iTotalCodeLines = 0, iTotalComments = 0, iTotalFiles = 0

#INCLUDE "includes/subs.bas"


' start
' ------------------------------------------------


IF sCommand = "-v" OR sCommand = "v" THEN

	PRINT
	PRINT "Code Counter v." + CC_VERSION
	PRINT __DATE_ISO__
	PRINT
	PRINT "FBC v." + __FB_VERSION__ + " (" + UCASE(__FB_BACKEND__) + ")"
	#IFDEF __FB_UNIX__
		PRINT
	#ENDIF

ELSEIF sCommand = "-b" THEN

	header()
	PRINT "files to analyse: .bas, .bi, .vb"
	PRINT
	walkDir("", sCommand)
	displayTotals()

ELSEIF sCommand = "-c" THEN

	header()
	PRINT "files to analyse: .c, .cpp, .h"
	PRINT
	walkDir("", sCommand)
	displayTotals()

ELSEIF sCommand = "-w" THEN

	header()
	PRINT "files to analyse: .html/.htm, .css, .php, .inc, .tpl, .js, .sql"
	PRINT
	walkDir("", sCommand)
	displayTotals()

ELSE

	header()
	PRINT "Usage:"
	PRINT TAB(9); "codecounter  -b  |  -c  |  -w"
	PRINT
	PRINT TAB(23); "bas    C      web"
	PRINT

END IF


' end
' ------------------------------------------------