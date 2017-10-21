FROM amazonlinux:latest

LABEL maintainer="Nico Arianto <nico.arianto@gmail.com>"

ENV DEBUG_LEVEL=32768

COPY ldif /tmp/ldap/
COPY script /etc/openldap/bin

# OpenLDAP installation
RUN yum -y update && \
    yum -y install openldap-servers openldap-clients && \

# Configuring slapd
    rm /etc/openldap/slapd.d/cn\=config/olcDatabase\={2}bdb.ldif && \
    service slapd start && \
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/ldap/config.ldif && \
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/ldap/database_mdb.ldif && \
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/ldap/database_monitor.ldif && \
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/ldap/database_config.ldif && \
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/ldap/module.ldif && \
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/ldap/overlay_memberof.ldif && \
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/ldap/overlay_refint.ldif && \
    service slapd stop && \

# Setup the execution files
    chmod +x /etc/openldap/bin/*.sh

VOLUME /var/lib/ldap /etc/openldap/certs

EXPOSE 389 636

WORKDIR /etc/openldap/

CMD ./bin/start.sh
