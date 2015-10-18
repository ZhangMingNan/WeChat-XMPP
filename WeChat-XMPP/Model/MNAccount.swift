//
//  MNAccount.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/15.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit


enum PropertyKey : String {
    case CurrentUserName = "currentUserName"
    case CurrentUserPwd = "currentUserPwd"
    case IsLogin = "isLogin"
}
class MNAccount {

    var currentUserName = ""
    var currentUserPwd = ""
    var isLogin = false

    static let  shared = MNAccount()
    private init(){
        let def = NSUserDefaults.standardUserDefaults()
        self.currentUserName = def.objectForKey(PropertyKey.CurrentUserName.rawValue) as? String ?? ""
        self.currentUserPwd = def.objectForKey(PropertyKey.CurrentUserPwd.rawValue) as? String ?? ""
        self.isLogin = def.objectForKey(PropertyKey.IsLogin.rawValue) as? Bool ?? false
    }

    //持久化账户信息
    func synchronize(){
        let def = NSUserDefaults.standardUserDefaults()
        def.setObject(self.currentUserName, forKey: PropertyKey.CurrentUserName.rawValue)
        def.setObject(self.currentUserPwd, forKey: PropertyKey.CurrentUserPwd.rawValue)
        def.setBool(self.isLogin, forKey: PropertyKey.IsLogin.rawValue)
        def.synchronize()
    }
}

