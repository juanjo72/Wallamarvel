
platform :ios, '12.0'
inhibit_all_warnings!

target 'Wallamarvel' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'RxSwift', '~> 5.1.0'
  pod 'RxCocoa', '~> 5.1.0'
  pod 'SlimGateway', '~> 2.0.0'
  

  target 'API' do
    inherit! :search_paths
    pod 'CryptoSwift', '~> 1.3.0'
  end
  
  target 'WallamarvelTests' do
    inherit! :search_paths
    # Pods for testing
  end
end
