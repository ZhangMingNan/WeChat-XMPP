//
//  LoginViewController.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/15.
//  Copyright © 2015年 张明楠. All rights reserved.
//


import Foundation

struct Message {

    var icon:NSData?

    var name:String?

    var text:String?
    //1:我发送的 0 其他人发送的
    var type:Int = -1
}