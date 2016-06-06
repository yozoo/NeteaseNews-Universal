//
//  NewsViewControllerForIPAD.swift
//  NetEaseNews
//
//  Created by yozoo on 5/29/16.
//  Copyright © 2016 yozoo. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class NewsViewControllerForIPAD: UIViewController, UICollectionViewDelegateFlowLayout {
    var collectionPageIndex:Int = 0
    var defauleLayout: NewsListFlowLayout!
//    @IBOutlet var listLayout: NewsListLayout!
    @IBOutlet var collectionView: UICollectionView!
    var applicationW: CGFloat!
    var innerNewList: [AnyObject]!
    var indexMember: IndexNewsModel!
    var cycleMember: CycleModel!
    var channels: ChannelModel!
    var tidURLString: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        applicationW = UIScreen.mainScreen().applicationFrame.size.width
        setupCollectView()
        setupContentFlowlayout()
        tidURLString = appApi.stringByAppendingString("article/headline/T1348647853363/0-20.html")
        self.setTidString()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setTidString(){
        if (channels.tid == "T1348647853363") {//头条
            tidURLString = appApi.stringByAppendingString("article/headline/T1348647853363/0-20.html")
        }else {
            tidURLString = appApi.stringByAppendingString("article/list/\(channels.tid)/0-20.html")
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("adList") != nil{
            NSUserDefaults.standardUserDefaults().removeObjectForKey("adList")
        }
        
        self.setupData()
        
        //        }
    }
    
    private func setupData(){
        if innerNewList != nil{
            innerNewList.removeAll()
        }
        innerNewList = []
        if tidURLString == nil || tidURLString == ""{
            tidURLString = appApi.stringByAppendingString("article/headline/T1348647853363/0-20.html")
        }
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
            
            self.collectionView.reloadData()
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
//                if NSUserDefaults.standardUserDefaults().objectForKey("innerNewList") != nil{
//                    self.innerNewList = NSUserDefaults.standardUserDefaults().objectForKey("innerNewList") as! [AnyObject]
//                }
            })
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        
        if applicationW != UIScreen.mainScreen().applicationFrame.size.width{
            applicationW = UIScreen.mainScreen().applicationFrame.size.width
            var collectionViewOffset:CGPoint = self.collectionView.contentOffset
            collectionViewOffset.x = (applicationW-67) * CGFloat(collectionPageIndex)
            print(collectionViewOffset.x)
            self.collectionView.setContentOffset(collectionViewOffset, animated: true)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.setupContentFlowlayout()
                self.collectionView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupCollectView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func setupContentFlowlayout(){
        defauleLayout = NewsListFlowLayout()
        let height:CGFloat = UIScreen.mainScreen().applicationFrame.size.height-44
        if applicationW == 1024{
            self.defauleLayout.itemSize = CGSizeMake((applicationW-67)/3, height/2)
        }else if applicationW < 1024{
            self.defauleLayout.itemSize = CGSizeMake((applicationW-67)/2, height/3)
        }
        self.defauleLayout.minimumInteritemSpacing = 0
        self.defauleLayout.minimumLineSpacing = 0
        self.defauleLayout.scrollDirection = .Horizontal
        self.collectionView.setCollectionViewLayout(defauleLayout, animated: true)
    }

}

extension NewsViewControllerForIPAD: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        return 5
        return (self.innerNewList == nil) ? 0 : self.innerNewList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell:NewsForIPADCollectionViewCell!
        if cell != nil{
            cell = nil
        }
        if self.innerNewList == nil || self.innerNewList.count == 0{
            return UICollectionViewCell()
        }
        var itemH:CGFloat = 0
        let list = self.innerNewList[indexPath.row] as! IndexNewsModel
        var identifier:String = ""
        let index = indexPath.item % 5
        if (applicationW < 1024) && (UIScreen.mainScreen().applicationFrame.size.height+20 < 1024){
            itemH = (UIScreen.mainScreen().applicationFrame.size.height-44) / 3
            
            if index == 0{
                identifier = "SplitBigCell"
            }else{
                identifier = "SplitSmallCell"
            }
        }else{
            itemH = (UIScreen.mainScreen().applicationFrame.size.height-44) / 2
            
            if index == 0{
                identifier = "BigCell"
            }else{
                identifier = "SmallCell"
            }
        }
        
        if (applicationW < 800){
            itemH = (UIScreen.mainScreen().applicationFrame.size.height-44) / 3
        }
        
        
        cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! NewsForIPADCollectionViewCell
        if index == 0{
            cell.bigImageTitleLabelY.constant = itemH/2 - 20
            cell.bigImageTitleW.constant = (self.defauleLayout.itemSize.width*2-92)/2
            cell.upLineViewW.constant = (self.defauleLayout.itemSize.width*2-92)/2 + 50
            cell.downLineViewW.constant = (self.defauleLayout.itemSize.width*2-92)/2 - 100
        }
        cell.NewsImageView.sd_setImageWithURL(NSURL(string: list.imgsrc))
        cell.NewsTitleLabel.text = list.ltitle == nil ? list.title : list.ltitle
        cell.NewsDetailLabel?.text = list.digest
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "News", bundle:nil)
        //        var detailVC = NewsDetailController()
        let detailVC = storyboard.instantiateViewControllerWithIdentifier("NewsDetailController") as! NewsDetailController
        detailVC.news = self.innerNewList[indexPath.row] as! IndexNewsModel
        self.navigationController!.pushViewController(detailVC, animated: true)
        
        //        detailVC.setUI()
    }

    
    /** 滚动结束（手势导致） */
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    /** 滚动结束后调用（代码导致） */
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        // 获得索引
        let index: Int = Int(scrollView.contentOffset.x / self.collectionView.frame.size.width)
        collectionPageIndex = index
    }
}
