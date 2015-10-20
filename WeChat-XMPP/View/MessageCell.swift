//
//  IMClient.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/15.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    var iconView:UIImageView = UIImageView()
    var nameView:UILabel  = UILabel()
    var textView:UIButton = UIButton()
    var messFrame:TextMessageFrame? {
        didSet{
            self.iconView.frame = messFrame!.icon!

            self.textView.frame = messFrame!.text!
            self.textView.setTitle(messFrame!.message!.text!, forState: UIControlState.Normal)
            self.iconView.image = UIImage(data: messFrame!.message!.icon!)
            
            if messFrame!.message?.type == 1 {
                self.textView.setBackgroundImage(UIImage.resizableImageWithName("SenderTextNodeBkg"), forState: UIControlState.Normal)
            }else {

                self.textView.setBackgroundImage(UIImage.resizableImageWithName("ReceiverTextNodeBkg"), forState: UIControlState.Normal)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    class func cell(tableView:UITableView)->MessageCell{
        let id = "messageId"
        var cell = tableView.dequeueReusableCellWithIdentifier(id) as? MessageCell

        if cell == nil {
            cell = MessageCell(style: UITableViewCellStyle.Default, reuseIdentifier:id)
        }
        return cell!
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.nameView.font = UIFont.systemFontOfSize(nameFont)

        self.textView.titleLabel?.font = UIFont.systemFontOfSize(textFont)
        self.textView.titleLabel?.numberOfLines = 0
        self.textView.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.textView.contentEdgeInsets = UIEdgeInsets(top: 10,left: 20,bottom: 20,right: 20)

        self.addSubview(iconView)
        self.addSubview(nameView)
        self.addSubview(textView)
        self.backgroundColor = UIColor.clearColor()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
