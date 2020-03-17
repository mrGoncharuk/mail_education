    # PHP-MySQL extension
# yum -y install php-mysql
    # SE Linux permission configuration
# chcon -t httpd_sys_content_t /var/www/roundcube/ -R
# chcon -t httpd_sys_rw_content_t /var/www/roundcube/temp/ /var/www/roundcube/logs/ -R
# setfacl -R -m u:apache:rwx /var/www/roundcube/temp/ /var/www/roundcube/logs/
# setsebool -P httpd_can_network_connect 1

package { "php-mysql":
   ensure => 'installed',
}


