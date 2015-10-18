//
//  ChatViewController.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/16.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit
import XMPPFramework
class ChatViewController: UIViewController,NSFetchedResultsControllerDelegate ,UITableViewDelegate,UITableViewDataSource {

    var friendJid:XMPPJID?
    var resultsController:NSFetchedResultsController?
    var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        // Do any additional setup after loading the view
        self.navigationItem.title = "zmn"
        self.view.backgroundColor = UIColor.whiteColor()
        //根据JID获取聊天记录
        loadMessage(self.friendJid!)
    }
    func loadMessage(jid:XMPPJID){

        let messageContext = IMClient.shared.messageStorage!.mainThreadManagedObjectContext
        let request = NSFetchRequest(entityName: "XMPPMessageArchiving_Message_CoreDataObject")


        let currentJid = IMClient.shared.stream?.myJID.bare()
        //request.predicate =  NSPredicate(format: "streamBareJidStr = %@ AND bareJidStr = %@", [currentJid,self.friendJid!.bare()])
        let sort = NSSortDescriptor(key: "timestamp", ascending: true)
        request.sortDescriptors = [sort]
        print(currentJid)
        self.resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: messageContext, sectionNameKeyPath: nil, cacheName: nil)
        self.resultsController?.delegate = self
        do{
            try  self.resultsController?.performFetch()
        }catch {
            print("获取消息记录失败!")
        }
    }
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //  return self.users.count
        return self.resultsController?.fetchedObjects?.count ?? 0
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        print(self.resultsController?.fetchedObjects?.count)
        self.tableView.reloadData()
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") ?? UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")

        let message =   (self.resultsController?.fetchedObjects as! [XMPPMessageArchiving_Message_CoreDataObject])[indexPath.row]
        cell.textLabel?.text = message.body
        return cell
    }
}




