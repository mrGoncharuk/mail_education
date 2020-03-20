
$package_php = ['php-ldap', 'php-imagick', 'php-mysql','php-common', 'php-gd', 'php-imap', 'php-json', 'php-curl', 'php-zip', 'php-xml', 'php-mbstring', 'php-bz2', 'php-intl', 'php-gmp']


#package { "Remi Repo":
#    provider => 'rpm',
#    ensure   => installed,
#    source => 'https://rpms.remirepo.net/enterprise/remi-release-8.rpm',
#}

exec { 'Remi Repo':
    command => '/usr/bin/dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm',
}

exec { 'module reset php':
    command  => '/usr/bin/dnf -y module reset php',
    require  => Exec['Remi Repo'],
}

exec { 'module enable php':
    command  => '/usr/bin/dnf -y module enable php:remi-7.4',
    require  => Exec['module reset php'],
}


package { $package_php:
    ensure   => 'installed',
    require => Exec['module enable php'],
}
