#!/usr/bin/env bash

set -euo pipefail

_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${_SCRIPT_DIR}/common.sh"

PACKAGE_CONFIG_FILE="${DOTFILES_DIR}/config/packages.conf"

detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        if [[ -n "$ID" ]]; then
            if [[ "$ID" == "debian" ]]; then
                echo "ubuntu"
            else
                echo "$ID"
            fi
            return
        fi
    fi
    echo "unknown"
}

main() {
    local current_distro
    current_distro=$(detect_distro)
    local system_packages_installed_successfully=true

    if [[ "$current_distro" == "unknown" ]]; then
        log_error "Unknown distribution. Cannot install system packages."
        system_packages_installed_successfully=false
    elif [[ ! -f "$PACKAGE_CONFIG_FILE" ]]; then
        log_error "Package config file not found: $PACKAGE_CONFIG_FILE."
        system_packages_installed_successfully=false
    else
        local packages_to_install_list=()
        local current_section_tag=""

        while IFS= read -r line || [[ -n "$line" ]]; do
            if [[ "$line" =~ ^\s*# ]] || [[ -z "$line" ]]; then
                continue
            fi

            if [[ "$line" =~ ^\[([a-zA-Z0-9,_]+)\]$ ]]; then
                current_section_tag="${BASH_REMATCH[1]}"
                continue
            fi

            if [[ -n "$current_section_tag" ]]; then
                if [[ "$current_section_tag" == "common" ]]; then
                    if [[ "$line" != "docker" && "$line" != "docker-compose-plugin" ]]; then
                        packages_to_install_list+=("$line")
                    fi
                    continue
                fi

                local match=false
                IFS=',' read -r -a section_distros <<< "$current_section_tag"
                for section_distro_item in "${section_distros[@]}"; do
                    if [[ "$section_distro_item" == "$current_distro" ]]; then
                        match=true; break
                    fi
                    if [[ "$section_distro_item" == "debian" && "$current_distro" == "ubuntu" ]]; then
                        match=true; break
                    fi
                done

                if $match; then
                    packages_to_install_list+=("$line")
                fi
            fi
        done < "$PACKAGE_CONFIG_FILE"

        local unique_packages
        unique_packages=$(echo "${packages_to_install_list[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

        if [[ -n "$unique_packages" ]]; then
            echo "[packages.sh] Attempting to install for $current_distro: $unique_packages"
            case "$current_distro" in
                "arch")
                    if ! sudo pacman -Syu --noconfirm --needed $unique_packages &> /dev/null; then
                        system_packages_installed_successfully=false
                    fi
                    ;;
                "fedora")
                    if ! sudo dnf install -y $unique_packages &> /dev/null; then
                        system_packages_installed_successfully=false
                    fi
                    ;;
                "ubuntu")
                    sudo apt update &> /dev/null
                    if ! sudo apt install -y $unique_packages &> /dev/null; then
                        system_packages_installed_successfully=false
                    fi
                    ;;
                *)
                    system_packages_installed_successfully=false
                    ;;
            esac
        else
             true
        fi
    fi

    if ! bash "${_SCRIPT_DIR}/tools.sh"; then
        system_packages_installed_successfully=false
    fi

    if [[ "$system_packages_installed_successfully" = true ]]; then
        return 0
    else
        return 1
    fi
}

main