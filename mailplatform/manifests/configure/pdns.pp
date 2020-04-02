# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include mailplatform::configure::pdns
class mailplatform::configure::pdns {
  file_line {'Uncomment local-port at pdns config file and changing port value to 54':
    path  => '/etc/pdns/pdns.conf',
    line  => 'local-port=54',
    match => '# local-port=53',
  }
  # Creating custom named.conf and adding path to him to pdns.conf
  file { '/etc/pdns/named.conf':
    source => '/vagrant/config_files/named.conf'
  }
  file_line {' adding path to named.conf to pdns config':
    path => '/etc/pdns/pdns.conf',
    line => 'bind-config=/etc/pdns/named.conf',
  }
  # Creating directory for zone file and copying it to his directory
  file{'/var/lib/pdns':
    ensure =>  directory,
  }
  file{'/var/lib/pdns/youdidnotevenimaginethisdomainexists.com.db':
    ensure  =>  file,
    content =>  template('/vagrant/config_files/youdidnotevenimaginethisdomainexists.com.db'),
    require => File['/var/lib/pdns'],
  }
}
