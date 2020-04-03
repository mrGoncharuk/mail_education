# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   mailplatform::install_package_array { 'namevar': }
define mailplatform::install_package_array (
  Array[String] $package_array,
) {
  $package_array.each |String $curr_package| {
    package { "Installing ${curr_package}":
      ensure => 'installed',
      name   => $curr_package,
    }
  }
}
