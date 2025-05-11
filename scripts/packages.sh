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
    local overall_system_package_success=true

    if [[ "$current_distro" == "unknown" ]]; then
        log_error "Unknown distribution. Cannot install system packages."
        overall_system_package_success=false
    elif [[ ! -f "$PACKAGE_CONFIG_FILE" ]]; then
        log_error "Package config file not found: $PACKAGE_CONFIG_FILE."
        overall_system_package_success=false
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

        read -r -a unique_packages_array <<< "$(echo "${packages_to_install_list[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')"


        if [[ ${#unique_packages_array[@]} -gt 0 ]]; then
            echo
            echo "[packages.sh] Attempting to install for $current_distro: ${unique_packages_array[*]}"

            if [[ "$current_distro" == "ubuntu" ]]; then
                if ! sudo apt update; then
                    log_error "apt update failed."
                    overall_system_package_success=false
                fi
            fi

            for pkg in "${unique_packages_array[@]}"; do
                if [[ -z "$pkg" ]]; then
                    continue
                fi
                local individual_install_success=true
                case "$current_distro" in
                    "arch")
                        if ! sudo pacman -S --noconfirm --needed "$pkg"; then
                            individual_install_success=false
                        fi
                        ;;
                    "fedora")
                        if ! sudo dnf install -y "$pkg"; then
                            individual_install_success=false
                        fi
                        ;;
                    "ubuntu")
                        if ! sudo apt install -y "$pkg"; then
                            individual_install_success=false
                        fi
                        ;;
                    *)
                        log_warn "[packages.sh] System package installation not implemented for $current_distro for package: $pkg"
                        individual_install_success=false
                        ;;
                esac

                if ! $individual_install_success; then
                    log_error "[packages.sh] Failed to install package: $pkg"
                    overall_system_package_success=false
                fi
            done
            echo
        else
             true
        fi
    fi

    if [[ "$overall_system_package_success" = true ]]; then
        return 0
    else
        return 1
    fi
}

main