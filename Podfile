platform :ios, '12.0'
workspace 'Tpay'
source 'https://github.com/CocoaPods/Specs.git'

target 'Tpay' do
  project 'Tpay/Tpay.xcodeproj'
  pod 'SwiftLint'
  pod 'SwiftGen'
end

target 'TpayTests' do
  project 'Tpay/Tpay.xcodeproj'
  pod 'Nimble'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
