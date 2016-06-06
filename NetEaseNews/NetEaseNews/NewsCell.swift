//
//  NewsCell.swift
//  NetEaseNews
//
//  Created by yozoo on 5/29/16.
//  Copyright © 2016 yozoo. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet var otherImageView: [UIImageView]!
    @IBOutlet weak var CommentCountButton: UIButton!
    @IBOutlet weak var baseImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var news:IndexNewsModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        baseImageView.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
