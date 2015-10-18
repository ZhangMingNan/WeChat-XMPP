//
//  ViewController.swift
//  WeChat-XMPP
//
//  Created by 张明楠(QQ:1007350771) on 15/10/15.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注销", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")


    }

    func logout(){
        IMClient.shared.loutout { () -> Void in
            //在这里显示登陆界面
            let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
            app.keyWindow?.rootViewController = loginVC
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

