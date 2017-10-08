#!/bin/bash

slapd -h "ldap:/// ldaps:/// ldapi:///" -u ldap -d $DEBUG_LEVEL
