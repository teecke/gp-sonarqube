#!/bin/bash

# @description Run bash linter
#
# @example
#   run-bash-linter
#
# @arg $1 Task: "brief", "help" or "exec"
#
# @exitcode The result of the shellckeck
#
# @stdout "Not implemented" message if the requested task is not implemented
#
function run-bash-linter() {

    # Init
    local briefMessage
    local helpMessage

    briefMessage="Install assets"
    helpMessage=$(cat <<EOF
Install SonarQube assets. It will create the following directories with all permissions (777)

* data/conf
* data/data
* data/extensions
* data/bundled-plugins

EOF
)

    # Task choosing
    case $1 in
        brief)
            showBriefMessage "${FUNCNAME[0]}" "$briefMessage"
            ;;
        help)
            showHelpMessage "${FUNCNAME[0]}" "$helpMessage"
            ;;
        exec)
            for directory in data data/conf data/data data/extensions data/bundled-plugins; do
                if [ ! -d ${directory} ]; then
                    echo -n "- Creating '${directory}' directory..."
                    mkdir ${directory}
                    echo "[OK]"
                    echo -n "- Setting '${directory}' permissions..."
                    chmod 777 ${directory}
                    echo "[OK]"
                else
                    echo "The '${directory}' directory already exists, skipping"
                fi
            done
            ;;
        *)
            showNotImplemtedMessage "$1" "${FUNCNAME[0]}"
            return 1
    esac
}

# Main
run-bash-linter "$@"
