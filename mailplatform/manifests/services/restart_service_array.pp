# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   mailplatform::services::restart_service_array { 'namevar': }
define mailplatform::services::restart_service_array (
  Array[String] $service_array,
  ) {
  $service_array.each |String $curr_service| {
    service { "Starting ${curr_service}":
      restart => true,
      name    => $curr_service,
    }
  }
}
