#!/bin/sh
sudo setpci -s 00:02.0 F4.B="$@"
