$package_system = ["epel-release", "cyrus-sasl", "cyrus-sasl-plain"]
$package_services = ["cockpit", "postfix", "dovecot", "pdns",
                     "pdns-recursor", "httpd", "php-fpm.x86_64",
                     "mysql", "mysql-server"]
$package_utils = ["vim", "bash-completion", "telnet", "nc", "bind-utils"]


package { $package_system:
   ensure => 'installed',
}

package { $package_services:
   ensure => 'installed',
}

package { $package_utils:
   ensure => 'installed',
}

