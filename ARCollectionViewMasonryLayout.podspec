Pod::Spec.new do |s|
  s.name                = "ARCollectionViewMasonryLayout"
  s.version             = "2.0.0"
  s.summary             = "ARCollectionViewMasonryLayout is a UICollectionViewLayout subclass for creating flow-like layouts with dynamic widths or heights."
  s.homepage            = "https://github.com/AshFurrow/ARCollectionViewMasonryLayout"
  s.screenshots         = "https://raw.githubusercontent.com/AshFurrow/ARCollectionViewMasonryLayout/master/Screenshots/ARCollectionViewMasonryLayout.png"
  s.license             = 'MIT'
  s.author              = { "Orta Therox" => "orta.therox@gmail.com" }
  s.social_media_url    = "http://twitter.com/orta"
  s.platform            = :ios
  s.platform            = :ios, '7.0'
  s.source              = { :git => "https://github.com/AshFurrow/ARCollectionViewMasonryLayout.git", :tag => "#{s.version}" }
  s.source_files        = '*.{h,m}'
  s.public_header_files = 'ARCollectionViewMasonryLayout.h'
  s.framework           = 'UIKit'
  s.requires_arc        = true
end
