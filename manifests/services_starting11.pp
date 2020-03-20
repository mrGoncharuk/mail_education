
$my_serivese = ["cockpit.socket", "saslauthd.service", "postfix", "dovecot",
                "pdns-recursor", "pdns", "mysqld", "httpd", "php-fpm"]

service { $my_serivese:
  ensure  => running, 
  enable => true,
}
