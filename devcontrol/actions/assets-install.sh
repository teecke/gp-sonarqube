#!/bin/bash

set -eu

# @description Install item assets
#
# @example
#   assets-install
#
# @arg $1 Task: "brief", "help" or "exec"
#
# @exitcode The result of the assets installation
#
# @stdout "Not implemented" message if the requested task is not implemented
#
function assets-install() {

    # Init
    local briefMessage
    local helpMessage

    briefMessage="Install assets"
    helpMessage=$(cat <<EOF
Install SonarQube assets. It will create the following directories with all permissions (777)

* Create the "data/opt/sonarqube/conf", "data/opt/sonarqube/data", "data/opt/sonarqube/extensions" and "/opt/sonarqube/lib/bundled-plugins" directories with all permissions (777)
* Create the network "platform_services"

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
            # Create network
            if [ "$(docker network ls -f name='platform_products' -q)" == "" ]; then
                echo -n "- Creating docker network 'platform_products' ..."
                docker network create platform_products
                echo "[OK]"
            else
                echo "The 'platform_services' docker network already exists, skipping"
            fi
            # Create directories
            for directory in data data/opt data/opt/sonarqube \
                             data/opt/sonarqube/conf \
                             data/opt/sonarqube/data \
                             data/opt/sonarqube/extensions \
                             data/opt/sonarqube/lib data/opt/sonarqube/lib/bundled-plugins
            do
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
assets-install "$@"
