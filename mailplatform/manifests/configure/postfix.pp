# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include mailplatform::configure::postfix
class mailplatform::configure::postfix {
  # Setting up inet_interfaces to all(listening all addresses)
  file_line {'Setting up inet_interfaces to all':
    path  => '/etc/postfix/main.cf',
    line  => 'inet_interfaces = all',
    match => 'inet_interfaces = localhost',
  }
  file_line {'Enabling sasl authentication':
    path => '/etc/postfix/main.cf',
    line => '\n# Custom added options\nsmtpd_sasl_auth_enable = yes',
  }
}
