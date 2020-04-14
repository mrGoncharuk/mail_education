# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include mailplatform
class mailplatform {
  require 'archive' # NOTE: optional for posix platforms
  require 'stdlib' # NOTE: optional for posix platforms
  contain mailplatform::installpackages
  contain mailplatform::configure
  contain mailplatform::services
  contain mailplatform::users
  Class['mailplatform::installpackages'] -> Class['mailplatform::users']
  -> Class['mailplatform::configure'] -> Class['mailplatform::services']
}
