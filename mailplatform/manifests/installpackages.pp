# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include mailplatform::installpackages
class mailplatform::installpackages {
  include 'archive' # NOTE: optional for posix platforms
  $package_system = ['epel-release', 'cyrus-sasl', 'cyrus-sasl-plain']
  $package_services = ['cockpit', 'postfix', 'dovecot', 'pdns',
  'pdns-recursor', 'httpd', 'php-fpm.x86_64',
  'mysql', 'mysql-server']
  $package_utils = ['vim', 'bash-completion', 'telnet', 'nc', 'bind-utils']

  package { $package_system:
    ensure => 'installed',
  }

  package { $package_services:
    ensure => 'installed',
  }

  package { $package_utils:
    ensure => 'installed',
  }

  # Creating RoundCube folder
  file { '/var/www/roundcube':
    ensure => 'directory',
  }

  # Downloading and extracting RoundCube archive to /var/www
  archive { '/var/www/roundcubemail-1.4.2-complete.tar.gz':
    source          => 'https://github.com/roundcube/roundcubemail/releases/download/1.4.2/roundcubemail-1.4.2-complete.tar.gz',
    extract         => true,
    extract_path    => '/var/www/roundcube',
    extract_command => 'tar -xf %s --strip-components 1',
    creates         => '/var/www/roundcube/bin',
    cleanup         => true
  }

  $package_php = ['php-ldap', 'php-imagick', 'php-mysql','php-common', 'php-gd', 'php-imap', 'php-json', 'php-curl', 'php-zip', 'php-xml',
  'php-mbstring', 'php-bz2', 'php-intl', 'php-gmp']

  exec { 'Remi Repo':
    command => '/usr/bin/dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm',
  }

  exec { 'module reset php':
    command => '/usr/bin/dnf -y module reset php',
    require => Exec['Remi Repo'],
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
