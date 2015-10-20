//
//  AppDelegate.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/15.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit
let app = UIApplication.sharedApplication()

let screenWidth = UIScreen.mainScreen().bounds.width
let screenHeight = UIScreen.mainScreen().bounds.height


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        if MNAccount.shared.isLogin {
            IMClient.shared.connect(ConnectType.Login
                , block: { (type) -> Void in
            })
            self.window?.rootViewController = MNTabBarController()
        }else{
            let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
            self.window?.rootViewController = loginVC

        }
        self.window?.makeKeyAndVisible()



      //  var xmpp = DDXMLDocument(XMLString: "", options: 0)

        return true
    }

}

