
$package_php = ['php-ldap', 'php-imagick', 'php-common', 'php-gd', 'php-imap', 'php-json', 'php-curl', 'php-zip', 'php-xml', 'php-mbstring', 'php-bz2', 'php-intl', 'php-gmp']


package { "https://rpms.remirepo.net/enterprise/remi-release-8.rpm":
    ensure   => 'present',
}

exec { 'module reset php':
    command  => '/usr/bin/dnf -y module reset php',
}

exec { 'module enable eset php':
    command  => '/usr/bin/dnf -y module enable php:remi-7.4',
}


package { $package_php:
    ensure   => 'installed',
}


