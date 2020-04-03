# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   mailplatform::installpackages::packageinstaller { 'namevar': }

define mailplatform::installpackages::packageinstaller (
  Array[String] $package_array,
) {
  $package_array.each |String $curr_package| {
    package { "Installing $curr_package":
      ensure => 'installed',
      name   => $curr_package,
    }
  }
}
