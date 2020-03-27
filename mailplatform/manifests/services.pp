# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include mailplatform::services
class mailplatform::services {
$my_serivese = ["cockpit.socket", "saslauthd.service", "postfix", "dovecot",
                "pdns-recursor", "pdns", "mysqld", "httpd", "php-fpm"]

service { $my_serivese:
  ensure  => running,
  enable => true,
}
}
