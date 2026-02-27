#!/bin/bash

source ./common.sh

check_root
app_name="user"
app_setup

Nodejs_setup

Service_file
System_ctl
Print_total_time
