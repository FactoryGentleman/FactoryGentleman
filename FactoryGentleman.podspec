Pod::Spec.new do |s|
  s.name = 'FactoryGentleman'
  s.version = '0.0.1'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'A simple library to help define model factories for use when testing your iOS/Mac applications.'

  s.homepage = 'https://github.com/SoundCloud/FactoryGentleman'
  s.author = { 'Michael England' => 'mg.england@gmail.com' }
  s.source = { :git => 'git@github.com:soundcloud/FactoryGentleman.git', :tag => s.version.to_s }

  s.source_files = 'Source/FactoryGentleman/*.{h,m}'
  s.public_header_files = 'Source/FactoryGentleman/*.h'

  s.requires_arc = true
end
