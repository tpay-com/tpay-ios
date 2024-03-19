Pod::Spec.new do |s|

  s.name         = "TpaySDK"
  s.module_name  = "Tpay" 
  s.version      = "0.4.0"
  s.summary      = "TpaySDK for iOS"

  s.description  = <<-DESC
  Tpay framework
                    DESC

  s.homepage     = "https://tpay.com"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author       = "Krajowy Integrator Płatności S.A."

  s.platform = :ios, "12.0"
  s.swift_version = "5.3"
  s.source = { :http => "https://github.com/tpay-com/tpay-ios/releases/download/0.4.0/Tpay.xcframework.zip", :flatten => true }
  s.vendored_frameworks = "Tpay.xcframework"
  
end
