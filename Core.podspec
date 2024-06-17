
Pod::Spec.new do |s|
  s.name             = 'Core'
  s.version          = '1.0.2'
  s.summary          = 'Core services for iOS apps'

  s.description      = 'Core services for global apps on iOS'

  s.homepage         = 'https://github.com/felipeassis97/Core'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'felipeassis97' => 'felipeassis97@gmail.com' }
  s.source           = { :git => 'https://github.com/felipeassis97/Core.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'


  s.ios.deployment_target = '16.0'
  s.swift_version = '5.0'

  s.source_files = 'Classes/**/*'
  
end
