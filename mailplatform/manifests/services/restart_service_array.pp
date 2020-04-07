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
    exec{ "Restarting ${curr_service}":
      command => "/usr/bin/systemctl restart ${curr_service}",
      #alternatively push down an actual script and call that
      # notify  => Service[$curr_service],
    }
  }
  # $service_array.each |String $curr_service| {
  #   service { "Starting ${curr_service}":
  #     start => true,
  #     name  => $curr_service,
  #   }
  # }

}
