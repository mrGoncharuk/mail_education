
# Setting up inet_interfaces to all(listening all addresses)

file_line {'Setting up inet_interfaces to all':
  path  => '/etc/postfix/main.cf',
  line  => "inet_interfaces = all",
  match => "inet_interfaces = localhost",
}

file_line {'Enabling sasl authentication':
  path  => '/etc/postfix/main.cf',
  line  => "\n# Custom added options\nsmtpd_sasl_auth_enable = yes",
}

file_line {'Setting up mbox path':
  path  => '/etc/dovecot/conf.d/10-mail.conf',
  line  => 'mail_location = mbox:~/mail:INBOX=/var/mail/%u',
  match => '#   mail_location = mbox:~/mail:INBOX=/var/mail/%u',
}

file_line { 'removing manager from alias list':
  ensure => absent,
  path => '/etc/aliases',
  match => 'manager',
  match_for_absence => true,
}

file_line {' Uncomment local-port 53 at pdns-recursor config file':
  path  => '/etc/pdns-recursor/recursor.conf',
  line  => 'local-port=53',
  match => '# local-port=53',
}

file_line {'Uncomment local-port at pdns config file and changing port value to 54':
  path  => '/etc/pdns/pdns.conf',
  line  => 'local-port=54',
  match => '# local-port=53',
}

# Creating custom named.conf and adding path to him to pdns.conf
file { '/etc/pdns/named.conf':
  source => '/vagrant/config_files/named.conf'
}
file_line {' adding path to named.conf to pdns config':
  path  => '/etc/pdns/pdns.conf',
  line  => 'bind-config=/etc/pdns/named.conf',
}

# Creating directory for zone file and copying it to his directory
file{"/var/lib/pdns":
    ensure  =>  directory,
}
file{"/var/lib/pdns/youdidnotevenimaginethisdomainexists.com.db":
    ensure  =>  file,
    content =>  template("/vagrant/config_files/youdidnotevenimaginethisdomainexists.com.db"),
    require => File["/var/lib/pdns"],
}

# Configuring forward-zones
file_line {'Configuring forward-zones':
  path  => '/etc/pdns-recursor/recursor.conf',
  line  => 'forward-zones=youdidnotevenimaginethisdomainexists.com=127.0.0.1:54',
  match => "# forward-zones=",

}

# Setting up Timezone for PHP
file_line {'Setting up Timezone for PHP':
  path  => '/etc/php.ini',
  line  => "date.timezone = 'UTC'",
  match => ";date.timezone =",
}

exec { "change mod to user's mailhome folders":
    command => "/usr/bin/chmod 0600 /var/mail/*"
}

# Hint taken from https://ask.puppet.com/question/27007/how-to-recursively-chmod-files-in-directory/
file {'Ensure proper permissions for mail location':
  path => '/var/mail',
  recurse => true,
  recurselimit => 1,
  ensure => directory,
  mode => '0600',
}

# From https://puppet.com/docs/puppet/5.5/types/exec.html#exec-attribute-refreshonly
# Rebuild the database, but only when the file changes
exec { newaliases:
  path        => ['/usr/bin', '/usr/sbin'],
  subscribe   => File_line['removing manager from alias list'],
  refreshonly => true,
}
