//
//  HomeTopNavView.swift
//  WuFeng_User
//
//  Created by yozoo on 5/29/16.
//  Copyright © 2016 yozoo. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc protocol HomeTopNavViewDelegate {
    optional func clickLabel(startView: HomeTopNavView, didClickLabelControl tap:UITapGestureRecognizer)
}

class HomeTopNavView: UIView {

    var channelMember: ChannelModel!
    var channelList: [AnyObject] = []

//    let screenWidth = UIScreen.mainScreen().applicationFrame.maxX
    var scrollView:UIScrollView!
    var view:UIView!
    var channelTitleArray:[String] = []
    var labelArray:[UILabel] = []
    var label:UILabel!
    weak var delegate: HomeTopNavViewDelegate!
    override func awakeFromNib() {
//        self.channelList
//        NSUserDefaults.standardUserDefaults().setObject(self.channelList, forKey: "homeNavArray")
        let index:Int = 0
        NSUserDefaults.standardUserDefaults().setObject(index, forKey: "labelIndex")
        let offset:CGFloat = 0
        NSUserDefaults.standardUserDefaults().setObject(offset, forKey: "scrollViewOffset")
        self.setupArray()
        self.setupTopNavView()
    }
    
    private func setupArray(){
        let url = NSBundle.mainBundle().pathForResource("topic", ofType: "json")
        let data = NSData(contentsOfFile: url!)
        let dict = JSON(data: data!).dictionaryObject
        let dictArray = dict!["tList"];
        dictArray!.enumerateObjectsUsingBlock({(obj, idx, stop) in
            self.channelMember = ChannelModel.mj_objectWithKeyValues(obj)
            self.channelList.append(self.channelMember)
            })
//        NSUserDefaults.standardUserDefaults().setObject(self.channelList, forKey: "channelMember")
    }
    
    private func setupTopNavView(){
        if scrollView != nil{
            scrollView.removeFromSuperview()
        }
//        let device = UIDevice.currentDevice().userInterfaceIdiom
        let viewWidth = UIScreen.mainScreen().applicationFrame.size.width

        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
//        scrollView.pagingEnabled = true
        scrollView.backgroundColor = UIColor.clearColor()
        self.addSubview(scrollView)
//        }
        scrollView.frame = CGRectMake(0, 0, (viewWidth > 600) ? 66 : viewWidth, (viewWidth > 600) ? UIScreen.mainScreen().applicationFrame.size.height - 300 : 44)
        
        
        
        var labelX:CGFloat = 0;
        var labelY:CGFloat = 0;
        let labelW:CGFloat = 66;
        let labelH:CGFloat = (viewWidth > 600) ? 50 : self.scrollView.frame.size.height
        
        var i = 0
        for i = 0 ; i < self.channelList.count ;i++ {
            if (viewWidth > 600){
                labelY = CGFloat(i) * labelH
            }else{
                labelX = CGFloat(i) * labelW
            }
            label = UILabel(frame:CGRectMake(labelX, labelY, labelW, labelH))
            
            label.tag = i
            label.text = self.channelList[i].tname
            channelTitleArray.append(label.text!)
            label.textAlignment = NSTextAlignment.Center
            if NSUserDefaults.standardUserDefaults().objectForKey("labelIndex") != nil && NSUserDefaults.standardUserDefaults().objectForKey("labelIndex")as! Int == label.tag{
                label.textColor = UIColor.redColor()
                label.font = UIFont.systemFontOfSize(19.0)
            }else{
                label.textColor = UIColor(red: 85.0/255, green: 85.0/255, blue: 85.0/255, alpha: 1)
                label.font = UIFont.systemFontOfSize(15.0)
            }
            label.userInteractionEnabled = true
            
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HomeTopNavView.labelDidClick(_:))))
            //            [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelDidClick:)]];
            
            scrollView.addSubview(label)
            labelArray.append(label)
        }
        NSUserDefaults.standardUserDefaults().setObject(self.channelTitleArray, forKey: "homeNavArray")
        if (viewWidth > 600){
            scrollView.contentSize = CGSizeMake(0, labelH * CGFloat(self.channelList.count))
        }else{
            scrollView.contentSize = CGSizeMake(labelW * CGFloat(self.channelList.count), 0)
        }
        var scrollViewOffset:CGPoint = self.scrollView.contentOffset
        if NSUserDefaults.standardUserDefaults().objectForKey("scrollViewOffset") != nil{
            scrollViewOffset.x = NSUserDefaults.standardUserDefaults().objectForKey("scrollViewOffset") as! CGFloat
        }
        //左边越界处理
        
        //右边越界处理
        let maxOffset:CGFloat = (self.scrollView.contentSize.width - self.scrollView.frame.size.width)
        if maxOffset < 0{
            return
        }
        if (scrollViewOffset.x > maxOffset) {
            if (scrollViewOffset.x <= 0) {
                scrollViewOffset.x = 0
            }else{
                scrollViewOffset.x = maxOffset
            }
        }else if(scrollViewOffset.x <= 0){
            scrollViewOffset.x = 0
        }
        scrollView.setContentOffset(scrollViewOffset, animated: false)
    }
    
    override func drawRect(rect: CGRect) {
        //    NSNotificationCenter.defaultCenter().postNotificationName("topNavArrayNotification", object: array)
        self.setupTopNavView()
        
    }
    
    func labelDidClick(tap:UITapGestureRecognizer){
        
        self.delegate.clickLabel!(self, didClickLabelControl: tap)
//        NSNotificationCenter.defaultCenter().postNotificationName("labelTapNotification", object: tag)
        
    }

}

extension HomeTopNavView: UIScrollViewDelegate{
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let index:NSInteger = Int(scrollView.contentOffset.x) / Int(scrollView.bounds.size.width)
        
        let label:UILabel = self.labelArray[index]
        var offset:CGPoint = self.scrollView.contentOffset
        
        offset.x = label.center.x - scrollView.frame.size.width * 0.5
        
//        self.scrollView.setContentOffset(offset, animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        let scale:CGFloat = scrollView.contentOffset.x / scrollView.bounds.size.width;
//        var leftIndex:NSInteger = Int(scrollView.contentOffset.x) / Int(scrollView.bounds.size.width)
//        
//        let leftLabel:UILabel = self.labelArray[leftIndex];
//        
//        let rightIndex:NSInteger = leftIndex + 1;
//        
//        let rightLabel:UILabel = self.labelArray[rightIndex];
//        
////        //获取变化比例
////        let rightScale:CGFloat = scale - CGFloat(leftIndex)
////        let leftScale:CGFloat = 1 - rightScale
////        
////        leftLabel.textColor = UIColor(red: leftScale, green: 0, blue: 0, alpha: 1)
////        rightLabel.textColor = UIColor(red: rightScale, green: 0, blue: 0, alpha: 1)
////        
//        //防止数组越界
//        if (leftIndex == self.scrollView.subviews.count) {
//            return;
//        }

    }
}
