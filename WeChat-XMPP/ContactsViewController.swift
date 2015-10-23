//
//  ContactsViewController.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/22.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit

class ContactsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = ContactsCell.cell(tableView)
        return cell
    }
}
