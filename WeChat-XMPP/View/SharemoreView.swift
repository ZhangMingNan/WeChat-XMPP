//
//  SharemoreView.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/18.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit

class SharemoreView: UIView {
    class func sharemoreView()->SharemoreView {
        let v =  NSBundle.mainBundle().loadNibNamed("SharemoreView", owner: nil, options: nil).first as! SharemoreView
        return v
    }

    override func layoutSubviews() {
        super.layoutSubviews()


        let margin = CGFloat((screenWidth - 59 * 4) / 5)
        for  i in 0...5 {
            let row = CGFloat(i / 4)
            let loc = CGFloat( i % 4)
            let x = margin + (margin + 59) * loc;
            let y = margin + (margin + 59) * row;
            self.viewWithTag(11+i)?.frame = CGRectMake(x, y, 59, 59)

        }
    }
}