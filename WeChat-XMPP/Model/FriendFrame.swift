//
//  FriendFrame.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/22.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit

let friendFrameNameFont:CGFloat = 16
let friendFrameLastMessageFont:CGFloat = 12
let friendFrameTimeFont:CGFloat = 12
class FriendFrame: NSObject {
    var iconView:CGRect = CGRectZero
    var nameLabel:CGRect = CGRectZero
    var lastMessageLabel:CGRect = CGRectZero
    var timeLabel:CGRect = CGRectZero
    var friend:Friend?{
        didSet{
            self.iconView = CGRectMake(10, 10, 45, 45)
            let nameSize = friend?.name!.size(UIFont.systemFontOfSize(friendFrameNameFont),maxWidth:textMaxW)
            self.nameLabel = CGRectMake(CGRectGetMaxX(self.iconView) + CGFloat(10),10,nameSize!.width, nameSize!.height)
            let lastMessageSize = friend?.lastMessage!.size(UIFont.systemFontOfSize(friendFrameLastMessageFont),maxWidth:textMaxW)
            self.lastMessageLabel = CGRectMake(CGRectGetMaxX(self.iconView) + 10, CGRectGetMaxY(self.nameLabel) + 10, lastMessageSize!.width, lastMessageSize!.height)
            let timeSize = friend?.time?.size(UIFont.systemFontOfSize(friendFrameTimeFont),maxWidth:textMaxW)
            self.timeLabel = CGRectMake(screenWidth - 10 - timeSize!.width, 10, timeSize!.width, timeSize!.height)
        }
    }
}
