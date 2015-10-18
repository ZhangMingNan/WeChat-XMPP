//
//  ToolsView.swift
//  WeChat-XMPP
//
//  Created by 张明楠 on 15/10/16.
//  Copyright © 2015年 张明楠. All rights reserved.
//

import UIKit

public class ToolsView: UIView ,UITextFieldDelegate{
    @IBOutlet weak var typeButton: UIButton!

    @IBOutlet weak var context: UITextField!
    @IBOutlet weak var bgImageView: UIImageView!

    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var emotionButton: UIButton!

    var sendMessageBlock:((text:String)->Void)?
    var addButtonClickedBlock:(()->Void)?
    class func toolsView()->ToolsView {
        let toolsView = NSBundle.mainBundle().loadNibNamed("ToolsView", owner: nil, options: nil).first as! ToolsView
        let image = UIImage.resizableImageWithName("Connectkeyboad_banner_bg")

        toolsView.bgImageView.image = image
        toolsView.context.background   = UIImage.resizableImageWithName("SendTextViewBkg")
        toolsView.context.leftView = UIView(frame: CGRectMake(0, 0, 10, 10))
        toolsView.context.leftViewMode = UITextFieldViewMode.Always
        
        toolsView.typeButton.setBackgroundImage(UIImage(named: "ToolViewKeyboard"), forState: UIControlState.Normal)
        toolsView.typeButton.setBackgroundImage(UIImage(named: "ToolViewKeyboardHL"), forState: UIControlState.Highlighted)

        toolsView.emotionButton.setBackgroundImage(UIImage(named: "ToolViewEmotion"), forState: UIControlState.Normal)
        toolsView.emotionButton.setBackgroundImage(UIImage(named: "ToolViewEmotionHL"), forState: UIControlState.Highlighted)

        toolsView.otherButton.setBackgroundImage(UIImage(named: "ToolViewInputVoice"), forState: UIControlState.Normal)
        toolsView.otherButton.setBackgroundImage(UIImage(named: "ToolViewInputVoiceHL"), forState: UIControlState.Highlighted)
        toolsView.context.delegate = toolsView
        toolsView.otherButton.addTarget(toolsView, action: "addButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        return toolsView
    }
    func addButtonClicked(){
        self.addButtonClickedBlock?()
    }
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        sendMessageBlock?(text: self.context.text!)
        self.context.text = nil
        return true
    }
}
