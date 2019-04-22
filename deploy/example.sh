#!/bin/bash

#####################################################

# Required
container_name=example
path_to_workspace=/home/${container_name}
root_password=webide

# Optional
map_http_port=5680
map_sshd_port=5622
map_ext_port=5688

# Extension

#####################################################

# Load Default Options
. default_opt

# Check options
. lib/check_opt

# Call Docker-cli to Run Container
run_ide
