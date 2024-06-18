
Pod::Spec.new do |s|
  s.name             = 'Core'
  s.version          = '1.2.1'
  s.summary          = 'Core services for iOS apps'
  s.description      = 'This package was created to facilitate the setup of new projects, bringing with it an implementation with the main services used in all apps, such as an HTTP client, use of internal storage and some useful extensions'

  s.homepage         = 'https://github.com/felipeassis97/Core'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'felipeassis97' => 'felipeassis97@gmail.com' }
  s.source           = { :git => 'https://github.com/felipeassis97/Core.git', :tag => s.version.to_s }

  s.ios.deployment_target = '16.0'
  s.swift_version = '5.0'
  s.source_files = 'Classes/**/*'

end
