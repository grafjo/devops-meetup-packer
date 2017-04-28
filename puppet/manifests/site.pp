include apt
include apt::backports

ensure_packages(['openjdk-8-jre-headless', 'ca-certificates-java'], {
  require         => Class['apt::backports'],
  install_options => ['-t', 'jessie-backports'],
})

apt::key { 'synyx':
  ensure => 'present',
  id     => 'ED387B98FF80010F9851FC734FC2426F8A1BC01A',
  source => 'http://install.synyx.net/apt/pub.key',
} ->

apt::source { 'synyx-urlaubsverwaltung':
  ensure   => 'present',
  location => 'http://install.synyx.net/apt/urlaubsverwaltung',
  repos    => 'main',
  release  => 'stable',
}

ensure_packages(['urlaubsverwaltung'], {
  require => [
    Apt::Source['synyx-urlaubsverwaltung'],
    Package['openjdk-8-jre-headless'],
  ],
})
