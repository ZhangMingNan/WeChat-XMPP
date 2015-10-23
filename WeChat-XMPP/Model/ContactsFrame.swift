//
//  ContactsFrame.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/22.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit

class ContactsFrame {

    var iconView:CGRect = CGRectZero
    var nameLabel:CGRect = CGRectZero
    var cellHeight:CGFloat = 0
    var contacts:Contacts?{
        didSet{
            self.iconView = CGRectMake(10, 10, 45, 45)
            self.nameLabel = CGRectMake(CGRectGetMaxX(self.iconView) + 10, 10, 100, 15)
        }
    }
}
