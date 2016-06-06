//
//  NewsListFlowLayout.swift
//  NetEaseNews
//
//  Created by yozoo on 6/1/16.
//  Copyright © 2016 yozoo. All rights reserved.
//

import UIKit

class NewsListFlowLayout: UICollectionViewFlowLayout {
    var attrsArray:[UICollectionViewLayoutAttributes] = []
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let applicationW = UIScreen.mainScreen().applicationFrame.size.width
        let collectionViewW:CGFloat = self.collectionView!.frame.size.width
        var width:CGFloat!
        var height:CGFloat!
        
        let attrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        let i = indexPath.item
        if applicationW == 1024{
            width = collectionViewW / 3
            height = self.collectionView!.frame.size.height/2
            
            if (i%5==0) {
                attrs.frame = CGRectMake(collectionViewW*(CGFloat(i/5)), 0, width*2, height)
            }else if (i%5==1){
                attrs.frame = CGRectMake((width*2)+collectionViewW*(CGFloat(i/5)), 0, width, height)
            }else if (i%5==2){
                attrs.frame = CGRectMake(collectionViewW*(CGFloat(i/5)), height, width, height)
            }else if (i%5==3){
                attrs.frame = CGRectMake(width+collectionViewW*(CGFloat(i/5)), height, width, height)
            }else if (i%5==4){
                attrs.frame = CGRectMake((width*2)+collectionViewW*(CGFloat(i/5)), height, width, height)
            }
        }else if applicationW < 1024{
            width = collectionViewW / 2
            height = self.collectionView!.frame.size.height/3
            
            if (i%5==0) {
                attrs.frame = CGRectMake(collectionViewW*(CGFloat(i/5)), 0, width*2, height)
            }else if (i%5==1){
                attrs.frame = CGRectMake(collectionViewW*(CGFloat(i/5)), height, width, height)
            }else if (i%5==2){
                attrs.frame = CGRectMake(width+collectionViewW*(CGFloat(i/5)), height, width, height)
            }else if (i%5==3){
                attrs.frame = CGRectMake(collectionViewW*(CGFloat(i/5)), height*2, width, height)
            }else if (i%5==4){
                attrs.frame = CGRectMake(width+collectionViewW*(CGFloat(i/5)), height*2, width, height)
            }
        }
        
        return attrs
    }
    
    override func prepareLayout() {
        attrsArray.removeAll()
        super.prepareLayout()
        let count = self.collectionView?.numberOfItemsInSection(0)
        var i:Int = 0
        for i = 0; i < count; i += 1 {
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            let attrs = self.layoutAttributesForItemAtIndexPath(indexPath)
            attrsArray.append(attrs!)
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        let collectionViewW:CGFloat = self.collectionView!.frame.size.width
        let count:Int = self.collectionView!.numberOfItemsInSection(0)
        let i = (count%5 == 4) ? count/5 : count/5 + 1
        return CGSizeMake(collectionViewW*CGFloat(i), 0)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let array = super.layoutAttributesForElementsInRect(rect)
//        return array
        return attrsArray
    }
    
}
