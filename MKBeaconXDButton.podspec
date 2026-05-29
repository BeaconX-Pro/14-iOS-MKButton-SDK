Pod::Spec.new do |s|
  s.name             = 'MKBeaconXDButton'
  s.version          = '0.0.3'
  s.summary          = 'A short description of MKBeaconXDButton.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/aadyx2007@163.com/MKBeaconXDButton'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aadyx2007@163.com' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/aadyx2007@163.com/MKBeaconXDButton.git', :tag => s.version.to_s }
  s.ios.deployment_target = '14.0'
  
  # ========== 资源文件 ==========
  s.resource_bundles = {
    'MKBeaconXDButton' => ['MKBeaconXDButton/Assets/*.png']
  }
  
  # ========== ConnectManager 层 ==========
  s.subspec 'ConnectManager' do |ss|
    ss.source_files = 'MKBeaconXDButton/Classes/ConnectManager/**/*.{h,m}'
    ss.dependency 'MKBeaconXDButton/SDK'
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  # ========== CTMediator 路由层 ==========
  s.subspec 'CTMediator' do |ss|
    ss.source_files = 'MKBeaconXDButton/Classes/CTMediator/**/*.{h,m}'
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'CTMediator'
  end
  
  # ========== SDK 层（客户只需要这个）==========
  # 注意：SDK 只依赖必要的蓝牙库，不依赖任何 UI 库
  s.subspec 'SDK' do |ss|
    ss.source_files = 'MKBeaconXDButton/Classes/SDK/**/*.{h,m}'
    ss.dependency 'MKBaseBleModule'
  end
  
  # ========== Target 层 ==========
  s.subspec 'Target' do |ss|
    ss.source_files = 'MKBeaconXDButton/Classes/Target/**/*.{h,m}'
    ss.dependency 'MKBeaconXDButton/Functions'
  end
  
  # ========== Expand 层 ==========
  s.subspec 'Expand' do |ss|
    ss.source_files = 'MKBeaconXDButton/Classes/Expand/**/*.{h,m}'
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
  end
  
  # ========== Functions 层（包含所有页面，客户不需要）==========
  s.subspec 'Functions' do |ss|
    ss.source_files = 'MKBeaconXDButton/Classes/Functions/**/*.{h,m}'
    
    ss.dependency 'MKBeaconXDButton/SDK'
    ss.dependency 'MKBeaconXDButton/CTMediator'
    ss.dependency 'MKBeaconXDButton/ConnectManager'
    ss.dependency 'MKBeaconXDButton/Expand'
    ss.dependency 'MKBeaconXCustomUI'
    ss.dependency 'HHTransition'
    ss.dependency 'MLInputDodger'
    ss.dependency 'iOSDFULibrary', '4.13.0'
  end
  
end
