//
//  MNChatViewController+ImagePicker.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/19.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit
import UpYunSDK
import XMPPFramework


let baseUrl = "http://wechat-xmpp.b0.upaiyun.com/"

extension MNChatViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    self.dismissViewControllerAnimated(true) { () -> Void in
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage;
        let data = UIImagePNGRepresentation(img)
        let upyun = UpYun(bucket: "wechat-xmpp", andPassCode: "+DzgjSfu9nsoHO52mJ5djtU9NTM=")!

        //显示到表格中,同时显示上传进度
        upyun.uploadFileWithData(data!, useSaveKey: "WeChat-XMPP/\(NSDate().timeIntervalSince1970)\(arc4random()).png", completion: { (result, arr, error) -> Void in
            let imageUrl = arr["url"] as! String
            let imageHeight =  CGFloat((arr["image-height"] as! NSNumber).floatValue)
            let imagewidth =  CGFloat((arr["image-width"] as! NSNumber).floatValue)

            let message =  XMPPMessage(type: "chat", to: self.friendJid)
            let imgInfo = ["url": imageUrl, "height": imageHeight, "width": imagewidth]
            do{
                 let jsonData =  try NSJSONSerialization.dataWithJSONObject(imgInfo, options:NSJSONWritingOptions.init(rawValue: 0))
                let json = String(data: jsonData, encoding: NSUTF8StringEncoding)
                message.addAttributeWithName("imageInfo", stringValue: json!)
                message.addBody(">")
                IMClient.shared.stream?.sendElement(message)
            }catch{
                print("解析失败")
            }

        })

        }


    }
}
