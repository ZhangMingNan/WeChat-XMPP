//
//  MessageFrame.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/15.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit

class TextMessageFrame:MessageFrame {

        var name:CGRect?
        var text:CGRect?
    var message :TextMessage?{
        didSet{
                    let textSize  = message!.text?.size(UIFont.systemFontOfSize(textFont), maxSize: CGSizeMake(textMaxW, CGFloat.max))
                    // 我发送的
                    if message!.type == 1 {
                        icon = CGRectMake(screenWidth - padding - iconW,padding, iconW, iconW)
                    } else {
                        self.icon = CGRectMake(padding,padding, iconW, iconW)
                    }


                    if message!.type == 1 {
                        self.text = CGRectMake(screenWidth - padding * 2 - iconW - textSize!.width - 40, padding ,textSize!.width + 40, textSize!.height + 40)
                    } else if message!.type == 0 {

                        self.text = CGRectMake(CGRectGetMaxX(self.icon!) + padding, padding ,textSize!.width + 40,textSize!.height + 40)
                    }
            cellHeight = CGRectGetMaxY(self.text!)
        }
    }
}