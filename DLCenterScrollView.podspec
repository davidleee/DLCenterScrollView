#
# Be sure to run `pod lib lint DLCenterScrollView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DLCenterScrollView"
  s.version          = "0.1.0"
  s.summary          = "This is a horizontal ScrollView inspired by ATO App."
  s.homepage         = "https://github.com/davidleee/DLCenterScrollView"
  s.license          = 'MIT'
  s.author           = { "Lee9272" => "yiran.lee72@gmail.com" }
  s.source           = { :git => "https://github.com/davidleee/DLCenterScrollView.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  s.frameworks = 'UIKit'
end
