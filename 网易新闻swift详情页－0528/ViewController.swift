//
//  ViewController.swift
//  网易新闻swift详情页－0528
//
//  Created by YuePr on 16/5/28.
//  Copyright © 2016年 YuePr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextRequestWithUrl()
    }

    func contentTextRequestWithUrl(){
    
        let url = NSURL(string: "http://c.m.163.com/nc/article/BO2T5RF100014PRF/full.html")
        
        let request = NSURLRequest(URL: url!)
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data,respones, error) in
            if (error == nil){
                let jsonData = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)as! NSDictionary
                self.loadDetailDataHtmlWithJsonData(jsonData!)
                
            }
        }
        
        dataTask .resume()
        
    }
    

}

extension ViewController{
    func loadDetailDataHtmlWithJsonData(jsonData:NSDictionary)->Void{
    
        let allData = jsonData["BO2T5RF100014PRF"]
        var body =  allData!["body"] as! String
        let title = allData!["title"]as! String
//        let source = allData!["source"]as!String
        let ptime = allData!["ptime"]as! String
        let source  = allData!["source"]as! String
        let image = allData!["img"]as! [[String:AnyObject]]
        
        for i in 0..<image.count{
            let imageItem = image[i]
            let ref = imageItem["ref"]as! String
            let alt = imageItem["alt"]as! String
            let src = imageItem["src"]as! String
            print(src)
            
        //注意，这一段代码是根据网易新闻详情页的html代码预留的空白<div>容器将指定位置的容器替换成实体照片，
//            //根据每一则新闻图文并茂的情况不同，这些预留的空白容器位置也大体不相同
//            let imghtml = "<div class = \"img-logo\"> <img scr=\"\(src)\"/><div class=\"img-title\">\(alt)</div></div>"
            
            let imgHtml = "<div class = \"img-logo\"> <img src=\"\(src)\"/><div class=\"img-title\">\(alt)</div></div>"
            
           body =  body.stringByReplacingOccurrencesOfString(ref, withString: imgHtml)
        }
        

        let titleLogoImg = "http://img2.cache.netease.com/f2e/news/res/channel_logo/news.png";

        let titleLogoImgHtml = "<div id = \"logo\"><img src=\"\(titleLogoImg)\"/></div>"
        
        // 创建CSS样式
        let css = NSBundle.mainBundle().URLForResource("newsDetail", withExtension: "css")
        let cssHtml = "<link href=\"\(css!)\" rel=\"stylesheet\" />"
        
        // 创建JS文件
        let js = NSBundle.mainBundle().URLForResource("newsDetail", withExtension: "js")
        let jsHtml = "<script src=\"\(js!)\"></script>"
        
        
        

        let titleHtml = "<div id=\"mainTitle\">\(title)</div>"
        let subTitleHtml = "<div id=\"subTitle\"><span class=\"pTime\">\(ptime)</span><span>\(source)</span>\(titleLogoImgHtml)</div>"
        
        let html = "<html><head>\(cssHtml)</head><body>\(titleHtml)\(subTitleHtml)\(body)\(jsHtml)</body></html>"
        
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    
    ///  UIWebViewDelegate  --- 方法
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        let urlString: NSString = (request.URL?.absoluteString)!

        let urlHeader = "wangyi://"
        let range = urlString.rangeOfString(urlHeader)
        let location = range.location
        
        if(location != NSNotFound){ // 找到协议头

            let method = urlString.substringFromIndex(range.length)

            let sel = NSSelectorFromString(method)

            self.performSelector(sel)
        }
        
        return true;
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // 执行js代码
        //        webView.stringByEvaluatingJavaScriptFromString(<#T##script: String##String#>)
    }
    
    
    // 访问相册
    func openCamera() -> Void {
        let photoVC = UIImagePickerController()
        photoVC.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(photoVC, animated: true, completion: nil)
    }
    
    
}


