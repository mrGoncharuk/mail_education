# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include mailplatform::configure::pdns_recursor
class mailplatform::configure::pdns_recursor {
  file_line {' Uncomment local-port 53 at pdns-recursor config file':
    path  => '/etc/pdns-recursor/recursor.conf',
    line  => 'local-port=53',
    match => '# local-port=53',
  }
  # Configuring forward-zones
  file_line {'Configuring forward-zones':
    path  => '/etc/pdns-recursor/recursor.conf',
    line  => 'forward-zones=youdidnotevenimaginethisdomainexists.com=127.0.0.1:54',
    match => '# forward-zones=',
  }
}
