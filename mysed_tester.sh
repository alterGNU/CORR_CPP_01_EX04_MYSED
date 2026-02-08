#!/usr/bin/env bash

# ============================================================================================================
# Launch mysed tests
# - Usage: ./mysed_tester.sh binary_path "match_pattern" "replace_pattern"
# ============================================================================================================
 
# =[ VARIABLES ]==============================================================================================
# -[ PATH/FOLDER/FILE ]---------------------------------------------------------------------------------------
ARGS=()                                                           # ☒ Copy of arguments pass to the script
for arg in "${@}";do ARGS+=( "${arg}" );done
NB_ARG="${#}"                                                     # ☒ Number of script's arguments
SCRIPTNAME=${0##*\/}                                              # ☒ Script's name (no path)
PARENT_DIR=$(cd $(dirname ${0}) && pwd)                           # ☒ Name of parent directory (TEST_DIR)
MS_DIR=$(cd $(dirname ${PARENT_DIR}) && pwd)                      # ☒ Name of great-parent directory (CUB3D_DIR)
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
	echo -e "${R0}Usage: ./${SCRIPTNAME} <binary_path> <match_pattern> <replace_pattern>${E}"
	exit 1
fi