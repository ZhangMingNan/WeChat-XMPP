//
//  MNChatViewController.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/16.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit
import XMPPFramework
class MNChatViewController: UIViewController,NSFetchedResultsControllerDelegate ,UITableViewDelegate,UITableViewDataSource {

    var tableView: UITableView!
    var friendJid:XMPPJID?
    var vCardTemp:XMPPvCardTemp?
    var resultsController:NSFetchedResultsController?
    var toolsView:ToolsView!
    var messageFrames = [MessageFrame]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = UITableView(frame: CGRectMake(0, 0,screenWidth, screenHeight - 44))

        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.toolsView = ToolsView.toolsView()
        self.toolsView.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), screenWidth, 44)
        self.toolsView.sendMessageBlock = {
            (text) -> Void in
            self.view.endEditing(true)
            let message = XMPPMessage(type: "chat", to: self.friendJid)
            message.addBody(text)
            IMClient.shared.stream?.sendElement(message)
            print(text)
        }

        self.view.addSubview(self.tableView)
               self.view.addSubview(self.toolsView)

        self.view.backgroundColor = UIColor.whiteColor()
        //根据JID获取聊天记录
        loadMessage(self.friendJid!)

        self.tableView.allowsSelection = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        self.vCardTemp =   IMClient.shared.vCardStorage?.vCardTempForJID(self.friendJid, xmppStream: IMClient.shared.stream)
        
        self.navigationItem.title = self.vCardTemp?.nickname
    }
    let tabFooter = UIView()
    func keyBoardChange(notify:NSNotification){
        print(self.tableView.size().height , self.tableView.contentSize.height)


            //输入框跟随键盘抬起
            var dic = notify.userInfo!
            let endFrame = dic[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
            let keyBoardY = endFrame.origin.y
            let endDuration = dic[UIKeyboardAnimationDurationUserInfoKey] as! Double

            UIView.animateWithDuration(endDuration, animations: { () -> Void in
                self.toolsView.transform = CGAffineTransformMakeTranslation(0,keyBoardY - self.view.frame.size.height)
                print(keyBoardY - self.view.frame.size.height)
            })
            tabFooter.frame = CGRectMake(0, 0, 0, abs(keyBoardY-self.view.frame.size.height))
            self.tableView.tableFooterView = tabFooter
            let currentOffset = self.tableView.contentOffset

            //判断是否需要移动
            if self.tableView.size().height < self.tableView.contentSize.height {
                self.tableView.contentOffset = CGPointMake(currentOffset.x, currentOffset.y + abs(keyBoardY-self.view.frame.size.height))
            }
            toBottom()


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadMessage(jid:XMPPJID){

        let messageContext = IMClient.shared.messageStorage!.mainThreadManagedObjectContext
        let request = NSFetchRequest(entityName: "XMPPMessageArchiving_Message_CoreDataObject")


        let currentJid = IMClient.shared.stream?.myJID.bare()!
        request.predicate =  NSPredicate(format: "streamBareJidStr = %@ AND bareJidStr = %@",currentJid!,self.friendJid!.bare())

        let sort = NSSortDescriptor(key: "timestamp", ascending: true)
        request.sortDescriptors = [sort]
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
        return self.messageFrames.count
    }


    func controllerWillChangeContent(controller: NSFetchedResultsController) {
      //  self.tableView.beginUpdates()
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        let obj = anObject as! XMPPMessageArchiving_Message_CoreDataObject

        if !obj.isComposing {
            //将数据库中的数据转换成
            print("没有添加之前\(self.messageFrames.count)")
          //  for mess in (self.resultsController?.fetchedObjects as! [XMPPMessageArchiving_Message_CoreDataObject]){
            //    if !mess.isComposing {
                    var model = Message()
                    model.text = obj.body ?? ""
                    model.type = obj.outgoing.integerValue
                    if model.type == 1 {
                        //发送消息
                        model.icon =  IMClient.shared.vCard?.myvCardTemp.photo ?? NSData(contentsOfFile: "icon_avatar")
                        model.name = IMClient.shared.vCard?.myvCardTemp.nickname
                    }else {
                        model.icon = self.vCardTemp?.photo ?? NSData(contentsOfFile: "icon_avatar")
                        model.name = self.vCardTemp?.nickname
                    }

                    let frame = MessageFrame()
                    frame.message = model
                    self.messageFrames.append(frame)
                //}
            //}
            print((self.resultsController?.fetchedObjects as! [XMPPMessageArchiving_Message_CoreDataObject]).count)
            print(self.messageFrames.count)
            print(newIndexPath)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.messageFrames.count - 1 , inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
            //滚动到底部
            toBottom()
        }

    }

    func  toBottom(){
            if self.tableView.contentSize.height > self.tableView.size().height {
            self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentSize.height - self.tableView.size().height), animated: true)
    }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
       // self.tableView.endUpdates()
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = MessageCell.cell(tableView)
        cell.messFrame = self.messageFrames[indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.messageFrames[indexPath.row].cellHeight
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }


}























