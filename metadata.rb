name              'samba'
maintainer        'Lyle Dietz'
maintainer_email  'ritterwolf@gmail.com'
license           'Apache 2.0'
description       'Install and configure Samba and its associated components'
#long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.0.1'

supports 'ubuntu', '= 14.04'

depends 'apt'
depends 'nsswitch'
