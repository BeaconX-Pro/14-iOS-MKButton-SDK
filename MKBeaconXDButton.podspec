#
# Be sure to run `pod lib lint MKBeaconXDButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKBeaconXDButton'
  s.version          = '0.0.1'
  s.summary          = 'A short description of MKBeaconXDButton.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/aadyx2007@163.com/MKBeaconXDButton'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aadyx2007@163.com' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/aadyx2007@163.com/MKBeaconXDButton.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '14.0'
  
  s.resource_bundles = {
    'MKBeaconXDButton' => ['MKBeaconXDButton/Assets/*.png']
  }
    
    s.subspec 'ConnectManager' do |ss|
      ss.source_files = 'MKBeaconXDButton/Classes/ConnectManager/**'
      
      ss.dependency 'MKBeaconXDButton/SDK'
      
      ss.dependency 'MKBaseModuleLibrary'
    end
    
    s.subspec 'CTMediator' do |ss|
      ss.source_files = 'MKBeaconXDButton/Classes/CTMediator/**'
      
      ss.dependency 'MKBaseModuleLibrary'
      
      ss.dependency 'CTMediator'
    end
    
    s.subspec 'SDK' do |ss|
      ss.source_files = 'MKBeaconXDButton/Classes/SDK/**'
      
      ss.dependency 'MKBaseBleModule'
    end
    
    s.subspec 'Target' do |ss|
      ss.source_files = 'MKBeaconXDButton/Classes/Target/**'
      
      ss.dependency 'MKBeaconXDButton/Functions'
    end
    
    s.subspec 'Expand' do |ss|
      ss.subspec 'View' do |sss|
        sss.subspec 'NTPickerView' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Expand/View/NTPickerView/**'
        end
        sss.subspec 'DeviceIDCell' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Expand/View/DeviceIDCell/**'
        end
      end
      
      ss.dependency 'MKBaseModuleLibrary'
      ss.dependency 'MKCustomUIModule'
    end
    
    
    
    s.subspec 'Functions' do |ss|
      
      ss.subspec 'AboutPage' do |sss|
        sss.subspec 'Controller' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/AboutPage/Controller/**'
        end
      end
      
      ss.subspec 'AccelerationPage' do |sss|
        sss.subspec 'Controller' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/AccelerationPage/Controller/**'
        
          ssss.dependency 'MKBeaconXDButton/Functions/AccelerationPage/Model'
          ssss.dependency 'MKBeaconXDButton/Functions/AccelerationPage/View'
        
        end
      
        sss.subspec 'Model' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/AccelerationPage/Model/**'
        end
      
        sss.subspec 'View' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/AccelerationPage/View/**'
        end
      end
      
      ss.subspec 'AlarmEventPage' do |sss|
        sss.subspec 'Controller' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmEventPage/Controller/**'
        
          ssss.dependency 'MKBeaconXDButton/Functions/AlarmEventPage/Model'
          ssss.dependency 'MKBeaconXDButton/Functions/AlarmEventPage/View'
        end
      
        sss.subspec 'View' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmEventPage/View/**'
        end
        
        sss.subspec 'Model' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmEventPage/Model/**'
        end
      end
      
      ss.subspec 'AlarmModeConfigPage' do |sss|
        
        sss.subspec 'Defines' do |ssss|
            ssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmModeConfigPage/Defines/**'
        end
        
        sss.subspec 'Model' do |ssss|
            ssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmModeConfigPage/Model/**'
        end
        
        sss.subspec 'V1' do |ssss|
          ssss.subspec 'Controller' do |sssss|
            sssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmModeConfigPage/V1/Controller/**'
          
            sssss.dependency 'MKBeaconXDButton/Functions/AlarmModeConfigPage/V1/Model'
            
            sssss.dependency 'MKBeaconXDButton/Functions/AlarmModeConfigPage/View'
            
            sssss.dependency 'MKBeaconXDButton/Functions/AlarmNotiTypePage/Controller'
          end
          ssss.subspec 'Model' do |sssss|
            sssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmModeConfigPage/V1/Model/**'
            
            sssss.dependency 'MKBeaconXDButton/Functions/AlarmModeConfigPage/Model'
          end
        end
        
        sss.subspec 'V2' do |ssss|
          ssss.subspec 'Controller' do |sssss|
            sssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmModeConfigPage/V2/Controller/**'
          
            sssss.dependency 'MKBeaconXDButton/Functions/AlarmModeConfigPage/V2/Model'
            
            sssss.dependency 'MKBeaconXDButton/Functions/AlarmModeConfigPage/View'
            sssss.dependency 'MKBeaconXDButton/Functions/AlarmModeConfigPage/Defines'
          end
          ssss.subspec 'Model' do |sssss|
            sssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmModeConfigPage/V2/Model/**'
            sssss.dependency 'MKBeaconXDButton/Functions/AlarmModeConfigPage/Model'
          end
        end
      
        sss.subspec 'View' do |ssss|
          
          ssss.subspec 'AbnormalInactivityTimeCell' do |sssss|
            sssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmModeConfigPage/View/AbnormalInactivityTimeCell/**'
          end
          
          ssss.subspec 'SlotBeaconCell' do |sssss|
            sssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmModeConfigPage/View/SlotBeaconCell/**'
          end
          
          ssss.subspec 'SlotFramePickCell' do |sssss|
            sssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmModeConfigPage/View/SlotFramePickCell/**'
            
            sssss.dependency 'MKBeaconXDButton/Functions/AlarmModeConfigPage/Defines'
          end
          
          ssss.subspec 'SlotParamCell' do |sssss|
            sssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmModeConfigPage/View/SlotParamCell/**'
            
            sssss.dependency 'MKBeaconXDButton/Functions/AlarmModeConfigPage/Defines'
          end
          
          ssss.subspec 'SlotUIDCell' do |sssss|
            sssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmModeConfigPage/View/SlotUIDCell/**'
          end
          
          ssss.subspec 'TxPowerCell' do |sssss|
            sssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmModeConfigPage/View/TxPowerCell/**'
          end
          
          ssss.subspec 'TriggerTypeClickCell' do |sssss|
            sssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmModeConfigPage/View/TriggerTypeClickCell/**'
          end
          
          ssss.subspec 'AlarmTypePickCell' do |sssss|
            sssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmModeConfigPage/View/AlarmTypePickCell/**'
          end
          
        end
        
        
      end
      
      ss.subspec 'AlarmNotiTypePage' do |sss|
        sss.subspec 'Controller' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmNotiTypePage/Controller/**'
        
          ssss.dependency 'MKBeaconXDButton/Functions/AlarmNotiTypePage/Model'
        end
      
        sss.subspec 'Model' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmNotiTypePage/Model/**'
        end
      end
      
      ss.subspec 'AlarmPage' do |sss|
        sss.subspec 'Controller' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmPage/Controller/**'
        
          ssss.dependency 'MKBeaconXDButton/Functions/AlarmPage/Model'
          
          ssss.dependency 'MKBeaconXDButton/Functions/AlarmModeConfigPage'
        end
      
        sss.subspec 'Model' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmPage/Model/**'
        end
      end
      
      ss.subspec 'AlarmPageV2' do |sss|
        sss.subspec 'Controller' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmPageV2/Controller/**'
        
          ssss.dependency 'MKBeaconXDButton/Functions/AlarmPageV2/Model'
          ssss.dependency 'MKBeaconXDButton/Functions/AlarmPageV2/View'
          
          ssss.dependency 'MKBeaconXDButton/Functions/AlarmNotiTypePage/Controller'
          ssss.dependency 'MKBeaconXDButton/Functions/AlarmModeConfigPage/V2/Controller'
        end
      
        sss.subspec 'Model' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmPageV2/Model/**'
        end
        
        sss.subspec 'View' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/AlarmPageV2/View/**'
        end
      end
      
      ss.subspec 'DeviceInfoPage' do |sss|
        sss.subspec 'Controller' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/DeviceInfoPage/Controller/**'
        
          ssss.dependency 'MKBeaconXDButton/Functions/DeviceInfoPage/Model'
        end
      
        sss.subspec 'Model' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/DeviceInfoPage/Model/**'
        end
      end
      
      ss.subspec 'DevicePage' do |sss|
        sss.subspec 'Controller' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/DevicePage/Controller/**'
        
          ssss.dependency 'MKBeaconXDButton/Functions/DevicePage/Model'
          
          ssss.dependency 'MKBeaconXDButton/Functions/QuickSwitchPage/Controller'
          ssss.dependency 'MKBeaconXDButton/Functions/UpdatePage/Controller'
          ssss.dependency 'MKBeaconXDButton/Functions/DeviceInfoPage/Controller'
        end
      
        sss.subspec 'Model' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/DevicePage/Model/**'
        end
      end
      
      ss.subspec 'DismissConfigPage' do |sss|
        sss.subspec 'Controller' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/DismissConfigPage/Controller/**'
        
          ssss.dependency 'MKBeaconXDButton/Functions/DismissConfigPage/Model'
        end
      
        sss.subspec 'Model' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/DismissConfigPage/Model/**'
        end
      end
      
      ss.subspec 'PowerSavePage' do |sss|
        sss.subspec 'Controller' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/PowerSavePage/Controller/**'
        
          ssss.dependency 'MKBeaconXDButton/Functions/PowerSavePage/Model'
          ssss.dependency 'MKBeaconXDButton/Functions/PowerSavePage/View'
        end
        
        sss.subspec 'View' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/PowerSavePage/View/**'
        end
      
        sss.subspec 'Model' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/PowerSavePage/Model/**'
        end
      end
      
      ss.subspec 'QuickSwitchPage' do |sss|
        sss.subspec 'Controller' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/QuickSwitchPage/Controller/**'
        
          ssss.dependency 'MKBeaconXDButton/Functions/QuickSwitchPage/Model'
        end
      
        sss.subspec 'Model' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/QuickSwitchPage/Model/**'
        end
      end
      
      ss.subspec 'RemoteReminderPage' do |sss|
        sss.subspec 'Controller' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/RemoteReminderPage/Controller/**'
        
          ssss.dependency 'MKBeaconXDButton/Functions/RemoteReminderPage/Model'
          ssss.dependency 'MKBeaconXDButton/Functions/RemoteReminderPage/View'
        end
      
        sss.subspec 'View' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/RemoteReminderPage/View/**'
        end
      
        sss.subspec 'Model' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/RemoteReminderPage/Model/**'
        end
      end
      
      ss.subspec 'ScanPage' do |sss|
        sss.subspec 'Controller' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/ScanPage/Controller/**'
        
          ssss.dependency 'MKBeaconXDButton/Functions/ScanPage/Model'
          ssss.dependency 'MKBeaconXDButton/Functions/ScanPage/View'
          ssss.dependency 'MKBeaconXDButton/Functions/ScanPage/Adopter'
          
          ssss.dependency 'MKBeaconXDButton/Functions/TabBarPage/Controller'
        end
      
        sss.subspec 'View' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/ScanPage/View/**'
          
          ssss.dependency 'MKBeaconXDButton/Functions/ScanPage/Model'
        end
      
        sss.subspec 'Model' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/ScanPage/Model/**'
        end
        
        sss.subspec 'Adopter' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/ScanPage/Adopter/**'
          
          ssss.dependency 'MKBeaconXDButton/Functions/ScanPage/Model'
          ssss.dependency 'MKBeaconXDButton/Functions/ScanPage/View'
        end
      end
      
      ss.subspec 'SettingPage' do |sss|
        sss.subspec 'Controller' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/SettingPage/Controller/**'
        
          ssss.dependency 'MKBeaconXDButton/Functions/SettingPage/Model'
          
          ssss.dependency 'MKBeaconXDButton/Functions/AlarmEventPage/Controller'
          ssss.dependency 'MKBeaconXDButton/Functions/DismissConfigPage/Controller'
          ssss.dependency 'MKBeaconXDButton/Functions/RemoteReminderPage/Controller'
          ssss.dependency 'MKBeaconXDButton/Functions/AccelerationPage/Controller'
          ssss.dependency 'MKBeaconXDButton/Functions/PowerSavePage/Controller'
        end
      
        sss.subspec 'Model' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/SettingPage/Model/**'
        end
      end
      
      ss.subspec 'TabBarPage' do |sss|
        sss.subspec 'Controller' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/TabBarPage/Controller/**'
          
          ssss.dependency 'MKBeaconXDButton/Functions/AlarmPage/Controller'
          ssss.dependency 'MKBeaconXDButton/Functions/AlarmPageV2/Controller'
          ssss.dependency 'MKBeaconXDButton/Functions/SettingPage/Controller'
          ssss.dependency 'MKBeaconXDButton/Functions/DevicePage/Controller'
        end
      end
      
      ss.subspec 'UpdatePage' do |sss|
        sss.subspec 'Controller' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/UpdatePage/Controller/**'
        
          ssss.dependency 'MKBeaconXDButton/Functions/UpdatePage/Model'
        end
      
        sss.subspec 'Model' do |ssss|
          ssss.source_files = 'MKBeaconXDButton/Classes/Functions/UpdatePage/Model/**'
        end
      
        sss.dependency 'iOSDFULibrary',   '4.13.0'
      end
      
      ss.dependency 'MKBeaconXDButton/SDK'
      ss.dependency 'MKBeaconXDButton/CTMediator'
      ss.dependency 'MKBeaconXDButton/ConnectManager'
      ss.dependency 'MKBeaconXDButton/Expand'
    
      ss.dependency 'MKBaseModuleLibrary'
      ss.dependency 'MKCustomUIModule'
      ss.dependency 'MKBeaconXCustomUI'
      ss.dependency 'HHTransition'
      ss.dependency 'MLInputDodger'
      
    end
    
end
