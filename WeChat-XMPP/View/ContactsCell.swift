//
//  ContactsCell.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/22.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit

class ContactsCell: UITableViewCell {

    var iconView:UIImageView!
    var nameLabel:UILabel!
    var contactsFrame:ContactsFrame?{
        didSet{
            if let cf = contactsFrame {
                self.iconView.frame = cf.iconView
                self.nameLabel.frame = cf.nameLabel
                if let c = cf.contacts {
                    self.iconView.image = UIImage(data: c.icon!)
                    self.nameLabel.text = c.name
                }
            }
        }
    }

    class func cell(tableView:UITableView)->ContactsCell{
        let cellId = "contactsCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier("contactsCellId") as? ContactsCell
        if cell == nil {
            cell = ContactsCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        return cell!
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.iconView = UIImageView()
        self.nameLabel = UILabel()

        self.contentView.addSubview(self.iconView)
        self.contentView.addSubview(self.nameLabel)

    }
    
    required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
