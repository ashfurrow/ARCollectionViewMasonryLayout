platform :ios, '7.1'

target 'Demo' do

  workspace 'ARCollectionViewMasonryLayout'
  project 'Demo/Demo.xcodeproj'

  pod 'ARCollectionViewMasonryLayout', :path => 'ARCollectionViewMasonryLayout.podspec'
  pod 'EDColor', '0.4.0'

  target "IntegrationTests" do
    inherit! :search_paths
    pod 'Specta'
    pod 'Expecta'
    pod 'Expecta+Snapshots'
  end
end

