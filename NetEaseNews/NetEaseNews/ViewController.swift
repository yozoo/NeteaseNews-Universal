//
//  ViewController.swift
//  NetEaseNews
//
//  Created by yozoo on 5/29/16.
//  Copyright © 2016 yozoo. All rights reserved.
//

import UIKit

class tsetModel: NSObject{
    var ltitle:String!
    var title:String!
}

class ViewController: UIViewController {
    var defaultModeChildViews: [UIViewController] = []
    var lineView:UIView!
    var logoView:UIImageView!
    var statusBar:UIView!
    var hasIpadMode:Int!
    var hasDefaultMode:Int!
    //    @IBOutlet var bigScrollViewX: NSLayoutConstraint!
    @IBOutlet var topNavTrailing: NSLayoutConstraint!
    @IBOutlet var topNavY: NSLayoutConstraint!
    @IBOutlet var topNavHeight: NSLayoutConstraint!
    var applicationW: CGFloat!
    var ipadModeScrollView: UIScrollView!
    var defaultModeScrollView: UIScrollView!
    @IBOutlet weak var topNavView: HomeTopNavView!
    var newsController: NewsViewController!
    var channelList: [AnyObject] = []
    //    @IBOutlet weak var contentFlowlayout: UICollectionViewFlowLayout!
    //    @IBOutlet weak var contentCollectionView: UICollectionView!
    var homeTopNavArray:[String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        applicationW = UIScreen.mainScreen().applicationFrame.size.width
        hasIpadMode = 0
        hasDefaultMode = 0
        self.automaticallyAdjustsScrollViewInsets = false
        topNavView.delegate = self
        if NSUserDefaults.standardUserDefaults().objectForKey("homeNavArray") != nil{
            homeTopNavArray = NSUserDefaults.standardUserDefaults().objectForKey("homeNavArray") as! [String]
        }
        channelList = topNavView.channelList
        guard homeTopNavArray != nil  else {
            return
        }
        self.initWithScrollView()
        self.setNavAndScrollView()
        self.setupTitleView()
        
    }
    
    func initWithScrollView(){
        defaultModeScrollView = UIScrollView(frame: CGRectMake(0, 64+44, applicationW, 0))
        defaultModeScrollView.delegate = self
        defaultModeScrollView.pagingEnabled = true
        defaultModeScrollView.showsHorizontalScrollIndicator = false
        defaultModeScrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(defaultModeScrollView)
        
        ipadModeScrollView = UIScrollView(frame: CGRectMake(0, 0, applicationW, 0))
        ipadModeScrollView.delegate = self
        ipadModeScrollView.pagingEnabled = true
        ipadModeScrollView.showsHorizontalScrollIndicator = false
        ipadModeScrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(ipadModeScrollView)
    }
    
    func setNavAndScrollView(){
//        if applicationW != UIScreen.mainScreen().applicationFrame.size.width{
        applicationW = UIScreen.mainScreen().applicationFrame.size.width
            defaultModeScrollView.frame = CGRectMake(0, 64+44, applicationW, UIScreen.mainScreen().applicationFrame.size.height-88)
            ipadModeScrollView.frame = CGRectMake(67, 40, applicationW-67, UIScreen.mainScreen().applicationFrame.size.height-80)
            if applicationW < 600{
                if defaultModeScrollView != nil{
                    defaultModeScrollView.hidden = false
                }
                if ipadModeScrollView != nil{
                    ipadModeScrollView.hidden = true
                }
                self.navigationController?.navigationBarHidden = false
                topNavHeight.constant = 44
                topNavY.constant = 0
                topNavTrailing.constant = 0
                //                bigScrollViewX.constant = 0
                if lineView != nil{
                    lineView.removeFromSuperview()
                }
                if logoView != nil{
                    logoView.removeFromSuperview()
                    
                }
                if statusBar != nil{
                    statusBar.removeFromSuperview()
                    
                }
                if hasDefaultMode == 0{
                self.addControllerWithDefault()
                setupDefaultModeScrollView()
                }
            }else{
                
                if defaultModeScrollView != nil{
                    defaultModeScrollView.hidden = true
                }
                if ipadModeScrollView != nil{
                    ipadModeScrollView.hidden = false
                }
                self.navigationController?.navigationBarHidden = true
                ipadModeScrollView.scrollEnabled = false
                topNavHeight.constant = UIScreen.mainScreen().applicationFrame.size.height - 87
                topNavY.constant = 87
                topNavTrailing.constant = applicationW - 66
                if hasIpadMode == 1{
                if NSUserDefaults.standardUserDefaults().objectForKey("ipadModeScrollViewTag") != nil{
                    var offset:CGPoint = self.ipadModeScrollView.contentOffset
                    let tag = NSUserDefaults.standardUserDefaults().objectForKey("ipadModeScrollViewTag") as! CGFloat
                    offset.y = self.ipadModeScrollView.bounds.size.height * tag
                    ipadModeScrollView.setContentOffset(offset, animated: true)
                }
                }
                if lineView != nil{
                    lineView.removeFromSuperview()
                }
                if logoView != nil{
                    logoView.removeFromSuperview()
                    
                }
                statusBar = UIView(frame: CGRectMake(0, 0, applicationW, 20))
                statusBar.backgroundColor = UIColor(red: 225.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
                self.view.addSubview(statusBar)
                
                lineView = UIView(frame: CGRectMake(66, 0, 1, UIScreen.mainScreen().applicationFrame.size.height+20))
                lineView.backgroundColor = UIColor.lightGrayColor()
                self.view.addSubview(lineView)
                
                logoView = UIImageView(image: UIImage(named: "appLogo"))
                logoView.frame = CGRectMake(0, 20, 67, 67)
                self.view.addSubview(logoView)
                
                self.view.bringSubviewToFront(statusBar)
                if hasIpadMode == 0{
                    NSUserDefaults.standardUserDefaults().setObject(0, forKey: "ipadModeScrollViewTag")
                    self.addControllerWithIpadMode()
                    setupIpadModeScrollView()
                }
                
            }
            //            topNavView.setNeedsDisplay()
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        //        self.setupContentFlowlayout()
    }
    
    func setupTitleView(){
        let myTitleView = UIView(frame: CGRectMake(0, 0, 120, 30))
        let image = UIImage(named: "home_nav_title")
        let imageView = UIImageView(image: image)
        //        imageView.contentMode = .Center
        myTitleView.backgroundColor = UIColor.clearColor()
        imageView.frame = CGRectMake((120-45)/2, (30-23)/2, 45, 23)
        myTitleView.addSubview(imageView)
        self.navigationItem.titleView = myTitleView
    }
    
    private func addControllerWithIpadMode(){
        hasIpadMode = 1
        var i: Int = 0
        for  i = 0 ; i < self.channelList.count ; i++ {
            let newsStoryboard = UIStoryboard(name: "News", bundle: nil)
            let vc1 = newsStoryboard.instantiateViewControllerWithIdentifier("NewsViewControllerForIPAD") as! NewsViewControllerForIPAD
            let channel = self.channelList[i]
            vc1.channels = channel as! ChannelModel
            self.addChildViewController(vc1)
            
            vc1.didMoveToParentViewController(self)
        }
    }
    /** 添加子控制器 */
    func addControllerWithDefault(){
        hasDefaultMode = 1
        var i: Int = 0
        for  i = 0 ; i < self.channelList.count ; i++ {
            if applicationW < 600{
                let newsStoryboard = UIStoryboard(name: "News", bundle: nil)
                let vc1 = newsStoryboard.instantiateInitialViewController() as! NewsViewController
                let channel = self.channelList[i]
                vc1.channels = channel as! ChannelModel
                self.defaultModeChildViews.append(vc1)

                vc1.didMoveToParentViewController(self)
            }
            
        }
    }
    
    func setupIpadModeScrollView(){
//        for sub:UIView in self.bigScrollView.subviews {
//            sub.removeFromSuperview()
////            [subview removeFromSuperview];
//        }
        let contentX: CGFloat = CGFloat(self.childViewControllers.count) * applicationW
        self.ipadModeScrollView.contentSize = CGSizeMake(contentX, 0)
        if self.childViewControllers.first == nil{
            return
        }
        let vc: UIViewController = self.childViewControllers.first!
        vc.view.frame = self.ipadModeScrollView.bounds
        self.ipadModeScrollView.addSubview(vc.view)
        
    }

    func setupDefaultModeScrollView(){
        //        for sub:UIView in self.bigScrollView.subviews {
        //            sub.removeFromSuperview()
        ////            [subview removeFromSuperview];
        //        }
        let contentX: CGFloat = CGFloat(self.defaultModeChildViews.count) * applicationW
        self.defaultModeScrollView.contentSize = CGSizeMake(contentX, 0)
        
        let vc: UIViewController = self.defaultModeChildViews.first!
        vc.view.frame = self.defaultModeScrollView.bounds
        self.defaultModeScrollView.addSubview(vc.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        topNavView.setNeedsDisplay()
        self.setNavAndScrollView()
        
//        topNavView.setNeedsLayout()
    }
}

extension ViewController: HomeTopNavViewDelegate{
    func clickLabel(startView: HomeTopNavView, didClickLabelControl tap:UITapGestureRecognizer) {
        for obj in self.topNavView.labelArray {
            if obj.isKindOfClass(UILabel){
                let label = obj 
                label.textColor = UIColor(red: 85.0/255, green: 85.0/255, blue: 85.0/255, alpha: 1)
                label.font = UIFont.systemFontOfSize(15.0)
            }
        }
        //取出索引
        let tag:NSInteger = tap.view!.tag
        let label = tap.view as! UILabel
        label.textColor = UIColor.redColor()
        label.font = UIFont.systemFontOfSize(19.0)
//        if label.tag
        NSUserDefaults.standardUserDefaults().setObject(tag, forKey: "labelIndex")
        var offset:CGPoint!
        if applicationW < 600{
        offset = self.defaultModeScrollView.contentOffset
        offset.x = self.defaultModeScrollView.bounds.size.width * CGFloat(tag)
            self.defaultModeScrollView.setContentOffset(offset, animated: true)

        }else{
            offset = self.ipadModeScrollView.contentOffset
            offset.y = self.ipadModeScrollView.bounds.size.height * CGFloat(tag)
            self.ipadModeScrollView.setContentOffset(offset, animated: true)
            NSUserDefaults.standardUserDefaults().setObject(CGFloat(tag), forKey: "ipadModeScrollViewTag")
        }
//        if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
//            self.bigScrollView.setContentOffset(offset, animated: false)
//        }else{
//            self.bigScrollView.setContentOffset(offset, animated: true)
//        }
        var scrollViewOffset:CGPoint = self.topNavView.scrollView.contentOffset
        scrollViewOffset.x = label.center.x - self.topNavView.scrollView.frame.size.width * 0.5
        NSUserDefaults.standardUserDefaults().setObject(scrollViewOffset.x, forKey: "scrollViewOffset")
        //左边越界处理
                //右边越界处理
        let maxOffset:CGFloat = (self.topNavView.scrollView.contentSize.width - self.topNavView.scrollView.frame.size.width)
        if maxOffset < 0{
            scrollViewOffset.x = 0
        }
        if (scrollViewOffset.x > maxOffset) {
            if (scrollViewOffset.x <= 0) {
                scrollViewOffset.x = 0;
            }else{
            scrollViewOffset.x = maxOffset
            }
        }else if(scrollViewOffset.x <= 0){
            scrollViewOffset.x = 0
        }
        self.topNavView.scrollView.setContentOffset(scrollViewOffset, animated: true)
    }
}

extension ViewController: UIScrollViewDelegate{
    /** 滚动结束后调用（代码导致） */
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        // 获得索引
        let index: Int = applicationW < 600 ? Int(scrollView.contentOffset.x / self.defaultModeScrollView.frame.size.width) : Int(scrollView.contentOffset.y / self.ipadModeScrollView.frame.size.height)
        // 添加控制器
        let newsVc = (applicationW > 600) ? self.childViewControllers[index] : self.defaultModeChildViews[index]
//        newsVc.index = index;
        if index == (NSUserDefaults.standardUserDefaults().objectForKey("labelIndex") as! Int) {
            
        }else{
        NSUserDefaults.standardUserDefaults().setObject(index , forKey: "labelIndex")
        var scrollViewOffset:CGPoint = self.topNavView.scrollView.contentOffset
        scrollViewOffset.x =  (80*CGFloat(index) + 40) - self.topNavView.scrollView.frame.size.width * 0.5
        NSUserDefaults.standardUserDefaults().setObject(scrollViewOffset.x, forKey: "scrollViewOffset")
        topNavView.setNeedsDisplay()
        }

        if (newsVc.view.superview != nil) {
            return
        }
//        self.setScrollToTopWithTableViewIndex(index)
        newsVc.view.frame = scrollView.bounds;
        if applicationW < 600{
            self.defaultModeScrollView.addSubview(newsVc.view)
        }else{
            self.ipadModeScrollView.addSubview(newsVc.view)
        }
        
    }
    
    func setScrollToTopWithTableViewIndex(index: Int){
        
    }
    /** 滚动结束（手势导致） */
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    /** 正在滚动 */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
}
