//
//  SharemoreView.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/18.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit

protocol SharemoreViewDelegate {
    func click()
}

class SharemoreView: UIView {
    var delegate:SharemoreViewDelegate?

    class func sharemoreView()->SharemoreView {
        let v =  NSBundle.mainBundle().loadNibNamed("SharemoreView", owner: nil, options: nil).first as! SharemoreView
        return v
    }

    @IBAction func clickedButton(sender: UIButton) {
        delegate?.click()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let total = self.subviews.count
        let margin = CGFloat((screenWidth - 59 * 4) / 5)
        for  i in 0..<total {
            let row = CGFloat(i / 4)
            let loc = CGFloat( i % 4)
            let x = margin + (margin + 59) * loc;
            let y = margin + (margin + 59) * row;
            self.viewWithTag(11+i)?.frame = CGRectMake(x, y, 59, 59)

        }

    }
}