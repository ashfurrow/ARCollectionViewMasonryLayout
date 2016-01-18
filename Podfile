target 'Demo' do

  workspace 'ARCollectionViewMasonryLayout'
  xcodeproj 'Demo/Demo.xcodeproj'

  pod 'ARCollectionViewMasonryLayout', :path => 'ARCollectionViewMasonryLayout.podspec'
  pod 'EDColor', '0.4.0'

  target "IntegrationTests" do
    inherit! :search_paths
    pod 'Specta'
    pod 'Expecta'
    pod 'Expecta+Snapshots'
  end
end

