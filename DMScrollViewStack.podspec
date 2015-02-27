#
# Be sure to run `pod lib lint DMScrollViewStack.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DMScrollViewStack"
  s.version          = "0.1.4"
  s.summary          = "DMScrollViewStack is a UIScrollView subclass that efficiently handles a vertical stack of multiple scrollviews."
  s.description      = "DMScrollViewStack is a UIScrollView subclass that efficiently handles a vertical stack of multiple scrollviews. You can layout vertically your subviews without worrying about memory usage and cells caching if your subview is a table or a collectionview."
  s.homepage         = "https://github.com/malcommac/DMScrollViewStack"
  s.license          = 'MIT'
  s.author           = { "Daniele Margutti" => "me@danielemargutti.com" }
  s.source           = { :git => "https://github.com/malcommac/DMScrollViewStack.git", :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/danielemargutti'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'DMScrollViewStack' => ['Pod/Assets/*.png']
  }
end
