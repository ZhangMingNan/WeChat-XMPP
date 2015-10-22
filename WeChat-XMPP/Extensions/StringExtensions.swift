//
//  StringExtensions.swift
//  15-MeiTuan
//
//  Created by 张明楠 on 15/8/18.
//  Copyright (c) 2015年 张明楠. All rights reserved.
//
import UIKit
extension String {
    func size(font:UIFont,maxSize:CGSize)->CGSize {
        return   self.boundingRectWithSize(
            maxSize,
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [ NSFontAttributeName : font ],
            context: nil).size
    }
    func size(font:UIFont,maxWidth:CGFloat)->CGSize {
        let maxSize = CGSizeMake(maxWidth, CGFloat.max)
        return   self.boundingRectWithSize(
            maxSize,
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [ NSFontAttributeName : font ],
            context: nil).size
    }
}
