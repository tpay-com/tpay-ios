Pod::Spec.new do |s|

  s.name         = "Tpay"
  s.version      = "0.3.1"
  s.summary      = "Tpay for iOS"

  s.description  = <<-DESC
  Tpay framework
                    DESC

  s.homepage     = "https://tpay.com"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author       = "Tpay"

  s.platform = :ios, "12.0"
  s.swift_version = "5.3"
  s.source = { :http => "https://github.com/tpay-com/tpay-ios/releases/download/0.3.1/Tpay.xcframework.zip", :flatten => true }
  s.vendored_frameworks = "Tpay.xcframework"
  
end
