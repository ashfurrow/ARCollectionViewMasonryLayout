Pod::Spec.new do |s|
  s.name                = "ARCollectionViewMasonryLayout"
  s.version             = "2.3.0"
  s.description         = "ARCollectionViewMasonryLayout is a UICollectionViewLayout subclass for creating masonry / pintrest / flow-like layouts with dynamic widths or heights. Supports sticky headers too."
  s.summary             = "A UICollectionViewLayout subclass for creating masonry / pintrest / flow-like layouts with dynamic widths or heights."
  s.homepage            = "https://github.com/AshFurrow/ARCollectionViewMasonryLayout"
  s.screenshots         = "https://raw.githubusercontent.com/AshFurrow/ARCollectionViewMasonryLayout/master/Screenshots/ARCollectionViewMasonryLayout.png"
  s.license             = 'MIT'
  s.author              = { "Orta Therox" => "orta.therox@gmail.com", "Ash Furrow" => "ash@ashfurrow.com" }
  s.social_media_url    = "http://twitter.com/orta"
  s.tvos.deployment_target = '9.0'
  s.ios.deployment_target = '7.0'
  s.source              = { :git => "https://github.com/AshFurrow/ARCollectionViewMasonryLayout.git", :tag => s.version }
  s.source_files        = '*.{h,m}'
  s.public_header_files = 'ARCollectionViewMasonryLayout.h'
  s.framework           = 'UIKit'
  s.requires_arc        = true
end
