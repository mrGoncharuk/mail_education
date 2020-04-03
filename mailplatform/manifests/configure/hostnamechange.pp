# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include mailplatform::configure::hostnamechange
class mailplatform::configure::hostnamechange {
  $new_hostname = 'allinone-mh.localhost'   ## TODO: add to facts

  exec { 'change hostname':
    command  => "/usr/bin/hostnamectl set-hostname ${new_hostname}",
    onlyif   => "if [['hostname' == ${new_hostname}]]; then exit  1; else exit 0; fi;",
    provider => 'shell',
  }
}
