name 'hms'
maintainer 'Jonathan Sloan'
maintainer_email 'jsloan117@gmail.com'
license 'GPL-3.0'
description 'Installs/Configures hms'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
chef_version '>= 14.1.12' if respond_to?(:chef_version)
version '0.1.0'

issues_url 'https://github.com/jsloan117/hms/issues' if respond_to?(:issues_url)
source_url 'https://github.com/jsloan117/hms' if respond_to?(:source_url)

supports 'centos', '>= 7.0'

depends 'docker', '>= 4.6.7'
depends 'yum-epel', '>= 3.3.0'
depends 'yumgroup', '>= 0.6.0'
