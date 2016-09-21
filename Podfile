# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'

target 'Memo' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Memo
  pod 'SnapKit', '0.22.0'
  pod 'Then', '1.0.3'
  pod 'RealmSwift', '1.0.2'
  pod 'RxCocoa', '~> 2.6.0'
  pod 'MBProgressHUD'
  # 取决于你的工程如何组织，你的node_modules文件夹可能会在别的地方。
  # 请将:path后面的内容修改为正确的路径（一定要确保正确～～）。
  pod 'React', :path => './ReactComponent/node_modules/react-native', :subspecs => [
  'Core',
  'ART',
  'RCTActionSheet',
  'RCTAdSupport',
  'RCTGeolocation',
  'RCTImage',
  'RCTNetwork',
  'RCTPushNotification',
  'RCTSettings',
  'RCTText',
  'RCTVibration',
  'RCTWebSocket',
  'RCTLinkingIOS',
  ]
  pod 'CodePush', :path => './ReactComponent/node_modules/react-native-code-push'
  
end

target 'ShareExtension' do
    use_frameworks!
    pod 'SnapKit', '0.22.0'
    pod 'Then', '1.0.3'
    pod 'RealmSwift', '1.0.2'
end
