# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include mailplatform::configure::aliases
class mailplatform::configure::aliases {
  file_line { 'removing manager from alias list':
    ensure            => absent,
    path              => '/etc/aliases',
    match             => 'manager',
    match_for_absence => true,
  }
  exec { 'newaliases':
    path        => ['/usr/bin', '/usr/sbin'],
    subscribe   => File_line['removing manager from alias list'],
    refreshonly => true,
#    require           => File_line['removing manager from alias list'],
  }
}
