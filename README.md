# OpenLDAP

This docker base image was being build from Amazonlinux [2017.09.0.20170930](https://hub.docker.com/_/amazonlinux/) and use YUM repository to install OpenLDAP [2.4.40](http://www.openldap.org/software/download/) while override the default database (default: _hdb_) to _LMDB_.

## How to start

Execute a command below to start the Docker container as LDAP server:
```bash
docker run -d --rm -p 389:389 -p 636:636 --name openldap nico0arianto/openldap-mdb
```

There are two options by mount an external directories to the Docker container:

* Stores the database in local machine:
```bash
docker run -d --rm -v /home/ldap/db:/var/lib/ldap -p 389:389 -p 636:636 --name openldap nico0arianto/openldap-mdb
```

* Include the certificate files into the Docker container:
```bash
docker run -d --rm -v /home/ldap/certs:/etc/openldap/certs -p 389:389 -p 636:636 --name openldap nico0arianto/openldap-mdb
```

## Structure

There are few things that been defaulted in the configuration, LMBD and database monitor.

### Configuration

Password: **changeit**

### LMDB

Suffix: **dc=example,dc=com**
Root DN: **cn=Manager,dc=example,dc=com**
Password: **changeit**

### Monitor

Access: Full access by **cn=Manager,dc=example,dc=com**

## Enabled LDAPS

To enable the LDAPS, will need to modify the config to set the certification files.

Here is the example of LDIF file:
```ldif
# Replace the TLS Server Configuration
dn: cn=config
changetype: modify
replace: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: {{ TLS_CERTIFICATE_KEY_FILE }}
-
replace: olcTLSCertificateFile
olcTLSCertificateFile: {{ TLS_CERTIFICATE_FILE }}
-
replace: olcTLSCACertificateFile
olcTLSCACertificateFile: {{ TLS_CA_CERTIFICATE_FILE }}
```
(**Note:** Do replaced the {{ TLS_... }} above with the correct values)

Please do read this documentation [Using TLS](http://www.openldap.org/doc/admin24/tls.html) to know more details.

**Important:** By default the start script (refer to _start.sh_) did bind the _ldaps_.

## How to start a simple member organization

Mostly, to start using the LDAP server, it will required a basic structure of the organization and member of the organization itself.

Here are few LDIF samples to create a simple organization:

* Creates a domain.
```ldif
dn: dc=example,dc=com
objectclass: domain
dc: example
```

* Creates an organization.
```ldif
dn: ou=Group,dc=example,dc=com
objectclass: organizationalUnit
ou: Group

dn: ou=People,dc=example,dc=com
objectclass: organizationalUnit
ou: People
```

* Creates a person and register as a member of people.
```ldif
dn: cn=nico,ou=People,dc=example,dc=com
objectclass: person
cn: nico
sn: arianto

dn: cn=data,ou=Group,dc=example,dc=com
objectclass: groupOfNames
objectclass: top
cn: data
member: cn=nico,ou=People,dc=example,dc=com
```

## Info

Please do execute the LDIF scripts above with [ldapmodify, ldapadd](http://www.openldap.org/software/man.cgi?query=ldapmodify&apropos=0&sektion=0&manpath=OpenLDAP+2.4-Release&format=html) or similar tools after we can connect to running Docker container (e.g. _openldap_) with a command below:
```bash
docker exec -it openldap bash
```
