//
//  MNChatViewController.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/16.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit
//import Bugly
import XMPPFramework
import hpple
import SwiftyJSON

class MNChatViewController: UIViewController,NSFetchedResultsControllerDelegate ,UITableViewDelegate,UITableViewDataSource ,SharemoreViewDelegate{
    
    var tableView: UITableView!
    var friendJid:XMPPJID?
    var vCardTemp:XMPPvCardTemp?
    var resultsController:NSFetchedResultsController?
    var toolsView:ToolsView!
    var messageFrames = [MessageFrame]()
    var sharemoreView:SharemoreView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sharemoreView = SharemoreView.sharemoreView()
        self.sharemoreView.delegate = self
        self.tableView = UITableView(frame: CGRectMake(0, 0,screenWidth, screenHeight - 44))
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.toolsView = ToolsView.toolsView()
        self.toolsView.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), screenWidth, 44)

        self.toolsView.addButtonClickedBlock = {
            () -> Void in

            self.toolsView.context.resignFirstResponder()
            //弹出后将光标设置为透明
            self.toolsView.context.inputView = self.sharemoreView
            //self.toolsView.context.enabled = false

            self.toolsView.context.becomeFirstResponder()
        }

        self.toolsView.sendMessageBlock = {
            (text) -> Void in

            let message = XMPPMessage(type: "chat", to: self.friendJid)
            message.addBody(text)
            IMClient.shared.stream?.sendElement(message)
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

    //点击附件选择器调用
    func click() {
        let imagepc = UIImagePickerController()
        imagepc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagepc.delegate = self
        self.presentViewController(imagepc, animated: true, completion: nil)
    }


    let tabFooter = UIView()
    func keyBoardChange(notify:NSNotification){
            //弹出后将光标设置为透明
            self.toolsView.context.inputView = nil
            //输入框跟随键盘抬起
            var dic = notify.userInfo!
            let endFrame = dic[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
            let keyBoardY = endFrame.origin.y
            let endDuration = dic[UIKeyboardAnimationDurationUserInfoKey] as! Double


            let currentOffset = self.tableView.contentOffset
            UIView.animateWithDuration(endDuration, animations: { () -> Void in
            self.toolsView.transform = CGAffineTransformMakeTranslation(0,keyBoardY - self.view.frame.size.height)

            })
            //判断是否需要移动 tableview
            if self.tableView.size().height < self.tableView.contentSize.height {
                self.tableView.contentOffset = CGPointMake(currentOffset.x, currentOffset.y + abs(keyBoardY-self.view.frame.size.height))

            }

        tabFooter.frame = CGRectMake(0, 0, 0, abs(keyBoardY-self.view.frame.size.height))
        self.tableView.tableFooterView = tabFooter

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

        let doc = TFHpple(data: obj.messageStr.dataUsingEncoding(NSUTF8StringEncoding), isXML: true)
        let imageInfoJsonStr = (doc.peekAtSearchWithXPathQuery("/message/@imageInfo"))?.text()
        print("imageInfoJsonStr:\(imageInfoJsonStr)")
        if !obj.isComposing {
            if let str = imageInfoJsonStr {
                let infoJson =   JSON(data: str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
                var imageFr = ImageMessageFrame()
                var imageModel = ImageMessage()
                imageModel.type = obj.outgoing.integerValue
                if imageModel.type == 1 {
                    //发送消息
                    imageModel.icon =  IMClient.shared.vCard?.myvCardTemp.photo ?? NSData(contentsOfFile: "icon_avatar")
                }else {
                    imageModel.icon = self.vCardTemp?.photo ?? NSData(contentsOfFile: "icon_avatar")
                }
                imageModel.height = CGFloat(infoJson["height"].floatValue)
                imageModel.width = CGFloat(infoJson["width"].floatValue)
                imageModel.url = baseUrl +  infoJson["url"].stringValue
                imageFr.imageMessage = imageModel
                self.messageFrames.append(imageFr)
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.messageFrames.count - 1 , inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
            }else {
                //将数据库中的数据转换成
                var frame = TextMessageFrame()
                var model = TextMessage()
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

                frame.message = model
                self.messageFrames.append(frame)
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.messageFrames.count - 1 , inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
                //滚动到底部
            }

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
        if self.messageFrames[indexPath.row] is TextMessageFrame {
            print("text")
           let  cell = MessageCell.cell(tableView)
            cell.messFrame = self.messageFrames[indexPath.row] as? TextMessageFrame
            return cell
        }else{
            print("img")
            let  cell = ImageCell.cell(tableView)
            cell.imageMessageFrame = self.messageFrames[indexPath.row] as? ImageMessageFrame
            return cell
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       return self.messageFrames[indexPath.row].cellHeight
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }


}























