//
//  MNEmotionKeyBoard.swift
//  10-SinaWB
//
//  Created by 张明楠 on 15/8/4.
//  Copyright (c) 2015年 张明楠. All rights reserved.
//

import UIKit
let MNEmotionKeyBoardHeight:CGFloat = 216
class MNEmotionKeyBoard: UIView , MNKeyBoardTabBarDelegate {
    var tabBar:MNKeyBoardTabBar?{
        didSet{
            if let tabBar = tabBar{
                self.addSubview(tabBar)
            }
        }
    }
    // FIXME: 可能是个BUG.
    var emotionPanel:MNKeyBoardPanel?{
        didSet{
            if let emotionPanel = emotionPanel {
                self.addSubview(emotionPanel)
            }
        }
    }

    class func  emotionKeyBoard(butInfoList:[ButInfo],defaultIndex:Int)->MNEmotionKeyBoard{
        let keyBoard =  MNEmotionKeyBoard(frame: CGRectMake(0, 0, screenWidth, MNEmotionKeyBoardHeight))
        keyBoard.tabBar = MNKeyBoardTabBar.keyBoardTabBar(butInfoList,defaultIndex:defaultIndex)
        keyBoard.emotionPanel = MNKeyBoardPanel.panel(butInfoList,defaultIndex:defaultIndex)
        keyBoard.tabBar!.delegate = keyBoard
        return keyBoard
    }
    override  init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func switchKeyBoard(fromIndex: Int?, toIndex: Int) {

        self.emotionPanel?.switchView(fromIndex, toIndex:toIndex)
    }
}

typealias ButInfo = (Int,String,String,String)
protocol MNKeyBoardTabBarDelegate {
    func switchKeyBoard(fromIndex:Int?,toIndex:Int)
}
class MNKeyBoardTabBar: UIView {

    var currentSelectedBut:UIButton?
    var defaultIndex = 1
    var delegate:MNKeyBoardTabBarDelegate?
    var butInfoList = [ButInfo](){
        didSet{
            for butInfo in butInfoList {
                let but = UIButton()
                but.setTitle(butInfo.1, forState: UIControlState.Normal)
                but.tag = butInfo.0
                but.setSize(CGSizeMake(screenWidth / CGFloat(self.butInfoList.count),37))
                but.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                but.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
                but.setBackgroundImage(UIImage.resizableImageWithName( "compose_emotion_table_\(butInfo.2)_normal"), forState: UIControlState.Normal)
                but.setBackgroundImage(UIImage.resizableImageWithName( "compose_emotion_table_\(butInfo.2)_selected"), forState: UIControlState.Disabled)
                self.addSubview(but)
                but.addTarget(self, action: "clickBut:", forControlEvents: UIControlEvents.TouchUpInside)
                if butInfo.0 == defaultIndex {
                    clickBut(but)

                }
            }
        }
    }

    class func keyBoardTabBar(butInfoList:[ButInfo]?,defaultIndex:Int)->MNKeyBoardTabBar{
        let bar = MNKeyBoardTabBar()
        bar.defaultIndex = defaultIndex
        bar.frame  =   CGRectMake(0,MNEmotionKeyBoardHeight - 37, screenWidth, 37)
        if let butInfoList = butInfoList {
            bar.butInfoList = butInfoList
        }
        return bar
    }


    override  init(frame: CGRect) {
        super.init(frame: frame)
    }

    func clickBut(but:UIButton){

        if let delegate = self.delegate {
            delegate.switchKeyBoard(self.currentSelectedBut?.tag, toIndex: but.tag)
        }
        self.currentSelectedBut?.enabled = true
        but.enabled = false
        self.currentSelectedBut = but
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var buts = self.subviews
        for i in 0..<buts.count {
            let but = buts[i] as? UIButton
            but?.setOrigin(CGPointMake(CGFloat(i) * but!.width(), 0))
        }
    }
}

class MNKeyBoardPanel: UIView {
    var contentView:UIView?
    var emotionListViewList = [MNEmotionListView]()
    var defaultIndex = 1
    var butInfoList = [ButInfo](){
        didSet{
            for butInfo in butInfoList {
                //加载数据.
                let emotionListView = MNEmotionListView(frame: self.bounds)
                emotionListView.hidden = (defaultIndex != butInfo.0)
                emotionListView.butInfo = butInfo
                self.contentView?.addSubview(emotionListView)
                self.emotionListViewList.append(emotionListView)
            }
        }
    }
    func switchView(fromIndex:Int?,toIndex:Int){
        if let fromIndex = fromIndex{
            self.emotionListViewList[fromIndex-1].hidden = true
        }
        self.emotionListViewList[toIndex-1].hidden = false
    }
    class func panel(butInfoList:[ButInfo]?,defaultIndex:Int)->MNKeyBoardPanel{
        let panel = MNKeyBoardPanel(frame:  CGRectMake(0, 0, screenWidth, MNEmotionKeyBoardHeight  - 37))
        panel.defaultIndex = defaultIndex
        if let butInfoList = butInfoList {
            panel.butInfoList = butInfoList
        }
        return panel
    }

    override  init(frame: CGRect) {
        super.init(frame: frame)


        self.contentView = UIView(frame:self.bounds)
        self.addSubview(self.contentView!)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }
}


class MNEmotionListView:UIView,UIScrollViewDelegate {
    var emotionList = [MNEmotion]()
    // TODO: 修改位置
    var magnifierBut = MNMagnifierBut()
    var pageControl = UIPageControl()
    var scrollView = UIScrollView()
    var pageViewList = [MNEmotionPageView]()
    var butInfo:ButInfo?{
        didSet{
            if let butInfo = butInfo{
                //加载plist文件.
                let path = NSBundle.mainBundle().pathForResource("EmotionIcons/\(butInfo.3)/info.plist", ofType:nil)
                if let path = path {
                    var arr = NSArray(contentsOfFile: path) as? Array<Dictionary<String,AnyObject>>
                    let pageSize = 20
                    let pageNumber = Int(ceil(Double(arr!.count)/Double(pageSize)) )
                    self.pageControl.frame = CGRectMake(0, self.height() - 30, self.width(), 30)
                    self.scrollView.contentSize = CGSizeMake(CGFloat(pageNumber) * self.width(), self.height() - 30)
                    for i in 0..<pageNumber {
                        let pageView = MNEmotionPageView()
                        pageView.magnifierBut = self.magnifierBut
                        pageView.pageIndex = i

                        self.pageViewList.append(pageView)
                        self.scrollView.addSubview(pageView)
                        //O(∩_∩)O~~
                        let subArray = arr![i*pageSize ... ((i*pageSize + pageSize)-1 >= arr!.count ? arr!.count - 1 :(i*pageSize + pageSize)-1)]
                        //pageView.emotionArray  = subArray.map({ dic -> MNEmotion in
                          //    return MNEmotion(chs:dic["chs"] as? String, png:dic["png"] as? String, code:dic["code"] as? String)
                        //})
                    }
                }
            }
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.pageControl.currentPage =  Int((scrollView.contentOffset.x / screenWidth))
    }

    override  init(frame: CGRect) {
        super.init(frame: frame)
        self.pageControl.backgroundColor = UIColor.clearColor()
        self.pageControl.numberOfPages = 5
        self.pageControl.setValue(UIImage(named:"compose_keyboard_dot_normal"), forKey: "pageImage")
        self.pageControl.setValue(UIImage(named:"compose_keyboard_dot_selected"), forKey: "currentPageImage")
        self.scrollView.frame = CGRectMake(0, 0, self.width(),self.height() - 30)
        self.scrollView.pagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.backgroundColor = UIColor.clearColor()

        self.addSubview(self.pageControl)
        self.addSubview(self.scrollView)
        self.scrollView.delegate = self

        self.backgroundColor = UIColor(patternImage: UIImage(named: "emoticon_keyboard_background")!)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.frame = self.superview!.bounds
        for i in 0..<self.pageViewList.count {
            let pageView = self.pageViewList[i]
            pageView.frame = CGRectMake(CGFloat(i) * self.width() , 0, self.width(), self.scrollView.height())
        }
    }
}




// MARK: 放大镜按钮
class MNMagnifierBut: UIButton {
    // MARK:根据点击按钮显示放大镜
    func showMagnifierButWithBut(but:UIButton?){
        if let but = but {
            let listFrame = but.convertRect(but.bounds, toView: nil)
            if let currentImage = but.currentImage {
                self.setImage(currentImage, forState: UIControlState.Normal)
            }else {
                self.setTitle(but.titleLabel?.text, forState: UIControlState.Normal)
            }
            self.center = CGPointMake(listFrame.origin.x + but.frame.width * 0.5, listFrame.origin.y-3)
        }
    }

    override  init(frame: CGRect) {
        super.init(frame: frame)
        //创建放大镜按钮
        self.frame.size = CGSizeMake(64, 80)
        self.enabled = false
        self.adjustsImageWhenDisabled = false
        self.setBackgroundImage(UIImage(named: "emoticon_keyboard_magnifier"), forState: UIControlState.Normal)
        self.setBackgroundImage(UIImage(named: "emoticon_keyboard_magnifier"), forState: UIControlState.Highlighted)
        self.setBackgroundImage(UIImage(named: "emoticon_keyboard_magnifier"), forState: UIControlState.Disabled)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {

        return CGRectMake(16, 10, 32,32)
    }

}







class MNEmotionPageView:UIView {
    var pageIndex:Int = 0
    var backBut:UIButton?
    var emotionButs = [MNEmotionButton]()
    var magnifierBut:MNMagnifierBut?
    var emotionArray = ArraySlice<MNEmotion>(){
        didSet{
            for emotion in emotionArray {
                let but = MNEmotionButton()
                but.emotion = emotion
                but.addTarget(self, action: "click:", forControlEvents: UIControlEvents.TouchDown)
                self.addSubview(but)
                self.emotionButs.append(but)
            }
        }
    }


    func getButByLocation(location:CGPoint)->MNEmotionButton?{

        for but in self.emotionButs {
            if  CGRectContainsPoint(but.frame, location) {
                return but
            }
        }
        return nil
    }

    func longPress(recognizer:UILongPressGestureRecognizer){
        let location = recognizer.locationInView(recognizer.view)
        let hitBut = getButByLocation(location)
        switch recognizer.state {
        case  UIGestureRecognizerState.Began :
            //根据手势坐标获得按钮
            let window = UIApplication.sharedApplication().keyWindow
            window!.addSubview(self.magnifierBut!)
            self.magnifierBut!.showMagnifierButWithBut(hitBut)

        case   UIGestureRecognizerState.Changed:


            if let magnifierBut = magnifierBut {
                magnifierBut.showMagnifierButWithBut(hitBut)
            }
            print("changed")
        case UIGestureRecognizerState.Ended :
            self.magnifierBut?.removeFromSuperview()
            print("Ended")
            //发送完通知延迟一段时间隐藏放大镜
                self.magnifierBut?.removeFromSuperview()
            click(hitBut)
        default :
            print("other")
        }
    }

    // MARK: 删除按钮点击.
    func backButClick(but:UIButton){
        //发送删除按钮点击通知
        NSNotificationCenter.defaultCenter().postNotificationName("BackButClick", object: nil, userInfo: nil)
    }

    func click(but:MNEmotionButton?){
        if let but = but {

                if but.emotion != nil {
                    let userInfo = ["emotion":but]
                    NSNotificationCenter.defaultCenter().postNotificationName("EmotionButtonClick", object: nil, userInfo: userInfo)
                }

        }
    }
    override  init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.backBut = UIButton()
        self.backBut?.adjustsImageWhenHighlighted = false
        self.backBut?.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
        self.backBut?.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)

        self.backBut?.addTarget(self, action: Selector("backButClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.backBut!)
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: Selector("longPress:")))
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let butWith = (screenWidth - 20) / 7
            for i in 0..<self.emotionButs.count {
                let but = self.emotionButs[i]
                but.frame = CGRectMake(10 +  CGFloat(i % 7) * butWith ,ceil(CGFloat(i/7) * butWith) + 10,butWith,butWith)
            }
        //设置删除按钮
        self.backBut?.frame = CGRectMake(screenWidth - butWith - 10,2 * butWith + 10,butWith,butWith)
    }
}

class MNEmotionButton:UIButton {
    var emotion:MNEmotion?{
        didSet{
            if let emotion = emotion {
                if let png = emotion.png {
                    self.setImage(UIImage(named:png), forState: UIControlState.Normal)
                }else {
                    self.setTitle(emotion.code, forState: UIControlState.Normal)
                }
            }
        }
    }
    override  init(frame: CGRect) {
        super.init(frame: frame)
        self.adjustsImageWhenHighlighted = false
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK: 按钮模型
struct MNEmotion {
    let chs:String?
    let png:String?
    let code:String?
}




















