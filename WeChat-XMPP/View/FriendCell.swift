//
//  FriendCell.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/22.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
   static var  cellHeight:CGFloat = 65
    var iconView:UIImageView!
    var nameLabel:UILabel!
    var lastMessageLabel:UILabel!
    var timeLabel:UILabel!
    var lineView:UIView!
    var friendFrame:FriendFrame?{
        didSet{
            if  let ff = friendFrame {
                self.iconView.frame = ff.iconView
                self.nameLabel.frame = ff.nameLabel
                self.lastMessageLabel.frame = ff.lastMessageLabel
                self.timeLabel.frame = ff.timeLabel


                self.lineView.frame = CGRectMake(10,FriendCell.cellHeight, screenWidth - 10, 1)
                if let fr = ff.friend {
                    self.iconView.image = UIImage(data:fr.icon!)
                    self.nameLabel.text = fr.name
                    self.lastMessageLabel.text = fr.lastMessage
                    self.timeLabel.text = fr.time
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.iconView = UIImageView()
        self.nameLabel = UILabel()
        self.nameLabel.font = UIFont.systemFontOfSize(friendFrameNameFont)
        self.lastMessageLabel = UILabel()
        self.lastMessageLabel.textColor = UIColor.lightGrayColor()
        self.lastMessageLabel.font = UIFont.systemFontOfSize(friendFrameLastMessageFont)
        self.timeLabel = UILabel()
        self.timeLabel.font = UIFont.systemFontOfSize(friendFrameTimeFont)
        self.timeLabel.textColor = UIColor.lightGrayColor()

        self.contentView.addSubview(  self.iconView)
        self.contentView.addSubview(  self.nameLabel)
        self.contentView.addSubview(  self.lastMessageLabel)
        self.contentView.addSubview(  self.timeLabel)

        self.lineView = UIView()
        self.lineView.backgroundColor = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
        self.contentView.addSubview(self.lineView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func cell(tableView:UITableView)->FriendCell{
        let cellId = "friendCell"
        var  cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? FriendCell
        if cell == nil {
            cell = FriendCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        return cell!
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
