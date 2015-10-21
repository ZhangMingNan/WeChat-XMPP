//
//  ImageMessage.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/20.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit

enum OrentationType {
    case Vertical
    case Horizontal
}

class ImageMessage :Message{

    var url:String?

    //照片的原始大小
    var height:CGFloat = 0
    var width:CGFloat = 0

    var orientation:OrentationType {
        get{

            return height > width ? .Vertical : .Horizontal
        }
    }
}
