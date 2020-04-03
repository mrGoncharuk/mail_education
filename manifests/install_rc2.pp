include 'archive' # NOTE: optional for posix platforms


# Creating RoundCube folder
file { '/var/www/roundcube':
    ensure => 'directory',
}


# Downloading and extracting RoundCube archive to /var/www
archive { '/var/www/roundcubemail-1.4.2-complete.tar.gz':
  source        => 'https://github.com/roundcube/roundcubemail/releases/download/1.4.2/roundcubemail-1.4.2-complete.tar.gz',
  extract       => 'true',
  extract_path  => '/var/www/roundcube',
  extract_command => 'tar -xf %s --strip-components 1',
  creates  => '/var/www/roundcube/bin',  
  cleanup       => true
}
