//
//  ImageMessageFrame.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/20.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit
let picWidth:CGFloat  = 150
let picHeight:CGFloat = 200
class ImageMessageFrame:MessageFrame {
    var image:CGRect?
    var imageMessage:ImageMessage?{
        didSet{
            if let message = self.imageMessage {
                if message.type == 1 {
                    icon = CGRectMake(screenWidth - padding - iconW,padding, iconW, iconW)
                } else {
                    self.icon = CGRectMake(padding,padding, iconW, iconW)
                }
                //设置发送图片的位置
                if message.type == 1 {
                    //垂直显示图片
                    if imageMessage?.height > picHeight || imageMessage?.width > picWidth {
                        if message.orientation == .Vertical {
                            image = CGRectMake(screenWidth - padding * 2 - iconW - picWidth,padding,picWidth,picHeight)
                        }else {
                            //水平显示图片
                            image = CGRectMake(screenWidth - padding * 2 - iconW - picHeight,padding,picHeight,picWidth)
                        }
                    }else {
                        print(imageMessage!.height)
                            image = CGRectMake(screenWidth - padding * 2 - iconW - imageMessage!.width,padding,imageMessage!.width,imageMessage!.height)
                    }

                } else {
                                        if imageMessage?.height > picHeight || imageMessage?.width > picWidth {
                    //
                    //垂直显示图片
                    if message.orientation == .Vertical {
                        image = CGRectMake(CGRectGetMaxX(self.icon!) + padding,padding,picWidth,picHeight)
                    }else {
                    //水平显示图片
                        image = CGRectMake(CGRectGetMaxX(self.icon!) + padding,padding,picHeight,picWidth)
                    }
                    }else {
                        image = CGRectMake(CGRectGetMaxX(self.icon!) + padding,padding,imageMessage!.width,imageMessage!.height)

                    }
                }
            cellHeight = CGRectGetMaxY(self.image!)
            }
        }
    }
}












