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
# ============================================================================================================
# MAIN
# ============================================================================================================
# =[ Handle Script Arguments ]================================================================================
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
		echo -e "${B0} * ${BU}Binary file path set at:${E} ${G0}${BIN_PATH}${E}"
	fi
fi
# =[ Build folder and files ]=================================================================================

# =[ Run tests ]==============================================================================================