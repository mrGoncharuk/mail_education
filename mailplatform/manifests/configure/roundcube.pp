# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include mailplatform::configure::roundcube
class mailplatform::configure::roundcube {
  $virtualhost = '*:80'
  $servername  = '127.0.0.1'
  $str = "<VirtualHost ${virtualhost}>
    ServerName ${servername}
    DocumentRoot /var/www/roundcube/
  
    ErrorLog /var/log/httpd/roundcube_error.log
    CustomLog /var/log/httpd/roundcube_access.log combined
  
    <Directory />
      Options FollowSymLinks
      AllowOverride All
    </Directory>
  
    <Directory /var/www/roundcube/>
      allow from all
    </Directory>
  
  </VirtualHost>
"
  file { '/etc/httpd/conf.d/roundcube.conf':
    content => $str,
  }
  # SE Linux permission configuration
  #  chcon -t httpd_sys_content_t /var/www/roundcube/ -R
  # file { 'SE Linux configuration for RoundCube foleder':
  #     path    => '/var/www/roundcube/',
  #     ensure  => directory,
  #     recurse => true,
  #     seltype => 'httpd_sys_content_t',
  # }
  #  chcon -t httpd_sys_rw_content_t /var/www/roundcube/temp/ /var/www/roundcube/logs/ -R
  file { '/var/www/roundcube/temp/':
      ensure  => directory,
      recurse => true,
      seltype => 'httpd_sys_rw_content_t',
  }
  file { '/var/www/roundcube/logs/':
      ensure  => directory,
      recurse => true,
      seltype => 'httpd_sys_rw_content_t',
  }
}
