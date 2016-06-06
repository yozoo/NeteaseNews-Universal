//
//  NewsContentCollectionViewCell.swift
//  NetEaseNews
//
//  Created by yozoo on 5/9/16.
//  Copyright © 2016 yozoo. All rights reserved.
//

import UIKit

class NewsContentCollectionViewCell: UICollectionViewCell {

    var newsController:NewsViewController!
    var channel: ChannelModel!
//    var _channel : ChannelModel = ChannelModel() {
//        willSet {
//            print("Old value is \(_channel), new value is \(newValue)")
//        }
//        didSet {
//            print("Old value is \(oldValue), new value is \(_channel)")
//        }
//    }
//    
//    var channel: ChannelModel{
//        get {
//            return _channel
//        }
//        set (aNewValue) {
//            //I've contrived some condition on which this property can be set
//            //(prevents same value being set)
//            if (aNewValue != channel) {
//                self.channel = aNewValue
//            }
//        }
//    }
//    
    override func awakeFromNib() {
        super.awakeFromNib()
        let newsStoryboard = UIStoryboard(name: "News", bundle: nil)
        
        self.newsController = newsStoryboard.instantiateInitialViewController() as! NewsViewController
        self.contentView.addSubview(self.newsController.view)
        
        self.newsController.view.frame = CGRectMake(0, 32, self.frame.size.width, self.frame.size.height-68)
    }
    
//    func setchannel(channels: ChannelModel){
//        self.channel = channels
//        if self.newsController.view.superview != nil{
//            self.newsController.isTop = false
//            return
//        }
//        if self.newsController.view != nil{
//            self.newsController.view.removeFromSuperview()
//        }
//        self.newsController.isTop = true
//        self.contentView.addSubview(self.newsController.view)
//        
//        self.newsController.view.frame = CGRectMake(0, 32, self.frame.size.width, self.frame.size.height-68)
//    }

}
