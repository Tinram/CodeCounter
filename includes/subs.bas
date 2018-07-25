
'-----------------------------------------------------------------------------------
'
' subs.bas
'
' Purpose:      Subroutines for codecounter.bas
' Copyright:    Martin Latter, November 2011.
' Credit:       Richard D. Clark (rdc): walkDir() recursive function.
' Version:      1.12
' License:      GNU GPL version 3.0 (GPL v3); http://www.gnu.org/licenses/gpl.html
' URL:          https://github.com/Tinram/CodeCounter.git
'
'-----------------------------------------------------------------------------------


SUB header()

	' subroutine to keep this info out of -v option

	PRINT
	PRINT "Code Counter"
	PRINT "by Tinram"
	PRINT

END SUB


SUB walkDir(BYVAL sFolder AS STRING, BYREF sC AS STRING, BYREF sC2 AS STRING)

	' subroutine to recurse directories, reading files and incrementing totals
	' directory recursion by Richard D. Clark (rdc)

	DIM AS STRING sCommand = sC, sSuppress = sC2, sSingleComment1, sSingleComment2, sSingleComment3, sMultiLineStart1, sMultiLineFinish1, sMultiLineStart2, sMultiLineFinish2, sFileName, sDirList(), sLineContent, sFMask = "*.*", sFileSeparator = "--------------------------------"
	DIM AS UINTEGER iOutAttr, iDirCount, iLen = 2, iSpecifiedFile = 0, iFileLineCount = 0, iFileComments = 0, iMultiLineComments = 0, iSingleComment1Len, iSingleComment2Len, iSingleComment3Len, iMultiLineStart1Len, iMultiLineFinish1Len, iMultiLineStart2Len, iMultiLineFinish2Len
		' iLen: for BASIC and C, sC: local copy from reference: avoid lookup
	DIM AS INTEGER hFile = FreeFile, i ' i mustn't be a UINT
	DIM AS STRING PTR pFT ' array filetypes pointer


	' config -----------------------------------------------------------
	' also see @filenames

	DIM AS STRING aFileTypesBasic(0 TO 2) = {".bas", ".bi", ".vb"}
	DIM AS STRING aFiletypesC(0 TO 2) = {".h", ".c", ".cpp"}
	DIM AS STRING aFileTypesWeb(0 TO 7) = {".html", ".htm", ".css", ".php", ".inc", ".tpl", ".js", ".sql"}

	IF sCommand = "-b" THEN

		pFT = @aFileTypesBasic(0)

		sSingleComment1 = "'"
		sSingleComment2 = "REM"
		sSingleComment3 = "~~" ' dummy filler for FB
		sMultiLineStart1 = "/'"
		sMultiLineFinish1 = "'/"
		sMultiLineStart2 = "~~"
		sMultiLineFinish2 = "~~"

	ELSEIF sCommand = "-c" THEN

		pFT = @aFiletypesC(0)

		sSingleComment1 = "//"
		sSingleComment2 = "~~"
		sSingleComment3 = "~~"
		sMultiLineStart1 = "/*"
		sMultiLineFinish1 = "*/"
		sMultiLineStart2 = "~~"
		sMultiLineFinish2 = "~~"

	ELSEIF sCommand = "-w" THEN

		pFT = @aFileTypesWeb(0)
		iLen = 7

		sSingleComment1 = "#"
		sSingleComment2 = "//"
		sSingleComment3 = "--"
		sMultiLineStart1 = "/*"
		sMultiLineFinish1 = "*/"
		sMultiLineStart2 = "<!--"
		sMultiLineFinish2 = "-->"

	END IF

	' -------------------------------------------------------------------

	iSingleComment1Len = LEN(sSingleComment1)
	iSingleComment2Len = LEN(sSingleComment2)
	iSingleComment3Len = LEN(sSingleComment3)
	iMultiLineStart1Len = LEN(sMultiLineStart1)
	iMultiLineFinish1Len = LEN(sMultiLineFinish1)
	iMultiLineStart2Len = LEN(sMultiLineStart2)
	iMultiLineFinish2Len = LEN(sMultiLineFinish2)

	sFileName = DIR(sFolder & sFMask, ATTRIBUTE_MASK, iOutAttr)

	DO UNTIL LEN(sFileName) = 0

		IF (sFileName <> ".") AND (sFileName <> "..") THEN

			IF iOutAttr AND fbDirectory THEN

				iDirCount += 1
				REDIM PRESERVE sDirList(1 TO iDirCount)
				sDirList(iDirCount) = sFolder & sFileName & "/"

			ELSE

				sFileName = sFolder & sFileName ' needed to access sub-directory files
' @filenames
				IF sCommand = "-w" OR sCommand = "-b" THEN

					FOR i = 0 TO iLen

						IF pFT[i] = RIGHT(sFileName, 3) THEN iSpecifiedFile = 1 ' .js, .bi, .vb
						IF pFT[i] = RIGHT(sFileName, 4) THEN iSpecifiedFile = 1 ' .css, .php etc
						IF pFT[i] = RIGHT(sFileName, 5) THEN iSpecifiedFile = 1 ' .html
							'IF INSTR(sFileName, pFT[i]) > 0 THEN iSpecifiedFile = 1 ' no good, since .php.bak is parsed
					NEXT i

				ELSE ' -c

					FOR i = 0 TO iLen

						IF pFT[i] = RIGHT(sFileName, 2) THEN iSpecifiedFile = 1 ' .c, .h
						IF pFT[i] = RIGHT(sFileName, 4) THEN iSpecifiedFile = 1 ' .cpp

					NEXT i

				END IF

				IF iSpecifiedFile = 1 THEN

					IF OPEN(sFileName, FOR INPUT, AS #hFile) = 0 THEN

						IF INSTR(sSuppress, "-s") = 0 THEN
							PRINT sFileSeparator
							PRINT sFileName
						END IF

						WHILE NOT EOF(hFile)

							LINE INPUT #hFile, sLineContent

							sLineContent = UCASE(TRIM(sLineContent, ANY CHR(32, 9)))
								' TRIM() by default only removes spaces; can use quoted raw chars, but ANY CHR() is clearer

							IF LEN(sLineContent) THEN

								IF INSTR(sLineContent, sMultiLineFinish1) > 0 THEN ' has to be first
										' IF LEFT(sLineContent, iMultiLineFinish1Len) = sMultiLineFinish1 THEN ' // only detects on line start
									iFileComments += 1
									iMultiLineComments = 0

								ELSEIF INSTR(sLineContent, sMultiLineFinish2) > 0 THEN

									iFileComments += 1
									iMultiLineComments = 0

								ELSEIF LEFT(sLineContent, iSingleComment1Len) = sSingleComment1 THEN

									iFileComments += 1

								ELSEIF LEFT(sLineContent, iMultiLineStart1Len) = sMultiLineStart1 THEN

									iFileComments += 1
									iMultiLineComments = 1
									IF INSTR(sLineContent, sMultiLineFinish1) > 0 THEN iMultiLineComments = 0 ' * comments on one line

								ELSEIF LEFT(sLineContent, iMultiLineStart2Len) = sMultiLineStart2 THEN

									iFileComments += 1
									iMultiLineComments = 1
									IF INSTR(sLineContent, sMultiLineFinish2) > 0 THEN iMultiLineComments = 0 ' HTML comments on one line

								ELSEIF LEFT(sLineContent, iSingleComment2Len) = sSingleComment2 THEN

									iFileComments += 1

								ELSEIF LEFT(sLineContent, iSingleComment3Len) = sSingleComment3 THEN

									iFileComments += 1

								ELSE

									IF iMultiLineComments = 1 THEN
										iFileComments += 1
									ELSE
										iFileLineCount += 1
									END IF

								END IF

							END IF

						WEND

						CLOSE #hFile

					END IF

					IF INSTR(sSuppress, "-s") = 0 THEN
						PRINT "comment lines: " & iFileComments
						PRINT "code lines: " & iFileLineCount
						PRINT sFileSeparator
					END IF

					iTotalComments += iFileComments
					iTotalCodeLines += iFileLineCount
					iTotalFiles += 1

					iFileComments = 0
					iFileLineCount = 0
					iSpecifiedFile = 0

				END IF

			END IF

		END IF

		sFileName = Dir(iOutAttr)

	LOOP

	FOR i = 1 TO UBOUND(sDirList)
		walkDir(sDirList(i), sCommand, sSuppress)
	NEXT i

END SUB


SUB displayTotals()

	' subroutine to display accumulated totals

	DIM AS STRING sTotalsSeparator = "________________________________"

	PRINT
	PRINT sTotalsSeparator
	PRINT
	PRINT "files analysed: " & iTotalFiles
	PRINT "total comment lines: " & iTotalComments
	PRINT "total code lines: " & iTotalCodeLines
	PRINT "total non-blank lines: " & (iTotalComments + iTotalCodeLines)
	PRINT sTotalsSeparator
	PRINT

END SUB
