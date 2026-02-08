#!/usr/bin/env bash

# ============================================================================================================
# Launch mysed tests
# - Usage: ./mysed_tester.sh binary_filename "match_pattern" "replace_pattern"
# ============================================================================================================
 
# =[ VARIABLES ]==============================================================================================
# -[ PATH/FOLDER/FILE ]---------------------------------------------------------------------------------------
ARGS=()                                                           # ☒ Copy of arguments pass to the script
for arg in "${@}";do ARGS+=( "${arg}" );done
NB_ARG="${#}"                                                     # ☒ Number of script's arguments
SCRIPTNAME=${0##*\/}                                              # ☒ Script's name (no path)
PARENT_DIR=$(cd $(dirname ${0}) && pwd)                           # ☒ Name of parent directory
GP_DIR=$(cd $(dirname ${PARENT_DIR}) && pwd)                      # ☒ Name of great-parent directory
# -[ LAYOUT ]-------------------------------------------------------------------------------------------------
LEN=100                                                            # ☑ Width of the box
# -[ COLORS ]-------------------------------------------------------------------------------------------------
E="\033[0m"                                                        # ☒ END color balise
N0="\033[0;30m"                                                    # ☒ START BLACK
R0="\033[0;31m"                                                    # ☒ START RED
RU="\033[4;31m"                                                    # ☒ START RED UNDERSCORED
V0="\033[0;32m"                                                    # ☒ START GREEN
M0="\033[0;33m"                                                    # ☒ START BROWN
Y0="\033[0;93m"                                                    # ☒ START YELLOW
YU="\033[4;93m"                                                    # ☒ START YELLOW UNDERSCORED
B0="\033[0;34m"                                                    # ☒ START BLUE
BU="\033[4;34m"                                                    # ☒ START BLUE
BC0="\033[0;36m"                                                   # ☒ START AZURE
BCU="\033[4;36m"                                                   # ☒ START AZURE UNDERSCORED
P0="\033[0;35m"                                                    # ☒ START PINK
G0="\033[2;37m"                                                    # ☒ START GREY
GU="\033[4;37m"                                                    # ☒ START GREY
CT="\033[97;100m"                                                  # ☒ START TITLE
# =[ FUNCTIONS ]==============================================================================================
# -[ PRINT_RELATIF_PATH() ]-----------------------------------------------------------------------------------
# substract pwd from arg1 abs-path given
print_shorter_path() { echo "${1/${PWD}/.}" ; }
# -[ PRINT_TITLE() ]-----------------------------------------------------------------------------------------
title()
{
	[[ -n "${1}" ]] && { TITLE="${1}" ; } || { TITLE="TITLE" ; }
	echo -e "\n${CT} ${TITLE} ${E}"
}	
# -[ CREATE_TEST_FILE() ]------------------------------------------------------------------------------------
# Create a file if not already exist, and add it to the list array
create_file_add_to_list()
{
	if [[ -z "${1}" ]]; then
		echo -e "${RU}Error:${R0} create_file_add_to_list function requires as first argument a filename to create${E}"
		return 1
	fi
	if [[ -z "${2}" ]]; then
		echo -e "${RU}Error:${R0} create_file_add_to_list function requires as second argument a list array${E}"
		return 1
	fi
	if ! declare -p "${2}" >/dev/null 2>&1; then
		echo -e "${RU}Error:${R0} list array '${2}' is not declared${E}"
		return 1
	fi
	# Use nameref to append to the array passed by name.
	local -n _list_ref="${2}"
	if [ ! -f "${TEST_DIR}/${1}" ]; then
		touch "${TEST_DIR}/${1}" && echo -e "${V0} * ${GU}Test file '${1}' created.${E}" && _list_ref+=( "${1}" )
	else
		echo -e "${R0} * ${GU}Test file '${1}' already exists.${E}"
	fi
}
# ============================================================================================================
# MAIN
# ============================================================================================================
# =[ Handle Script Arguments ]================================================================================
title "STEP 1: Handle script arguments"
if [ ${NB_ARG} -ne 3 ];then
	echo -e "${RU}Error:${R0} this script requires exactly 3 arguments${E}"
	echo -e "${BU}Usage:${E} ${V0}./${SCRIPTNAME}${E} <${M0}binary_filename${E}> <${M0}match_pattern${E}> <${M0}replace_pattern${E}>"
	exit 1
fi
# =[ Assign arguments to variables ]==========================================================================
[[ -z "${ARGS[0]}" ]] && { echo -e "${RU}Error:${R0} first script argument is binary_filename and can not be empty${E}" && exit 1; }
BIN_PATH=$(find ${GP_DIR} -type f -name "${ARGS[0]}" 2>/dev/null)
if [[ -z "${BIN_PATH}" ]]; then
	echo -e "${RU}Error:${R0} binary file '${Y0}${ARGS[0]}${R0}' not found in ${M0}${GP_DIR}${E}"
	exit 1
else
	if [[ ! -x "${BIN_PATH}" ]]; then
		echo -e "${RU}Error:${R0} file ${Y0}$(print_shorter_path ${BIN_PATH})${R0} is not executable${E}"
		exit 1
	else
		echo -e "${B0} * ${GU}Binary file path set at:${E} ${G0}${BIN_PATH}${E}"
	fi
fi
TEST_DIR="${GP_DIR}/tests"
echo -e "${B0} * ${GU}Test directory path set at:${E} ${G0}${TEST_DIR}${E}"
# =[ Build folder and files ]=================================================================================
title "STEP 2: Build folder and files"
# -[ Create test directory ]----------------------------------------------------------------------------------
if [ ! -d "${TEST_DIR}" ]; then
	mkdir "${TEST_DIR}"
	echo -e "${V0} * ${GU}Test directory created.${E}"
else
	echo -e "${R0} * ${GU}Test directory already exists.${E}"
fi
# -[ Create fails files ]--------------------------------------------------------------------------------------
FAIL_FILE_LIST=( "no_an_existing_file.test" )
# No readable file
create_file_add_to_list "not_readable_file.test" "FAIL_FILE_LIST"
echo "This should not be readable." >> "${TEST_DIR}/not_readable_file.test"
chmod -r "${TEST_DIR}/not_readable_file.test"
# No writable file
create_file_add_to_list "not_writable_file.test" "FAIL_FILE_LIST"
echo "This should be the last writable thing in this file." >> "${TEST_DIR}/not_writable_file.test"
chmod -w "${TEST_DIR}/not_writable_file.test"
# -[ Create success files ]-------------------------------------------------------------------------------------
SUCC_FILE_LIST=( )
# Empty file
create_file_add_to_list "empty_file.test" "SUCC_FILE_LIST"
# ------ ONELINE FILES ------
# oneline no match no end-backslashes
create_file_add_to_list "oneLine_noMatch_noEndBackSlash.test" "SUCC_FILE_LIST"
echo -n "This one line file does not contains any MaTcH and end without backslash." > "${TEST_DIR}/oneLine_noMatch_noEndBackSlash.test"
# oneline no match with end-backslashes
create_file_add_to_list "oneLine_noMatch_endBackSlash.test" "SUCC_FILE_LIST"
echo "This one line file does not contains any MaTcH and end with backslash." > "${TEST_DIR}/oneLine_noMatch_endBackSlash.test"
# oneline one match no end-backslashes
create_file_add_to_list "oneLine_oneMatch_noEndBackSlash.test" "SUCC_FILE_LIST"
echo -n "This one line file does not contains one match and end without backslash." > "${TEST_DIR}/oneLine_oneMatch_noEndBackSlash.test"
# oneline one match with end-backslashes
create_file_add_to_list "oneLine_oneMatch_endBackSlash.test"	"SUCC_FILE_LIST"
echo "This one line file does not contains one match and end without backslash." > "${TEST_DIR}/oneLine_oneMatch_endBackSlash.test"
# only one match no end-backslashes
create_file_add_to_list "oneLine_onlyoneMatch_noEndBackSlash.test" "SUCC_FILE_LIST"
echo -n "match" > "${TEST_DIR}/oneLine_onlyoneMatch_noEndBackSlash.test"
# only one match with end-backslashes
create_file_add_to_list "oneLine_onlyoneMatch_endBackSlash.test" "SUCC_FILE_LIST"
echo "match" > "${TEST_DIR}/oneLine_onlyoneMatch_endBackSlash.test"
# only multiple match no end-backslashes
create_file_add_to_list "oneLine_onlymultiMatch_noEndBackSlash.test" "SUCC_FILE_LIST"
echo -n "matchmatchmatchmatch" > "${TEST_DIR}/oneLine_onlymultiMatch_noEndBackSlash.test"
# only multiple match with end-backslashes
create_file_add_to_list "oneLine_onlymultiMatch_endBackSlash.test" "SUCC_FILE_LIST"
echo "matchmatchmatchmatch" > "${TEST_DIR}/oneLine_onlymultiMatch_endBackSlash.test"
# oneline multiple match no end-backslashes
create_file_add_to_list "oneLine_multiMatch_noEndBackSlash.test" "SUCC_FILE_LIST"
echo -n "First match, double matchmatch, last:match!" > "${TEST_DIR}/oneLine_multiMatch_noEndBackSlash.test"
# oneline multiple match with end-backslashes
create_file_add_to_list "oneLine_multiMatch_endBackSlash.test" "SUCC_FILE_LIST"
echo "First match, double matchmatch, last:match!" > "${TEST_DIR}/oneLine_multiMatch_endBackSlash.test"

# ------ MULTIPLE LINES ------
# Multiple empty lines file
create_file_add_to_list "multiLines_empty.test" "SUCC_FILE_LIST"
echo -e "\n\n\n\n\n" > "${TEST_DIR}/multiLines_empty.test"
# Multiple lines file with no match and no end-backslashes
create_file_add_to_list "multiLines_noMatch_noEndBackslash.test" "SUCC_FILE_LIST"
echo -en "\nThis is a line\n\nThis is another line\n\nThis is the last line" > "${TEST_DIR}/multiLines_noMatch_noEndBackslash.test"
# Multiple lines file with no match and with end-backslashes
create_file_add_to_list "multiLines_noMatch_noEndBackslash.test" "SUCC_FILE_LIST"
echo -e "\nThis is a line\n\nThis is another line\n\nThis is the last line" > "${TEST_DIR}/multiLines_noMatch_noEndBackslash.test"
# Multiple lines only matches and no end-backslashes
create_file_add_to_list "multiLines_onlyMatches_noEndBackslash.test" "SUCC_FILE_LIST"
echo -en "match\nmatchmatch\nmatchmatchmatch\nmatchmatch\nmatch" > "${TEST_DIR}/multiLines_onlyMatches_noEndBackslash.test"
# Multiple lines only matches and with end-backslashes
create_file_add_to_list "multiLines_onlyMatches_withEndBackslash.test" "SUCC_FILE_LIST"
echo -e "match\nmatchmatch\nmatchmatchmatch\nmatchmatch\nmatch" > "${TEST_DIR}/multiLines_onlyMatches_withEndBackslash.test"
# Multiple lines file with muliple matches and no end-backslashes
create_file_add_to_list "multiLines_noMatch_noEndBackslash.test" "SUCC_FILE_LIST"
echo -en "match\nThis is a line without any MatChes\nmatchmatchmatch\nmatchThis is anmatchother linematch\n\nmatch" > "${TEST_DIR}/multiLines_noMatch_noEndBackslash.test"
# Multiple lines file with muliple matches and with end-backslashes
create_file_add_to_list "multiLines_noMatch_withEndBackslash.test" "SUCC_FILE_LIST"
echo -e "match\nThis is a line without any MatChes\nMatchmAtchmaTch\nmatChThis is anmatChother linematcH\n\nMatcH" > "${TEST_DIR}/multiLines_noMatch_withEndBackslash.test"

#echo THIS IS MY FAIL FILES:
#for file in "${FAIL_FILE_LIST[@]}"; do
#	echo -e " - ${R0}${file}${E}"
#done
#echo THIS IS MY SUCCESS FILES:
#for file in "${SUCC_FILE_LIST[@]}"; do
#	echo -e " - ${V0}${file}${E}"
#	echo -e "${G0}Content of ${file}:-------------------------------${E}"
#	cat "${TEST_DIR}/${file}"
#	echo -e "${G0}--------------------------------------------------${E}"
#done
# =[ Run tests ]==============================================================================================
title "STEP 3: Run tests"