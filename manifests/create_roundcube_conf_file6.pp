define roundcube_conf (
    String $virtualhost = '*:80',
    String $servername = '127.0.0.1'
) {
    $str = 
"
<VirtualHost ${virtualhost}>
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
      notify => Service['httpd'],
    }

    service {'httpd':
     ensure => running,
     enable => true,
   }
}

$virtualhost=undef
$servername=undef
roundcube_conf {"creates config for roundcube":
    virtualhost => $virtualhost,
    servername  => $servername,
}
