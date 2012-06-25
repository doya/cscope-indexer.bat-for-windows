@rem ###########################################################################
@rem #                    cscope-indexer.bat for windows                       #
@rem #                                                                         #
@rem # Author                                                                  #
@rem #  Jeongdo Son <sohn9086@gmail.com>                                       #
@rem #                                                                         #
@rem # Description                                                             #
@rem #  This is a Windows version of cscope-indexer.sh.                        #
@rem #  It just works on Windows without any other external *nix tools such    #
@rem #  as bash or grep or etc.                                                #
@rem #  When you're forced to work on Windows and still work with Emacs and    #
@rem #  cscope, this software might be helpful. Cheers!                        #
@rem #                                                                         #
@rem # License                                                                 #
@rem #  GPL                                                                    #
@rem #                                                                         #
@rem # Known problems                                                          #
@rem #  - The full path of the source files shouldn't contain multi-byte       #
@rem #    characters.                                                          #
@rem #                                                                         #
@rem # Last modified                                                           #
@rem #  2012/06/25                                                             #
@rem #                                                                         #
@rem ###########################################################################

@echo off

setlocal
set LIST_ONLY=0
set DIR=.
set LIST_FILE=cscope.files
set DATABASE_FILE=cscope.out
set RECURSE=
set VERBOSE=0
set SEARCH_FILES=*.c *.cc *.h *.s *.cpp *.cfg


@rem ###################################################
@rem #                  PARSE PARAMS                   #
@rem ###################################################

:LOOPSTART
if "%1" == "" goto START_INDEX
if "%1" == "-f" goto DO_DATABASE_FILE
if "%1" == "-i" goto DO_LIST_FILE
if "%1" == "-l" goto DO_LIST_ONLY
if "%1" == "-r" goto DO_RECURSE
if "%1" == "-v" goto DO_VERBOSE
goto DO_DIR

:DO_DATABASE_FILE
if "%2" == "" goto END_NG
set DATABASE_FILE=%2
shift
shift
goto LOOPSTART

:DO_LIST_FILE
if "%2" == "" goto END_NG
set LIST_FILE=%2
shift
shift
goto LOOPSTART

:DO_LIST_ONLY
set LIST_ONLY=1
shift
goto LOOPSTART

:DO_RECURSE
set RECURSE=/S
shift
goto LOOPSTART

:DO_VERBOSE
REM         This option is ignored
set VERBOSE=1
shift
goto LOOPSTART

:DO_DIR
set DIR=%1
shift
goto LOOPSTART

@rem ###################################################
@rem #                   INDEXING                      #
@rem ###################################################
:START_INDEX
cd %DIR%
if "%VERBOSE%" == "0" goto SKIP_STARTMSG
echo "Creating list of files to index ..."
:SKIP_STARTMSG
dir /B %RECURSE% %SEARCH_FILES% > %LIST_FILE%
if "%VERBOSE%" == "0" goto SKIP_ENDMSG
echo "Creating list of files to index ... done"
:SKIP_ENDMSG

@rem ###################################################
@rem #                   BUILDING                      #
@rem ###################################################

if "%LIST_ONLY%" == "1" goto SKIP_BUILD
if "%VERBOSE%" == "0" goto SKIP_START_BUILD_MSG
echo "Indexing files ..."
:SKIP_START_BUILD_MSG
cscope -b -i %LIST_FILE% -f %DATABASE_FILE%
if "%VERBOSE%" == "0" goto SKIP_END_BUILD_MSG
echo "Indexing files ... done"
:SKIP_END_BUILD_MSG
goto END_OK

@rem ###################################################
@rem #                      EXIT                       #
@rem ###################################################
:END_OK
:SKIP_BUILD
exit

:END_NG
@rem exit
exit
