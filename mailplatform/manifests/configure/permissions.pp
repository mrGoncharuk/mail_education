# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include mailplatform::configure::permissions
class mailplatform::configure::permissions {
  # exec { 'change mod to every user mailhome folders':
  #     command    => '/usr/bin/chmod 0600 /var/mail/*'
  # }
  # # Hint taken from https://ask.puppet.com/question/27007/how-to-recursively-chmod-files-in-directory/
  # file {'Ensure proper permissions for mail location':
  #   ensure       => directory,
  #   path         => '/var/mail',
  #   recurse      => true,
  #   recurselimit => 1,
  #   mode         => 'a+rwxt',
  # }
  file {'Ensure proper permissions for mail location':
    ensure       => directory,
    path         => '/var/mail',
    mode         => 'a+rwxt',
  }
}
