//
//  NewsWebViewController.swift
//  News World
//
//  Created by Pallav Trivedi on 11/02/17.
//  Copyright © 2017 Zeal Works. All rights reserved.
//

import UIKit

class NewsWebViewController: UIViewController {
    @IBOutlet weak var sourceName: UILabel!
    @IBOutlet weak var newsWebView: UIWebView!
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var heading:String?
    var url:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceName.text = heading!
        activityIndicator.center = self.view.center
        activityIndicator.transform = CGAffineTransform(scaleX: 1.75, y: 1.75)
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        newsWebView.loadRequest(URLRequest.init(url: URL(string: url!)!))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didClickOnBackButton(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
extension NewsWebViewController:UIWebViewDelegate
{
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        if (webView.isLoading)
        {
            
        }
        else
        {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}
