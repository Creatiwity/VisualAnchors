#
# Be sure to run `pod lib lint VisualAnchors.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VisualAnchors'
  s.version          = '4.0.0'
  s.summary          = 'An easier way to programmatically use constraints in Swift with iOS9+.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
VisualAnchors is a library that aims to allow developers to programmatically use constraints in an easier way than the officially-documented way.

It extends UIView by adding an attribute containing the anchors of the view (leading, trailing, top, ...). You just have to assign an anchor to an other following the notation `anchor1 = constant + anchor2 * multiplier`.
                       DESC

  s.homepage         = 'https://github.com/Creatiwity/VisualAnchors'
  s.license          = 'MIT'
  s.author           = { 'Julien Blatecky' => 'julien.blatecky@creatiwity.net' }
  s.source           = { :git => 'https://github.com/Creatiwity/VisualAnchors.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/CreatiwitySAS'

  s.ios.deployment_target = '9.0'

  s.source_files = 'VisualAnchors/Classes/*.swift'

  s.frameworks = 'UIKit'
end
