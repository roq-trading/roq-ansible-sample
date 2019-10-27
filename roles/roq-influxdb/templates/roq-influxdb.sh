#!/usr/bin/env bash

set -e

ARGS="${@:-"--flagfile={{ root }}/etc/roq/roq-influxdb.gflags"}"

"{{ root }}/miniconda/bin/roq-influxdb" "$ARGS" \
{% if 'roq_simulator' in groups %}
  "{{ root }}/var/tmp/roq-simulator.roq" \
{% endif %}
{% if 'roq_deribit' in groups %}
  "{{ root }}/var/tmp/roq-deribit.roq" \
{% endif %}
{% if 'roq_coinbase_pro' in groups %}
  "{{ root }}/var/tmp/roq-coinbase-pro.roq"
{% endif %}