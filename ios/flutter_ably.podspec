#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_ably'
  s.version          = '0.0.1'
  s.summary          = 'An Ably SDK for Flutter.'
  s.description      = <<-DESC
An Ably SDK for Flutter.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'XLNT' => 'matt@xlnt.co' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Ably', '~> 1.0'

  s.ios.deployment_target = '8.0'
end

