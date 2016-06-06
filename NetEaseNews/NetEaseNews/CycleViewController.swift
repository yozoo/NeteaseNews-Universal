//
//  CycleViewController.swift
//  NetEaseNews
//
//  Created by yozoo on 5/29/16.
//  Copyright © 2016 yozoo. All rights reserved.
//

import UIKit

class CycleViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowlayout: UICollectionViewFlowLayout!
//    var cycleMember: CycleModel!
    var adIndex: Int = 0
    var adList: [AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
//        if NSUserDefaults.standardUserDefaults().objectForKey("adList") != nil{
//            NSUserDefaults.standardUserDefaults().removeObjectForKey("adList") 
//        }
        self.setupCollectView()
//        self.loadData()
        
    }
    
    override func viewWillLayoutSubviews() {
        self.loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
        let width:CGFloat = UIScreen.mainScreen().applicationFrame.size.width
        let height:CGFloat = self.collectionView.frame.size.height
        print("height:\(height)")
        self.flowlayout.itemSize = CGSizeMake(width, height)
        self.flowlayout.minimumInteritemSpacing = 0
        self.flowlayout.minimumLineSpacing = 0
    }

     func loadData(){
        if NSUserDefaults.standardUserDefaults().objectForKey("adList") != nil{
            adList = NSUserDefaults.standardUserDefaults().objectForKey("adList") as! [AnyObject]
        }
        self.view.frame.size.height = adList.count == 0 ? 0: 185 * (UIScreen.mainScreen().applicationFrame.size.width / 375)
        self.collectionView.frame.size.width = UIScreen.mainScreen().applicationFrame.size.width
        self.collectionView.frame.size.height = adList.count == 0 ? 0: 185 * (UIScreen.mainScreen().applicationFrame.size.width / 375)
        print("self.collectionView.frame.size.height:\(self.collectionView.frame.size.height)")
        self.setupContentFlowlayout()
        self.collectionView?.reloadData()
    }
    
}

extension CycleViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        return homeTopNavArray.count
        return adList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell:CycleCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CycleCollectionViewCell", forIndexPath: indexPath) as! CycleCollectionViewCell
        adIndex = indexPath.row
        cell.bigImageView.sd_setImageWithURL(NSURL(string: adList[indexPath.row]["imgsrc"] as! String))
        cell.adTitleLabel.text = adList[indexPath.row]["title"] as? String
        return cell

    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        
        let needIndex: Int = index % Int(self.adList.count)
        //    RXLog(@"%zd",needIndex);
        let indexPath = NSIndexPath(forRow: needIndex, inSection: 3/2)
        
        self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
    }
}
