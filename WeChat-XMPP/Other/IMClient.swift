//
//  IMClient.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/15.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit
import XMPPFramework

//连接服务器的两种类型
enum ConnectType {
    case Login
    case Register
}
enum ConnectResponseType{
    case LoginSuccessed
    case LoginFailed
}
typealias LoginComplateBlock = (type:ConnectResponseType)->Void
typealias DisconnectBlock = ()->Void
class IMClient:NSObject, XMPPStreamDelegate {

    var stream:XMPPStream?
    static let shared = IMClient()
    var block:LoginComplateBlock?
    var didDisconnectBlock:DisconnectBlock?

    var rosterStorage:XMPPRosterCoreDataStorage?
    var roster:XMPPRoster?
    var avatar:XMPPvCardAvatarModule?
  
    var vCardStorage:XMPPvCardCoreDataStorage?
    var vCard:XMPPvCardTempModule?

    var message:XMPPMessageArchiving?
    var messageStorage:XMPPMessageArchivingCoreDataStorage?

    private override init (){
        super.init()

        self.stream = XMPPStream()
        self.stream?.addDelegate(self, delegateQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        self.stream?.hostName = "123.57.82.254"
        let jid = XMPPJID.jidWithUser(MNAccount.shared.currentUserName, domain: "123.57.82.254", resource: "ios")
        self.stream?.myJID = jid

        //修改登陆状态并且持久化
        MNAccount.shared.isLogin = true
        MNAccount.shared.synchronize()

        self.vCardStorage = XMPPvCardCoreDataStorage.sharedInstance()
        self.vCard = XMPPvCardTempModule(withvCardStorage: self.vCardStorage)
        self.vCard?.activate(self.stream)
        self.avatar = XMPPvCardAvatarModule(withvCardTempModule: self.vCard)
        self.avatar?.activate(self.stream)

        // 添加 "花名册" 模块,用于获取好友列表.
        self.rosterStorage = XMPPRosterCoreDataStorage()
        self.roster = XMPPRoster(rosterStorage: self.rosterStorage)
        self.roster?.activate(self.stream)

        //启用消息模块
        self.messageStorage = XMPPMessageArchivingCoreDataStorage()
        self.message = XMPPMessageArchiving(messageArchivingStorage: self.messageStorage)
        self.message?.activate(self.stream)
    }

    func connect(type:ConnectType,block:LoginComplateBlock){
        //连接前断开
        self.block = block
        self.stream?.disconnect()
        do{
            try self.stream?.connectWithTimeout(6)
        }catch {
            print("连接失败")
        }
    }

    //连接成功调用
   @objc func xmppStreamDidConnect(sender: XMPPStream!) {
        do{
            //连接成功发送密码
           try self.stream?.authenticateWithPassword(MNAccount.shared.currentUserPwd)
            if !self.stream!.isAuthenticated() {
                if let block = self.block {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        block(type: ConnectResponseType.LoginFailed)
                    })

                }
            }
        }catch {
            print("密码验证失败!")
            self.stream?.disconnect()
        }
    }

    //密码验证成功调用
    @objc func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        print("密码验证成功!")
        //发送上线消息到服务器
        self.stream?.sendElement(XMPPPresence())

        if let block = self.block {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                block(type: ConnectResponseType.LoginSuccessed)
            })

        }
    }

    func loutout(didDisconnectBlock:DisconnectBlock){

        self.didDisconnectBlock = didDisconnectBlock
        MNAccount.shared.isLogin = false
        MNAccount.shared.synchronize()
        //发送离线消息
        self.stream?.sendElement(XMPPPresence(type: "unavailable"))
        //关闭连接
        self.stream?.disconnect()
        self.stream?.removeDelegate(self)
    }
    func xmppStreamDidDisconnect(sender: XMPPStream!, withError error: NSError!) {
        //连接已经关闭
        print("连接关闭")
        if let block = self.didDisconnectBlock {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        block()
            })
        }
    }

}
