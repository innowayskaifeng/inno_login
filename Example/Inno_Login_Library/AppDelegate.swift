//
//  AppDelegate.swift
//  InnowaysLibrary
//
//  Created by Elluminati on 11/07/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import Inno_Login


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var loginC:KFLoginController?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        
        //login 初始化
        
        //kit init
        loginC = KFLoginController()
        loginC?.delegate = self
        
        /** custom style ,not setting will use the Default*/
        loginC?.logoThemeImage = UIImage(named: "Icon-App-20x20")
        loginC?.headerImage = UIImage(named: "Icon-App-20x20")
        loginC?.headerImageURL = "https://ss3.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=2512fa1075310a55db24d8f487444387/09fa513d269759eeef490028befb43166d22df3c.jpg"
        loginC?.backgroundImage = UIImage(named: "Icon-App-20x20")
        loginC?.rememberTouchIDTextColor = UIColor.red
        loginC?.rememberTouchIDTextColorHighlighted = UIColor.red
        loginC?.switchUserTextColor = UIColor.red
        loginC?.signinBackgroundColor = UIColor.red
        loginC?.signinTextColor = UIColor.red
        loginC?.promptSubtitleTextColor = UIColor.red
        loginC?.fotgotPasswordTextColor = UIColor.red
        loginC?.fotgotPasswordHidden = false
        
        loginC?.exclamationBackgroundImage = UIImage(named: "Icon-App-20x20")
        loginC?.x_safeBackgroundImage = UIImage(named: "Icon-App-20x20")
        
        loginC?.turnOnPrivary = false
        loginC?.privaryAgreeBackgroundColor = UIColor.red
        loginC?.privaryCompanyText = "A-AAa"
        loginC?.privaryTitleText = "Internet Protocol"
        loginC?.privaryContentText = "An NSAttributedString object manages character strings\nand associated sets of attributes (for example, font and kerning)that apply to individual characters or ranges of characters in the string.\nand associated sets of attributes (for example, font and kerning)that apply to individual characters or ranges of characters in the string.\nand associated sets of attributes (for example, font and kerning)that apply to individual characters or ranges of characters in the string.\nand associated sets of attributes (for example, font and kerning)that apply to individual characters or ranges of characters in the string.\nand associated sets of attributes (for example, font and kerning)that apply to individual characters or ranges of characters in the string.\nand associated sets of attributes (for example, font and kerning)that apply to individual characters or ranges of characters in the string.\nand associated sets of attributes (for example, font and kerning)that apply to individual characters or ranges of characters in the string.\nand associated sets of attributes (for example, font and kerning)that apply to individual characters or ranges of characters in the string.\nand associated sets of attributes (for example, font and kerning)that apply to individual characters or ranges of characters in the string.\nand associated sets of attributes (for example, font and kerning)that apply to individual characters or ranges of characters in the string.\nand associated sets of attributes (for example, font and kerning)that apply to individual characters or ranges of characters in the string.\nand associated sets of attributes (for example, font and kerning)that apply to individual characters or ranges of characters in the string.\nand associated sets of attributes (for example, font and kerning)that apply to individual characters or ranges of characters in the string."
        
        
        loginC?.logoImageAspect = 5.0
        
        self.window?.rootViewController = loginC
        self.window?.makeKeyAndVisible()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


extension AppDelegate:KFLoginControlerDelagete {
    
    //用户响应登录 和 TouchID 响应
    func loginResponse(username: String, password: String) -> Bool {
        
        // 验证用户名密码
        print("username:\(username) + password:\(password)")
        
         loginC?.authentication(true,"kaifeng,wu")
        
        return true
    }
    
    func accountAuthenticationStatus(status: Bool) {
        
        print("username: + password: 认证状态 - \(status)")
        
        if status {
            
            loginC?.headerImageURL = "https://ss3.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=2512fa1075310a55db24d8f487444387/09fa513d269759eeef490028befb43166d22df3c.jpg"
            loginC?.present(UINavigationController(rootViewController: UIViewController()), animated: true, completion: nil)
            
        }
        
    }
    
}
 

