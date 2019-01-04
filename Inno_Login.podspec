Pod::Spec.new do |s|
  s.name             = 'Inno_Login'
  s.version          = '4.4.6'
  s.summary          = 'a login library and check version.'
  s.description      = <<-DESC
TODO: Add long description of the pod here...
DESC

  s.homepage         = 'http://www.innoways.com'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kaifeng Wu' => '24272779@qq.com' }
s.source           = { :git => 'https://github.com/innowayskaifeng/inno_login.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Inno_Login/Classes/**/*'

  s.resource_bundles = {
     'Inno_Login' => ['Inno_Login/Assets/**/*']
  }
# s.public_header_files = 'Inno_Login/**/*.swift'
  s.frameworks = 'UIKit','Foundation'
# s.dependency 'Alamofire', '~>4.5'
  s.dependency 'IBAnimatable', '~>5.2.1'
  s.dependency 'BiometricAuthentication', '~>2.1'
end
