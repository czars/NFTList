
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '12.0'

use_frameworks!

target 'NFTList' do
  pod 'Kingfisher'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SVGKit', :git => "https://github.com/SVGKit/SVGKit", :branch => "3.x"
  pod 'Alamofire'
end

target 'NFTListTests' do
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxTest'
end


post_install do |installer|
  # Configure the Pods project
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['DEAD_CODE_STRIPPING'] = 'YES'
  end
  
  #  # Configure the Pod targets
  #  installer.pods_project.targets.each do |target|
  #    target.build_settings.delete 'DEAD_CODE_STRIPPING'
  #    target.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
  #  end
  
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if Gem::Version.new('12.0') > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end
end
