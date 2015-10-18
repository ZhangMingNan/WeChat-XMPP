//
//  LoginViewController.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/15.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit
    let nameFont:CGFloat = 15
    let textFont:CGFloat = 13
    let padding:CGFloat  = 8
    let textPadding:CGFloat  = 2
    let iconW:CGFloat = 44
    let textMaxW :CGFloat = 200
class MessageFrame {
        var icon:CGRect?
        var name:CGRect?
        var text:CGRect?
    var cellHeight:CGFloat = 0
    var messageBean:Message?
    var message :Message{
        get{
                return self.messageBean!
        }
        set{
            self.messageBean = newValue
                    //let nameSize = newValue.name?.size(UIFont.systemFontOfSize(nameFont), maxSize: CGSizeMake(textMaxW, CGFloat.max))
                    let textSize  = newValue.text?.size(UIFont.systemFontOfSize(textFont), maxSize: CGSizeMake(textMaxW, CGFloat.max))
                    // 我发送的
                    if newValue.type == 1 {
                        icon = CGRectMake(screenWidth - padding - iconW,padding, iconW, iconW)
                    } else {
                        self.icon = CGRectMake(padding,padding, iconW, iconW)
                    }
//                    if newValue.type == 1 {
//                        self.name = CGRectMake(screenWidth - padding - iconW - padding - nameSize!.width, padding,nameSize!.width,nameSize!.height)
//                    } else {
//                        self.name = CGRectMake(CGRectGetMaxX(self.icon!) + padding, padding,nameSize!.width,nameSize!.height)
//                    }

                    if newValue.type == 1 {
                        self.text = CGRectMake(screenWidth - padding * 2 - iconW - textSize!.width - 40, padding ,textSize!.width + 40, textSize!.height + 40)
                    } else if newValue.type == 0 {

                        self.text = CGRectMake(CGRectGetMaxX(self.icon!) + padding, padding ,textSize!.width + 40,textSize!.height + 40)
                    }
            cellHeight = CGRectGetMaxY(self.text!)
        }
    }
}