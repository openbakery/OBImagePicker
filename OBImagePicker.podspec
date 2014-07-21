Pod::Spec.new do |spec|
  spec.name         = 'OBImagePicker'
  spec.version      = '0.1.0'
  spec.summary      = "A more versatile replacement for UIImagePicker"
  spec.homepage     = "https://github.com/openbakery/OBImagePicker"
  spec.author       = { "René Pirringer" => "rene@pirringer.at" }
  spec.social_media_url = 'https://twitter.com/rpirringer'
  spec.source       = { :git => "https://github.com/openbakery/OBImagePicker.git", :tag => spec.version.to_s}
  spec.platform = :ios
  spec.ios.deployment_target = '6.0'
  spec.license      = 'BSD'
  spec.requires_arc = true
  spec.source_files = ['Core/Source/*.{h,m}', 'Core/Source/ALAsset/*.{h,m}']
  spec.resource_bundle = { 'OBImagePicker' => ['Core/Resource/*.png', 'Core/Resource/*.lproj'] }
end
