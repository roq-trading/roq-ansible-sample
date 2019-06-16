#!/usr/bin/env bash

set -e

# variables
NAME="server-{{ item }}"

# activate the conda environment
source "{{ root }}/miniconda/bin/activate" ""

# verbosity (logging)
export ROQ_v="{{ config.logging.verbosity | default(0) }}"

# launch the application
"$CONDA_PREFIX/bin/roq-ping" \
    --name "$NAME" \
    --dispatcher-affinity {{ 2 * (item | int - 1) + 1 }} \
    --market-data-affinity {{ 2 * (item | int - 1) + 2 }} \
    --metrics "{{ root }}/var/tmp/${NAME}_metrics.sock" \
    --listen "{{ root }}/var/tmp/$NAME.sock" \
    $@
