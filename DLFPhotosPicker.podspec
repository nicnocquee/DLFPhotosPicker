#
# Be sure to run `pod lib lint DLFPhotosPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DLFPhotosPicker'
  s.version          = '0.16.4'
  s.summary          = 'Photos picker for iOS using iOS 8 Photos framework'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
This is a library to select single photo or multiple photos in iOS 8 or later using iOS Photos framework. I use this library in my app, Delightful app.

Features:
--

- Tap and hold a photo to preview (zoom).
- Pinch out a photo to preview (zoom).
- Drag to select multiple photos quickly. Simply drag to left or right to start selecting multiple photos.
- Works on both landscape and portrait.
- Using iOS 8's UISplitViewController for albums and photos. You can see the split view on iPhone 6 plus landscape.
- Quickly clear all selections.
- Selected photos are retained when changing album.
DESC

  s.homepage         = 'https://github.com/nicnocquee/DLFPhotosPicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nico Prananta' => 'nicnocquee@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/nicnocquee/DLFPhotosPicker.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/nicnocquee'

  s.platform = :ios
  s.ios.deployment_target = '8.0'

  s.source_files = 'DLFPhotosPicker/Classes/**/*.*'
  
  # s.resource_bundles = {
  #   'DLFPhotosPicker' => ['DLFPhotosPicker/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
