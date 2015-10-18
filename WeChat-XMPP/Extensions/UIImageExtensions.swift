//
//  UIImageExtensions.swift
//  15-MeiTuan
//
//  Created by 张明楠 on 15/8/16.
//  Copyright (c) 2015年 张明楠. All rights reserved.
//

import UIKit
extension UIImage{
    class func resizableImageWithName(name:String)->UIImage?{

        let originImage = UIImage(named: name)
        if let oimg = originImage {
            let w = oimg.size.width * 0.5
            let h = oimg.size.height * 0.5
            let newImage = originImage?.resizableImageWithCapInsets(UIEdgeInsetsMake(h, w, h, w), resizingMode: UIImageResizingMode.Stretch)
            return newImage!
        }
        return  nil
    }
}