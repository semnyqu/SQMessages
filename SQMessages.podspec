#
# Be sure to run `pod lib lint SQMessages.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SQMessages"
  s.version          = "0.0.1"
  s.summary          = "Easy to use and customizable messages/notifications for iOS."
  s.description  = <<-DESC
                                        Base TSMessages; This framework provides an easy to use class to show little notification views on the top of the screen. There are 4 different types already set up for you: Success, Error, Warning, Message..
                   DESC
  s.homepage     = "https://github.com/semnyqu/SQMessages"

  s.license          = 'MIT'
  s.author           = { "semnyqu" => "semny.qu@gmail.com" }
  s.source           = { :git => "https://github.com/semnyqu/SQMessages.git", :tag => s.version.to_s }

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resources = ['Pod/Assets/*.png', 'Pod/Assets/*.json']

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'HexColors', '~> 2.3.0'
  s.dependency 'Masonry', '~> 1.1.0' #界面相对布局框架,某种程度上替换Autolayout
  s.dependency 'MarqueeLabel', '~> 3.1.3' #跑马灯Label
  s.dependency 'NSHash', '~> 1.2.0' #加密 MD5 SHA1 SHA256

end
