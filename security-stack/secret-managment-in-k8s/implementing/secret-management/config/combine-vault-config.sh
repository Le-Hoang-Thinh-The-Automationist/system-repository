#!/bin/bash

cat ./module/default-config.hcl \
    ./module/listener.hcl \
    ./module/storage.hcl \
    ./module/telemetry.hcl \
    > vault.hcl