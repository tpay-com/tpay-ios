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
  s.source = { :http => "TO_BE_REPLACED_DURING_CI_BUILD", :flatten => true }
  s.vendored_frameworks = "Tpay.xcframework"
  
end