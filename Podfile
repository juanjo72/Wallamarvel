
platform :ios, '13.0'
inhibit_all_warnings!
use_frameworks!

target 'Wallamarvel' do
  pod 'RxSwift', '~> 5.1.0'
  pod 'RxCocoa', '~> 5.1.0'
  pod 'RxDataSources', '~> 4.0.0'
  pod 'RxGesture', '~> 3.0.0'
  pod 'SlimGateway', '~> 2.0.0'
  pod 'SnapKit', '~> 5.0.0'
  pod 'Kingfisher', '~> 5.15.0'
  
  target 'WallamarvelTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
    pod 'RxBlocking'
    pod 'iOSSnapshotTestCase'
    pod 'Nimble-Snapshots'
  end

  target 'WallamarvelUITests' do
    inherit! :search_paths
    pod 'iOSSnapshotTestCase'
  end
end

target 'API' do
  pod 'CryptoSwift', '~> 1.3.0'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'YES'
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete('ARCHS') # otherwise a warning is issued
      config.build_settings.delete('SWIFT_VERSION') # taken from project globals instead
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf' # so that symbol files are not included
    end
  end
end
