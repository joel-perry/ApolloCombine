Pod::Spec.new do |s|
  s.name             = 'ApolloCombine'
  s.version          = '0.7.1'
  s.author           = { 'Joel Perry' => 'joel@joelperry.net' }
  s.homepage         = 'https://github.com/joel-perry/ApolloCombine'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }

  s.summary          = 'A collection of Combine publishers for the Apollo iOS client.'
  
  s.source           = { :git => 'https://github.com/joel-perry/ApolloCombine.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.tvos.deployment_target = '13.0'
  s.watchos.deployment_target = '6.0'

  s.source_files = 'Sources/ApolloCombine/*.swift'

  s.weak_frameworks = 'SwiftUI', 'Combine'
  s.dependency 'Apollo/Core', '~> 1.5'
  s.swift_version = '5.6'

end
