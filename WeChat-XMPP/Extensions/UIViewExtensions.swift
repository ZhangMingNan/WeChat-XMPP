//
//  UIViewExtensions.swift
//  15-MeiTuan
//
//  Created by 张明楠 on 15/8/16.
//  Copyright (c) 2015年 张明楠. All rights reserved.
//

import UIKit
extension UIView {
    func setX(x:CGFloat){
        var frame = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    func setY(y:CGFloat){
        var frame = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    func x()->CGFloat{
        return self.frame.origin.x
    }
    func y()->CGFloat{
        return self.frame.origin.y
    }
    func setCenterX(centerX:CGFloat){
        var center = self.center
        center.x = centerX
        self.center = center
    }
    func centerX()->CGFloat{
        return self.center.x
    }
    func setCenterY(centerY:CGFloat){
        var center = self.center
        center.y = centerY
        self.center = center
    }
    func centerY()->CGFloat{
        return self.center.y
    }

    func setWidth(width:CGFloat){
        var frame = self.frame
        frame.size.width = width
        self.frame = frame
    }
    func width()->CGFloat{
        return self.frame.size.width
    }

    func setHeight(height:CGFloat){
        var frame = self.frame
        frame.size.height = height
        self.frame = frame
    }
    func height()->CGFloat{
        return self.frame.size.height
    }

    func setSize(size:CGSize){
        var frame = self.frame
        frame.size = size
        self.frame = frame
    }
    func size()->CGSize{
        return self.frame.size
    }
    func setOrigin(origin:CGPoint){
        var frame = self.frame
        frame.origin = origin
        self.frame = frame
    }
    func origin()->CGPoint{
        return self.frame.origin
    }
}