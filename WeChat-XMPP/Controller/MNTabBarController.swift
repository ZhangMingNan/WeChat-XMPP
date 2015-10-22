//
//  MNTabBarController.swift
//  17-WeChat
//
//  Created by 张明楠 on 15/10/10.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit

class MNTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {

        let mainframe = MessageLoggingController()
        settingController(mainframe, title: "微信", imageName: "tabbar_mainframe")

        let contacts = RosterViewController()
        settingController(contacts, title: "通讯录", imageName: "tabbar_contacts")

        let discover = MessageLoggingController()
        settingController(discover, title: "发现", imageName: "tabbar_discover")

        let me = MessageLoggingController()
        settingController(me, title: "我", imageName: "tabbar_me")

        self.addChildViewController(MNNavigationController(rootViewController: mainframe))
        self.addChildViewController(MNNavigationController(rootViewController: contacts))
        self.addChildViewController(MNNavigationController(rootViewController: discover))
        self.addChildViewController(MNNavigationController(rootViewController: me))
        self.tabBar.backgroundImage = UIImage.resizableImageWithName("tabbarBkg")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func settingController(controller:UIViewController,title:String,imageName:String){
        controller.title = title
        controller.tabBarItem.image = UIImage(named: imageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        controller.tabBarItem.selectedImage =  UIImage(named: "\(imageName)HL")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

        let textAttrs = [NSForegroundColorAttributeName:UIColor.grayColor(),NSFontAttributeName:UIFont.systemFontOfSize(9.5)]
        let selectTextAttrs = [NSForegroundColorAttributeName:UIColor(red: 0/255, green: 174/255, blue: 16/255, alpha: 1),NSFontAttributeName:UIFont.systemFontOfSize(9.5)]
        controller.tabBarItem.setTitleTextAttributes(textAttrs, forState: UIControlState.Normal)
        controller.tabBarItem.setTitleTextAttributes(selectTextAttrs, forState: UIControlState.Selected)
        // controller.tabBarItem.setTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -3))
    }

}
