class getlib::mount (
  $local_mount_path,
  $mount_server,
  $mount_server_path,
  $ensure = 'mounted'
) {
  mount { "mount_${name}":
    name     => $local_mount_path,
    ensure   => $ensure,
    atboot   => true,
    device   => "${mount_server}:${mount_server_path}",
    fstype   => 'nfs',
    options  => 'defaults',
    remounts => true,
  }
}
