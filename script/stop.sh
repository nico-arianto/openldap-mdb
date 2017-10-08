#!/bin/bash

kill $(cat /var/run/openldap/slapd.pid)
