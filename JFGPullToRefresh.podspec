#
# Be sure to run `pod lib lint JFGPullToRefresh.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JFGPullToRefresh"
  s.version          = "0.1.0"
  s.summary          = "A arrow pull to refresh library"
  s.description      = <<-DESC
                       A simple pull to refresh library with arrow animation.

                       Inspired by the Twitter app for iPad
                       DESC
  s.homepage         = "https://github.com/fatalaa/JFGPullToRefresh"
  s.screenshots      = "https://raw.githubusercontent.com/fatalaa/JFGPullToRefresh/master/Example/Gif/demo.gif"
  s.license          = 'MIT'
  s.author           = { "Tibor Molnár" => "fatalaa@hotmail.com" }
  s.source           = { :git => "https://github.com/fatalaa/JFGPullToRefresh.git", :tag => "v0.1.0" }
  s.social_media_url = 'https://twitter.com/fatalaa'

  s.platform     = :ios, '7.1'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resources    =  ['Pod/Assets/Media.xcassets']

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
