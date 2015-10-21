//
//  ImageCell.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/20.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit
import Kingfisher
let senderBG = "SenderAppNodeBkg"
class ImageCell: UITableViewCell {
    var imageMessageView:UIImageView!
    var iconView:UIImageView!
    var imageMessageFrame:ImageMessageFrame?{
        didSet{
            print(NSStringFromCGRect((imageMessageFrame?.icon!)!))
            if let imgFrame = imageMessageFrame {
                self.imageMessageView.frame = imgFrame.image!
                self.imageMessageView.image =
                    UIImage(data: NSData(contentsOfURL: NSURL(string:imgFrame.imageMessage!.url!)!)!)
                self.iconView.frame = imgFrame.icon!
                self.iconView.image  = UIImage(data: imgFrame.imageMessage!.icon!)

            }

        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func cell(tableView:UITableView)->ImageCell{
        let id = "imageMessageId"
        var cell = tableView.dequeueReusableCellWithIdentifier(id) as? ImageCell

        if cell == nil {
            cell = ImageCell(style: UITableViewCellStyle.Default, reuseIdentifier:id)
        }
        return cell!
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.imageMessageView = UIImageView()
        self.iconView = UIImageView()
        self.contentView.addSubview(self.imageMessageView)
        self.contentView.addSubview(self.iconView)
        self.backgroundColor = UIColor.clearColor()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
