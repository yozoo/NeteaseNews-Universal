//
//  NewsForIPADCollectionViewCell.swift
//  NetEaseNews
//
//  Created by yozoo on 5/29/16.
//  Copyright © 2016 yozoo. All rights reserved.
//

import UIKit

class NewsForIPADCollectionViewCell: UICollectionViewCell {
//    @IBOutlet var imageBlackView: UIView!
    @IBOutlet var bigImageTitleLabelY: NSLayoutConstraint!
    @IBOutlet var downLineViewW: NSLayoutConstraint!
    @IBOutlet var upLineViewW: NSLayoutConstraint!
    @IBOutlet var upLineView: UIView!
    @IBOutlet var bigImageTitleW: NSLayoutConstraint!
    @IBOutlet var NewsDetailLabel: UILabel!
    @IBOutlet var NewsTitleLabel: UILabel!
    @IBOutlet var lineView: UIView!
    @IBOutlet var NewsImageView: UIImageView!
//    var bigImageTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//        let applicationW = UIScreen.mainScreen().applicationFrame.size.width
        NewsImageView.clipsToBounds = true
//        if (applicationW < 1024) && (UIScreen.mainScreen().applicationFrame.size.height < 1024){
//            self.NewsDetailLabel?.hidden = true
//            self.NewsTitleLabel?.font = UIFont(name: "Helvetica Neue", size: 20.0)
//            //            cell.NewsDetailLabel?.text = list.digest
//        }else{
//            self.NewsDetailLabel?.hidden = false
//            self.NewsTitleLabel?.font = UIFont(name: "Helvetica Neue", size: 26.0)
//        }
    }

}
