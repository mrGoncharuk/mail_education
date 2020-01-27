#!/bin/bash

# Setting up inet_interfaces to all(listening all addresses)
sed -i 's/^\(inet_interfaces\s*=\s*\).*$/\1all/' /etc/postfix/main.cf

# Enabling sasl authentication
sed -i "\$a# Custom added options\nsmtpd_sasl_auth_enable = yes" /etc/postfix/main.cf

# Setting up mbox path
sed -i "/mail_location\ =\ mbox:~\/mail:INBOX=\/var\/mail\/%u/s/^#//" /etc/dovecot/conf.d/10-mail.conf 

# Removing manager from alias list
sed -i '/^manager/d' /etc/aliases && newaliases
