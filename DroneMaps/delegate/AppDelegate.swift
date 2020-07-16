//
//  AppDelegate.swift
//  DroneMaps
//
//  Created by Артем Стратиенко on 22.03.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import UIKit
import NMAKit

    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?

        
       // reg info
          let registrationData =
              (appId: "v6mF9RinlQEUA8F1Aasz",
               appCode: "hxcXikkyoJkFzfhoTukwJw",
               licenseKey: "h5AEyg9yWv3VAlGZFEgv7kmj7xwWR0w8pzp4iSSKvX6oz0GUQglvAf/kGW7CR0OeOwQ4m78c3SCIaIjuMS2HoaMw0BokRE37rP29SqzqLu7okkMqVFinYce6JB935qohawv57hXgq7ugpjiFoAhoDg5sQKDH7H2iP90s54IizoyDe7c51K264qgPTxT3yKRDGcgRYYMWnLjVc6v0Mkjoo0e+W4lktyCfKkOJ2Sn6ZUoJ9vC4M94454Up2obipeDoX078yxn3fReRDPJxVNdksT7bXaCl+r3wGUnREZrAJq5aBtWunk/+NL2GzFuN98T0pJN5PFDVBOZd9UDYpLFXQxccdr/ZzRmjol+4CCLHk8lsw5aTcBY8qJy5pZnTk/irLnEcq+fC8IxKhXeYuDKKtODrhtFyEcDodlZm7B3QRpFGDmU3Fpmcct1ERB7NZDetWSd0h0oHU1UTWRaFLds8VCB9HKmMTtR5Qm5IxF12ZeQ7kQcSOBBK73VRMPwn+uyeaiqzBYiML152zHu3RQDjjf2pi14ynoRgqJ1mQM/JP1EVW7Z6OqD9qTRjYWZreQVdhWm3Pz7qMpY7+nOcFCECkmWGUWDh4lVvFpx/FtMdcwdFIGkxZhJnJADTjJLlQCyVn1PI7hxX8evQTklwFr11+MyofwcWifESSs0dIAIQeWs="
          )
       func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
           NMAApplicationContext.setAppId(registrationData.appId, appCode: registrationData.appCode, licenseKey: registrationData.licenseKey)
     //   let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "CustomLaunchScreen", bundle: nil)
     //   let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "LaunchScreenViewController") as! LaunchScreenViewController
     //   self.window = UIWindow(frame: UIScreen.main.bounds)
     //   self.window?.rootViewController = initialViewControlleripad
     //   self.window?.makeKeyAndVisible()
           return true
       }
       
        @available(iOS 13.0, *)
       func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
              // Called when a new scene session is being created.
              // Use this method to select a configuration to create the new scene with.
              return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
          }

        @available(iOS 13.0, *)
        func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
              // Called when the user discards a scene session.
              // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
              // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
          }
        
    }

