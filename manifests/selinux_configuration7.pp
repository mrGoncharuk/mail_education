    # PHP-MySQL extension
# yum -y install php-mysql      //TODO: ensure installing

    # SE Linux permission configuration
# chcon -t httpd_sys_content_t /var/www/roundcube/ -R

file { "/var/www/roundcube/":
    ensure  => directory,
    recurse => true,
    seltype => "httpd_sys_content_t",
}

# chcon -t httpd_sys_rw_content_t /var/www/roundcube/temp/ /var/www/roundcube/logs/ -R
file { "/var/www/roundcube/temp/":
    ensure  => directory,
    recurse => true,
    seltype => "httpd_sys_rw_content_t",
}

file { "/var/www/roundcube/logs/":
    ensure  => directory,
    recurse => true,
    seltype => "httpd_sys_rw_content_t",
}


# setfacl -R -m u:apache:rwx /var/www/roundcube/temp/ /var/www/roundcube/logs/
exec { "setfacl apache":
    command => "/usr/bin/setfacl -R -m u:apache:rwx /var/www/roundcube/temp/ /var/www/roundcube/logs/",
}


# setsebool -P httpd_can_network_connect 1

selboolean { 'setting up httpd_can_network_connect to true':
  name       => "httpd_can_network_connect",
  value      => 'on',
}

