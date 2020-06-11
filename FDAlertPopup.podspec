
Pod::Spec.new do |spec|

  spec.name         = "FDAlertPopup"
  spec.version      = "0.8"
  spec.summary      = "FineDine Alert Popup"

  spec.description  = <<-DESC
FineDine Alert ViewController, written in Swift.
                   DESC

  spec.homepage     = "https://github.com/finedine/FDAlertPopup-iOS"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author    = { "FineDine" => "info@finedinemenu.com" }

  spec.ios.deployment_target = "9.0"
  spec.swift_version = "5.0"


  spec.source       = { :git => "https://github.com/finedine/FDAlertPopup-iOS.git", :tag => "#{spec.version}" }
  spec.source_files  = "FDAlertPopup", "FDAlertPopup/**/*.swift"

  spec.resources = "FDAlertPopup/Media/*"

  spec.dependency "SnapKit", "4.2.0"
  spec.dependency "LGButton", "1.1.6"
  spec.dependency "lottie-ios", "3.1.6"

end
