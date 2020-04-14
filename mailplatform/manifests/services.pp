# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include mailplatform::services
class mailplatform::services {


#  define restart_service_array (
#    Array[String] $service_array,
#  ) {
#    $service_array.each |String $curr_service| {
#      service { "Starting ${curr_service}":
#        restart => true,
#        name   => $curr_service,
#      }
#    }
#  }
  $my_services = ['cockpit.socket', 'saslauthd.service', 'postfix', 'dovecot',
  'pdns-recursor', 'httpd', 'pdns', 'php-fpm'] #'mysqld', 'httpd',

  service { $my_services:
    ensure => true,
    enable => true,
  }

  #mailplatform::services::restart_service_array {'Running all services':
  #  service_array => $my_services,
  #}

}
