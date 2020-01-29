#!/bin/bash

# Setting up inet_interfaces to all(listening all addresses)
sed -i 's/^\(inet_interfaces\s*=\s*\).*$/\1all/' /etc/postfix/main.cf

# Enabling sasl authentication
sed -i "\$a# Custom added options\nsmtpd_sasl_auth_enable = yes" /etc/postfix/main.cf

# Setting up mbox path
sed -i "/mail_location\ =\ mbox:~\/mail:INBOX=\/var\/mail\/%u/s/^#//" /etc/dovecot/conf.d/10-mail.conf 

# Removing manager from alias list
sed -i '/^manager/d' /etc/aliases && newaliases

# Uncomment local-port at pdns-recursor config file
sed -i '/local-port=/s/^# //' /etc/pdns-recursor/recursor.conf 

# Uncomment local-port at pdns config file and changing port value to 54
sed -i '/local-port=/s/^# //' /etc/pdns/pdns.conf 
sed -i 's/^\(local-port\s*=\s*\).*$/\154/' /etc/pdns/pdns.conf

# Creating custom named config and adding path to him to recursor.conf
cp /vagrant/config_files/named.conf /etc/pdns
sed -i "\$abind-config=/etc/pdns/named.conf" /etc/pdns/pdns.conf

# Creating directory for zone file and copying it to his directory
mkdir -p /var/lib/pdns
cp /vagrant/config_files/youdidnotevenimaginethisdomainexists.com.db /var/lib/pdns

# Configuring forward-zones
sed -i '/forward-zones=/s/^# //' /etc/pdns-recursor/recursor.conf 
sed -i 's/^\(forward-zones\s*=\s*\).*$/\1youdidnotevenimaginethisdomainexists.com=127.0.0.1:54/' /etc/pdns-recursor/recursor.conf