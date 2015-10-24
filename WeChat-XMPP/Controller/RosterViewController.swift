//
//  RosterViewController.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/15.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit
import CoreData
import XMPPFramework

class RosterViewController: UITableViewController ,NSFetchedResultsControllerDelegate{
    var resultsController:NSFetchedResultsController?
    var users = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
 
        loadRoster()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "contacts_add_friend")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: "addFriend")
    }
    func addFriend(){

    }
    func loadRoster(){
        let rosterContext = IMClient.shared.rosterStorage!.mainThreadManagedObjectContext
        let request = NSFetchRequest(entityName: "XMPPUserCoreDataStorageObject")
        let sort = NSSortDescriptor(key: "displayName", ascending: true)
        request.sortDescriptors = [sort]

        self.resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext:rosterContext, sectionNameKeyPath: nil, cacheName:nil)
        self.resultsController?.delegate = self
        do{
          try  self.resultsController?.performFetch()
         }catch{
               print("获取好友列表失败!")
        }

    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      //  return self.users.count
        return self.resultsController?.fetchedObjects?.count ?? 0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let chatVC = MNChatViewController()
        let user =   (self.resultsController?.fetchedObjects as! [XMPPUserCoreDataStorageObject])[indexPath.row]
        chatVC.friendJid = user.jid
        self.navigationController?.pushViewController(chatVC, animated: true)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") ?? UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")

      let user =   (self.resultsController?.fetchedObjects as! [XMPPUserCoreDataStorageObject])[indexPath.row]
        cell.textLabel?.text = user.displayName
        //cell.detailTextLabel?.text = user.sectionNum.stringValue
        //获取头像数据
        if let photo = user.photo {
            cell.imageView?.image = photo
        }else {
        let avatarData = IMClient.shared.avatar?.photoDataForJID(user.jid)
        if let data = avatarData {
            cell.imageView?.image = UIImage(data: data)
        }else {
            cell.imageView?.image = UIImage(named: "icon_avatar")
        }
        }
        return cell
    }
}
