Pod::Spec.new do |s|

    s.name         = "Tpay-SDK.dev"
    s.module_name  = "Tpay" 
    s.version      = "1.3.2"
    s.summary      = "Tpay-SDK for iOS"
  
    s.description  = <<-DESC
    The Tpay SDK empowers your app to seamlessly integrate Tpay’s payment functionalities, providing a comprehensive and developer-friendly solution for managing payments. By utilizing the SDK’s capabilities, you can offer your users a secure, convenient, and reliable payment experience within your app.
                      DESC
  
    s.homepage     = "https://gitlab.rndlab.online/tpay/ios/tpay-ios.git"
    s.license      = "Tpay License"
    s.author       = "Tpay"
  
    s.platform = :ios, "12.0"
    s.swift_version = '5.3'
    s.static_framework = true 

    s.source       = { :git => "git@gitlab.futuremind.dev/tpay/tpay-sdk-ios.git", :tag => "#{s.version}" }
    s.source_files = 'Tpay/Tpay/Sources/**/*.swift', 'Tpay/Tpay/Dependencies/**/*.swift', 'Tpay/Tpay/Resources/**/*.swift'
    s.resource_bundles = { 'Tpay' => ['Tpay/Tpay/Resources/**/*.{xcassets,ttf,strings,xcprivacy}'] }
    
  end
    