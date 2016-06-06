//
//  NewsViewController.swift
//  NetEaseNews
//
//  Created by yozoo on 5/29/16.
//  Copyright © 2016 yozoo. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import MJRefresh

@objc protocol NewsADDelegate {
    optional func setupADList(fromView: NewsViewController, ADList list:[AnyObject])
}

class NewsViewController: UIViewController {
    var isTop: Bool! = true
    var tidURLString: String!
    @IBOutlet var tableView: UITableView!
    var applicationW: CGFloat!
    @IBOutlet var headView: UIView!
    var cycleVC: CycleViewController!
//    @IBOutlet weak var tableView: UITableView!
    var innerNewList: [AnyObject]!
    var adList: IndexNewsModel!
    var indexMember: IndexNewsModel!
    var cycleMember: CycleModel!
    var channels: ChannelModel!
    weak var delegate: NewsADDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        applicationW = UIScreen.mainScreen().applicationFrame.size.width
        self.automaticallyAdjustsScrollViewInsets = false
//        self.edgesForExtendedLayout = .Top
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tidURLString = appApi.stringByAppendingString("article/headline/T1348647853363/0-20.html")
        self.setTidString()
        
    }
    
    func setTidString(){
        print(channels.tid)
        print(channels.tname)
        if isTop == false{
            return
        }
        if (channels.tid == "T1348647853363") {//头条
            tidURLString = appApi.stringByAppendingString("article/headline/T1348647853363/0-20.html")
        }else {
            tidURLString = appApi.stringByAppendingString("article/list/\(channels.tid)/0-20.html")
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("adList") != nil{
            NSUserDefaults.standardUserDefaults().removeObjectForKey("adList")
        }
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { [unowned self] () -> Void in
            self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self]() -> Void in
                self.setupData()
            })
            self.tableView.mj_header.beginRefreshing()
//        }
    }
    
//    func addHeaderRefresh(block: MJRefreshComponentRefreshingBlock) -> MJRefreshNormalHeader {
//
//        // 添加下拉刷新
//        let header = MJRefreshNormalHeader(refreshingBlock: block)
//        
//        return header
//    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        tableView.removeFromSuperview()
        
    }
    
    override func viewWillLayoutSubviews() {
        
        if applicationW != UIScreen.mainScreen().applicationFrame.size.width{
            applicationW = UIScreen.mainScreen().applicationFrame.size.width
            self.setupHeadView()
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupData(){
        print(tidURLString)
        if innerNewList != nil{
            innerNewList.removeAll()
        }
        innerNewList = []
        YHManageTool.GetWithURL(tidURLString, parameters: nil, success: {[unowned self] (json) -> Void in
            let dict = JSON(json).dictionaryObject
            guard let dicts:NSDictionary = dict else {
                return
            }
            let key = (dicts as NSDictionary).keyEnumerator().nextObject() as! String
            let array = dicts[key]
            guard array != nil else {
                return
            }
            array?.enumerateObjectsUsingBlock({(obj, idx, stop) in
                self.indexMember = IndexNewsModel.mj_objectWithKeyValues(obj)
                self.innerNewList.append(self.indexMember)
                
            })
            self.adList = self.innerNewList[0] as! IndexNewsModel
            if NSUserDefaults.standardUserDefaults().objectForKey("adList") != nil{
                NSUserDefaults.standardUserDefaults().removeObjectForKey("adList")
            }
            NSUserDefaults.standardUserDefaults().setObject(self.adList.ads, forKey: "adList")
            self.setupHeadView()
            if self.isTop == true{
                self.tableView.setContentOffset(CGPointMake(0, 0), animated: true)
            }
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.setContentOffset(CGPointZero, animated: true)
//            self.firstInit = self.firstInit + 1
        }) { (error) -> Void in
            guard error != nil else {
                print(error)
                return
            }
            if error.errorString == nil{
                print(error.errorCode)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.mj_header.endRefreshing()
            })
        }
        
    }
    
    func setupHeadView(){
        headView.removeFromSuperview()
        
        headView = UIView()
        var newFrame = headView.frame
        newFrame.size.height = self.adList.ads == nil ? 0 : 185 * (UIScreen.mainScreen().applicationFrame.size.width / 375)
        headView.frame = newFrame
        if cycleVC != nil{
            cycleVC = nil
        }
        cycleVC = UIStoryboard(name: "News", bundle: nil).instantiateViewControllerWithIdentifier("CycleViewController") as! CycleViewController
        cycleVC.view.frame = headView.frame
        if cycleVC.view != nil{
            cycleVC.view.removeFromSuperview()
        }
        headView.addSubview(cycleVC.view)
//        if tableView.tableHeaderView != nil{
//            tableView.tableHeaderView?.removeFromSuperview()
//        }
        tableView.tableHeaderView = headView
//        self.firstInit = self.firstInit + 1
    }

    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("aaa")
    }
    
    

}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (self.innerNewList == nil) ? 0 : self.innerNewList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let list = self.innerNewList[indexPath.row] as! IndexNewsModel
        var identifier:String = ""
        if list.imgextra != nil && list.imgextra.count == 2{
            identifier = "IPHONEThreeCell"
        }else{
            identifier = "IPHONEBasicCell"
        }
        
        
        let cell:NewsCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! NewsCell
        cell.titleLabel.text = list.ltitle == nil ? list.title : list.ltitle
        cell.baseImageView.sd_setImageWithURL(NSURL(string: list.imgsrc))
        cell.fromLabel.text = list.source
        if cell.otherImageView != nil && cell.otherImageView.count == 2 {
            
            var i = 0
            var dict = list.imgextra
            for i = 0; i < 2 ; i += 1 {
                let imageUrl = dict[i]
                cell.otherImageView[i].sd_setImageWithURL(NSURL(string: imageUrl["imgsrc"] as! String))
            }
            
        }
        
        cell.CommentCountButton.setTitle("\(list.replyCount)跟帖", forState: .Normal)
        
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let list = self.innerNewList[indexPath.row] as! IndexNewsModel
        if list.imgextra != nil && list.imgextra.count == 2{
            return 153.0
        }else{
            return 82.0
        }
        //        return 82.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //马上选中又取消选中
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "News", bundle:nil)
//        var detailVC = NewsDetailController()
        let detailVC = storyboard.instantiateViewControllerWithIdentifier("NewsDetailController") as! NewsDetailController
//        self.navigationController?.pushViewController(detailVC, animated: true)
        let backImage = UIImage.snapshotScreen(0).applyDarkEffect()
        let imageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, applicationW, UIScreen.mainScreen().bounds.size.height))
//        imageView.alpha = 0.3
        imageView.image = backImage
        
//        let view = UIView(frame: CGRectMake(0, 0, applicationW, UIScreen.mainScreen().bounds.size.height))
//        view.backgroundColor = UIColor.redColor()
        detailVC.backgroundView = imageView
        detailVC.view.addSubview(detailVC.backgroundView)
//        detailVC.view.sendSubviewToBack(detailVC.backgroundView)
        let cell: NewsCell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as! NewsCell

        //记录cell的位置，dismiss的时候返回该位置
        var cellFrame: CGRect = cell.frame
        cellFrame = CGRectMake(0, cellFrame.origin.y + 108 - self.tableView.contentOffset.y, cellFrame.size.width, cellFrame.size.height)
//        detailVC.cellOldFrame = cellFrame
        detailVC.cell = cell
        detailVC.news = self.innerNewList[indexPath.row] as! IndexNewsModel
//
//        detailVC.index = self.index
//        
        detailVC.cell.frame = cellFrame
        detailVC.view.addSubview(cell)

        let window = UIApplication.sharedApplication().keyWindow
        
        window!.rootViewController?.presentViewController(detailVC, animated: true, completion:{ () -> Void in
            UIView.animateWithDuration(0.3, animations: {
                cell.frame = CGRectMake(0, cellFrame.origin.y, cell.frame.size.width, cell.frame.size.height)
                
                }, completion: { (finish) in
                    UIView.animateWithDuration(0.2, animations: {
                        cell.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height/2 - (cellFrame.size.height/2), cell.frame.size.width, cell.frame.size.height)
                        }, completion: { (finish) in
                            
                            detailVC.cellOldFrame = cellFrame
                            detailVC.setUI()

                    })
            })
        })
        

    }
}

extension UIImage{
    class func snapshotScreen(y: CGFloat) -> UIImage{
        let window = UIApplication.sharedApplication().keyWindow
        let mainSize: CGSize = CGSizeMake(window!.bounds.size.width, window!.bounds.size.height);
        UIGraphicsBeginImageContextWithOptions(mainSize, false, UIScreen.mainScreen().scale)
        
        let mainRect: CGRect = CGRectMake(0, -y, window!.bounds.size.width, window!.bounds.size.height + y)
        
        window?.drawViewHierarchyInRect(mainRect, afterScreenUpdates: false)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        return image
    }
}
