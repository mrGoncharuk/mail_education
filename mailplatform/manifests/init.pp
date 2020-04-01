# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include mailplatform
class mailplatform {
  include 'archive' # NOTE: optional for posix platforms
  include mailplatform::installpackages
  include mailplatform::installpackages
  include mailplatform::installpackages
  include mailplatform::installpackages
  
  Class['mailplatform::installpackages'] -> Class['mailplatform::configure'] ~> Class[services] -> Class[users]

}
