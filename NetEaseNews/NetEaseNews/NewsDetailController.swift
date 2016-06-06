//
//  NewsDetailController.swift
//  NetEaseNews
//
//  Created by yozoo on 5/29/16.
//  Copyright © 2016 yozoo. All rights reserved.
//

import UIKit
import WebKit
import YLProgressBar

class NewsDetailController: UIViewController, WKNavigationDelegate {
    @IBOutlet var barView: UIView!
    var webView: WKWebView!
    var progressBar: YLProgressBar!
//    @IBOutlet var mainView: UITableView!
    var backgroundView: UIImageView!
    var cellOldFrame: CGRect!
    var cell: NewsCell!
    var news: IndexNewsModel!
    var index: NSInteger!
    var applicationW: CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .Default
        applicationW = UIScreen.mainScreen().applicationFrame.size.width
        
        self.setupWebView()
        if applicationW > 600{
            self.webView.frame = CGRectMake(0, 64, self.applicationW, UIScreen.mainScreen().bounds.size.height-64)
            self.barView.frame = CGRectMake(0, 0, self.applicationW, 64)
            self.view.bringSubviewToFront(self.webView)
            self.loadWebData()
        }
    }
    
    func setupWebView(){
        let config = WKWebViewConfiguration()
        //加载本地js文件
        let scriptURL = NSBundle.mainBundle().pathForResource("myjs", ofType: "js")
        let scriptContent = try! String(contentsOfFile: scriptURL!, encoding: NSUTF8StringEncoding)
        
        
        let script = WKUserScript(source: scriptContent, injectionTime: .AtDocumentStart, forMainFrameOnly: true)
        
        config.userContentController.addUserScript(script)
        self.webView = WKWebView(frame: CGRectMake(0, 0, applicationW, self.view.frame.height-64), configuration: config)
        self.webView.navigationDelegate = self
        
        self.view.addSubview(self.webView)
        self.setupProgressBar()
    }
    
    func loadWebData(){
        var label:UILabel!
        self.webView.scrollView.delegate = self
        if news.url != nil{
            if label != nil{
                label.removeFromSuperview()
            }
            self.webView.loadRequest(NSURLRequest(URL: NSURL(string: news.url)!))
        }else{
            label = UILabel(frame: CGRectMake(0,self.view.frame.size.height/2,applicationW,60))
            label.text = "暂不支持图片预览，后续更新"
            label.textColor = UIColor.redColor()
            label.textAlignment = .Center
            label.font = UIFont(name: "Helvetica Neue Light", size: 30.0)
            self.view.addSubview(label)
            self.view.bringSubviewToFront(label)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUI() {
        if applicationW != UIScreen.mainScreen().applicationFrame.size.width{
            applicationW = UIScreen.mainScreen().applicationFrame.size.width
        }
        progressBar.hidden = false
        let viewY:CGFloat = self.cell != nil ? (self.cell.frame.origin.y + self.cell.frame.size.height) : 0
        let barY: CGFloat = -180
    
        self.webView.frame = CGRectMake(0, viewY, applicationW, 0)
        self.webView.backgroundColor = UIColor.whiteColor()
        self.barView.frame = CGRectMake(0, barY, applicationW, 0);
        self.view.bringSubviewToFront(self.webView)
        self.view.bringSubviewToFront(self.barView)
        self.view.bringSubviewToFront(self.progressBar)
        self.viewOpenAnimation()
    
    }
    
    func viewOpenAnimation() {
        UIView.animateWithDuration(0.2, animations: {
            self.cell.frame = CGRectMake(0, -self.cellOldFrame.size.height, self.applicationW, self.cellOldFrame.size.height)
//            self.barView.frame = CGRectMake(0, 0, self.applicationW, 64)
            self.webView.frame = CGRectMake(0, 64, self.applicationW, UIScreen.mainScreen().bounds.size.height-64)
            self.barView.frame = CGRectMake(0, 0, self.applicationW, 64)
            }) { (finish) in
                self.loadWebData()
        }

    }
    
    @IBAction func backAction(sender: UIButton) {
        backToNews()
    }
    
    func backToNews() {
        if applicationW > 600{
            self.navigationController?.popToRootViewControllerAnimated(true)
            self.webView.scrollView.delegate = nil
            UIApplication.sharedApplication().statusBarStyle = .LightContent
            return
        }
        self.progressBar.hidden = true
        UIView.animateWithDuration(0.6, animations: {
            
            let viewY:CGFloat = self.cell.frame.origin.y + self.cell.frame.size.height
            self.cell.frame = self.cellOldFrame
            self.webView.frame = CGRectMake(0, viewY, self.applicationW, 0)
            self.barView.frame = CGRectMake(0, viewY, self.applicationW, 0)
            
        }) { (finish) in
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((UInt64(0.1) * UInt64(NSEC_PER_SEC)))), dispatch_get_main_queue(), {
                self.dismissViewControllerAnimated(false, completion: {
                    self.webView.scrollView.delegate = nil
                    UIApplication.sharedApplication().statusBarStyle = .LightContent
                })
            })
        }
        
    }
    
    func setupProgressBar(){
        progressBar = YLProgressBar(frame: CGRectMake(0, 64, applicationW, 4))
        progressBar.type = .Flat
        progressBar.indicatorTextDisplayMode = .None
        progressBar.behavior = .Default
        progressBar.stripesOrientation = .Vertical
        progressBar.setProgress(0, animated: true)
        progressBar.hidden = false
        self.view.addSubview(progressBar)
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        setUI()
    }
}

extension NewsDetailController: UITableViewDelegate, UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        return UITableViewCell()
    }
}

// MARK: ViewController -
private typealias wkNavigationDelegate = NewsDetailController
extension wkNavigationDelegate {
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
//        self.webView.addObserver(self, forKeyPath: "webView.scrollView.contentSize", options: .New, context: nil)

//                //监听进度和标题的变化
//        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
//        self.webView.addObserver(self, forKeyPath: "title", options: .New, context: nil)
    }
    //加载完成
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!){
//        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
//        self.webView.removeObserver(self, forKeyPath: "title")
    }
    // MARK: - 加载错误处理
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog(error.debugDescription)
        //        loadingView.removeFromSuperview()
    }
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog(error.debugDescription)
    }
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!){
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.y / (scrollView.contentSize.height - 600)
        
        progressBar.setProgress(progress, animated: true)
    }
}

