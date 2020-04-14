# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include mailplatform::configure::postfix
class mailplatform::configure::postfix {
  # Setting up inet_interfaces to all(listening all addresses)
  file { 'postfix main.cf':
    ensure => present,
    path   => '/etc/postfix/main.cf',
    source => 'puppet:///modules/mailplatform/main.cf',
    owner  => root,
    group  => root,
    mode   => '0644',
  }
#  file_line {'Setting up inet_interfaces to all':
#    path  => '/etc/postfix/main.cf',
#    line  => 'inet_interfaces = all',
#    match => 'inet_interfaces = localhost',
#  }
#  file_line {'Enabling sasl authentication : case 1':
#    path              => '/etc/postfix/main.cf',
#    line              => "\n# Custom added options\nsmtpd_sasl_auth_enable = yes",
#    match             => '^smtpd_sasl_auth_enable = yes',
#    match_for_absence => true,
#  }
#  file_line {'Enabling sasl authentication : case 2':
#    path  => '/etc/postfix/main.cf',
#    line  => "\n# Custom added options\nsmtpd_sasl_auth_enable = yes",
#    match => '^# smtpd_sasl_auth_enable = ',
#  }

}
