# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include mailplatform
class mailplatform (
  String $configure_mysql_rc_pass = password,
){
  require 'archive' # NOTE: optional for posix platforms
  require 'stdlib' # NOTE: optional for posix platforms
  include mailplatform::installpackages
  include mailplatform::configure
  include mailplatform::services
  include mailplatform::users
  Class['mailplatform::installpackages'] -> Class['mailplatform::users']
  -> Class['mailplatform::configure'] ~> Class['mailplatform::services']
}
