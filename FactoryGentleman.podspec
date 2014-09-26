Pod::Spec.new do |s|
  s.name = 'FactoryGentleman'
  s.version = '1.2.2'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'A simple library to help define model factories for use when testing your iOS/Mac applications.'

  s.homepage = 'https://github.com/SoundCloud/FactoryGentleman'
  s.author = {
    'Michael England' => 'mg.england@gmail.com',
    'Slavko Krucaj' => 'slavko.krucaj@gmail.com'
  }
  s.source = { :git => 'https://github.com/soundcloud/FactoryGentleman.git', :tag => s.version.to_s }

  s.source_files = 'Classes/FactoryGentleman/*.{h,m}'
  s.public_header_files = 'Classes/FactoryGentleman/*.h'

  s.requires_arc = true
end
