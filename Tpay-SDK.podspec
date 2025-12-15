Pod::Spec.new do |s|

  s.name         = "Tpay-SDK"
  s.module_name  = "Tpay"
  s.version      = "1.3.7"
  s.summary      = "Tpay-SDK for iOS"

  s.description  = <<-DESC
  The Tpay SDK empowers your app to seamlessly integrate Tpay’s payment functionalities, providing a comprehensive and developer-friendly solution for managing payments. By utilizing the SDK’s capabilities, you can offer your users a secure, convenient, and reliable payment experience within your app.
                    DESC

  s.homepage     = "https://tpay.com"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "Krajowy Integrator Płatności S.A."

  s.platform = :ios, "12.0"
  s.swift_version = "6.0"
  s.source = { :http => "https://github.com/tpay-com/tpay-ios/releases/download/1.3.7/Tpay.xcframework.zip", :flatten => true }
  s.vendored_frameworks = "Tpay.xcframework"

end
