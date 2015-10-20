//
//  MNNavigationController.swift
//  17-WeChat
//
//  Created by 张明楠 on 15/10/10.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit

class MNNavigationController: UINavigationController {


    override func viewDidLoad() {
        super.viewDidLoad()
        let bar = UINavigationBar.appearance()
        bar.setBackgroundImage(UIImage(named: "bottomTipsIcon_bg"), forBarMetrics: UIBarMetrics.Default)
        bar.tintColor = UIColor.whiteColor()
        let barTextAttrs = [NSForegroundColorAttributeName:UIColor.whiteColor(),NSFontAttributeName:UIFont.systemFontOfSize(20)]
        bar.titleTextAttributes = barTextAttrs

        let item = UIBarButtonItem.appearance()

        let disableTextAttrs = [NSForegroundColorAttributeName:UIColor.whiteColor(),NSFontAttributeName:UIFont.systemFontOfSize(14)]
        item.setTitleTextAttributes(disableTextAttrs, forState: UIControlState.Disabled)

        let itemTextAttrs = [NSForegroundColorAttributeName:UIColor.whiteColor(),NSFontAttributeName:UIFont.systemFontOfSize(14)]
        item.setTitleTextAttributes(itemTextAttrs, forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }

        super.pushViewController(viewController, animated: animated)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
