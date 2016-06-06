//
//  BaseNavViewController.swift
//  NetEaseNews
//
//  Created by yozoo on 5/8/16.
//  Copyright © 2016 yozoo. All rights reserved.
//

import UIKit

class BaseNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = UIColor(red: 215.0/255.0, green: 26.0/255.0, blue: 34.0/255.0, alpha: 1)
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
