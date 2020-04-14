# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include mailplatform::configure::systems
class mailplatform::configure::systems {
#  exec { 'setfacl apache':
#    command => '/usr/bin/setfacl -R -m u:apache:rwx /var/www/roundcube/temp/ /var/www/roundcube/logs/',
#    require => Selboolean['setting up httpd_can_network_connect to true']
#  }
  posix_acl { ['/var/www/roundcube/temp/','/var/www/roundcube/logs/']:
    action     => set,
    permission => [
      'user:apache:rwx',
    ],
    provider   => posixacl,
    recursive  => true,
  }
  # setsebool -P httpd_can_network_connect 1
  selboolean { 'setting up httpd_can_network_connect to true':
    name       => 'httpd_can_network_connect',
    value      => 'on',
    persistent => true,
  }
}
