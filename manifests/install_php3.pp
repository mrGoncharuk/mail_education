
$package_php = ['php-ldap', 'php-imagick', 'php-common', 'php-gd', 'php-imap', 'php-json', 'php-curl', 'php-zip', 'php-xml', 'php-mbstring', 'php-bz2', 'php-intl', 'php-gmp']


package { "https://rpms.remirepo.net/enterprise/remi-release-8.rpm":
    ensure   => 'present',
}

#package { 'module reset php':
 #   ensure   => 'present',
#}

yumrepo { "php:remi-7.4":
    enabled  => true,
}


package { $package_php:
    ensure   => 'installed',
}


