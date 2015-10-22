//
//  ViewController.swift
//  WeChat-XMPP
//
//  Created by 张明楠(QQ:1007350771) on 15/10/15.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit

class MessageLoggingController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var tableView:UITableView!
    var fridenList = [FriendFrame]()
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注销", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        self.tableView = UITableView(frame: self.view.bounds)
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //加载消息记录
        var f = Friend()
        f.icon = UIImagePNGRepresentation(UIImage(named: "icon_avatar")!)
        f.name = "张明楠"
        f.lastMessage = "hello"
        f.time = "下午3点12"
        var ff = FriendFrame()
        ff.friend = f

        self.fridenList.append(ff)
        self.tableView.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fridenList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = FriendCell.cell(tableView)
        cell.friendFrame = self.fridenList[indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return FriendCell.cellHeight
    }

    func logout(){
        IMClient.shared.loutout { () -> Void in
            //在这里显示登陆界面
            let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
            app.keyWindow?.rootViewController = loginVC
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

