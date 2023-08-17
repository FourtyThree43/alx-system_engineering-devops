# Puppet Manifest: 1-user_limit.pp
# This manifest updates the nofile limits in the /etc/security/limits.conf file.

# Replace the nofile limit for the first time
exec { 'replace-nofile-1':
  provider => shell,
  command  => 'sudo sed -i "s/nofile 5/nofile 50000/" /etc/security/limits.conf',
  before   => Exec['replace-nofile-2'],
}

# Replace the nofile limit for the second time
exec { 'replace-nofile-2':
  provider => shell,
  command  => 'sudo sed -i "s/nofile 4/nofile 40000/" /etc/security/limits.conf',
}
