# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include mailplatform::installpackages::rc_php
class mailplatform::installpackages::rc_php {
  $package_php = ['php-ldap', 'php-imagick', 'php-mysql','php-common',
  'php-gd', 'php-imap', 'php-json', 'php-curl', 'php-zip', 'php-xml',
  'php-mbstring', 'php-bz2', 'php-intl', 'php-gmp']
  #include 'archive' # NOTE: optional for posix platforms
  # Creating RoundCube folder
  file { '/var/www':
    ensure  => 'directory',
  }
  file { 'Create Roundcube folder and applying SE Linux permissions':
    ensure  => 'directory',
    path    => '/var/www/roundcube',
    recurse => true,
    seltype => 'httpd_sys_content_t',
    require => File['/var/www']
  }

  # Downloading and extracting RoundCube archive to /var/www/roundcube
  archive { '/var/www/roundcubemail-1.4.2-complete.tar.gz':
    source          => 'https://github.com/roundcube/roundcubemail/releases/download/1.4.2/roundcubemail-1.4.2-complete.tar.gz',
    extract         => true,
    extract_path    => '/var/www/roundcube',
    extract_command => 'tar -xf %s --strip-components 1',
    creates         => '/var/www/roundcube/bin',
    cleanup         => true
  }

  # Php installing
  package { 'Remi Repo':
    ensure => present,
    source => 'https://rpms.remirepo.net/enterprise/remi-release-8.rpm',
  }
#  exec { 'Remi Repo':
#    command => '/usr/bin/dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm',
#  }

  exec { 'module reset php':
    command => '/usr/bin/dnf -y module reset php',
    require => Package['Remi Repo'],
  }

  exec { 'module enable php':
    command => '/usr/bin/dnf -y module enable php:remi-7.4',
    require => Exec['module reset php'],
  }

  package { $package_php:
    ensure  => 'installed',
    require => Exec['module enable php'],
  }
}
