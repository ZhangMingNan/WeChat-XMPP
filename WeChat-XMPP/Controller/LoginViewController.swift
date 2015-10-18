//
//  LoginViewController.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/15.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var pwd: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBAction func login(sender: AnyObject) {

        MNAccount.shared.currentUserName = self.userName.text ?? ""
        MNAccount.shared.currentUserPwd = self.pwd.text ?? ""
        IMClient.shared.connect(ConnectType.Login) { (type) -> Void in
            if type == ConnectResponseType.LoginSuccessed {
                app.keyWindow?.rootViewController = MNTabBarController()
            }
        }

    }

    deinit{
        print("loginVC d")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
