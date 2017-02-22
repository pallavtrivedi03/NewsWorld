//
//  EntertainmentNewsViewController.swift
//  News World
//
//  Created by Pallav Trivedi on 12/02/17.
//  Copyright © 2017 Zeal Works. All rights reserved.
//

import UIKit

class EntertainmentNewsViewController: UIViewController {

    @IBOutlet weak var entertainmentNewsTableView: UITableView!
    @IBOutlet weak var sourceNameLabel: UILabel!
    let baseURL = "https://newsapi.org/v1/articles"
    let entertainmentWeekly = "entertainment-weekly"
    var selectedSource:String?
    let top = "top"
    let apiKey = "392468ac567e4be4a2e4936476adbeff"
    var newsResponseVO:NewsResponseVO?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if((UserDefaults.standard.string(forKey: "entertainment")) != nil)
        {
            selectedSource = (UserDefaults.standard.string(forKey: "entertainment"))
        }
        else
        {
            selectedSource = entertainmentWeekly
        }
        
        entertainmentNewsTableView.tableFooterView = UIView()
        entertainmentNewsTableView.register(UINib.init(nibName:"NewsTableViewCell",bundle:nil), forCellReuseIdentifier: "newsTableViewCell")
        callWebServiceForEntertainmentNews()
    }
    
    func callWebServiceForEntertainmentNews()
    {
        newsResponseVO = NewsResponseVO()
        let paramas = ["source":entertainmentWeekly,"sortBy":top,"apiKey":apiKey]
        ApplicationController.sharedInstance.webServiceHelper?.setCachePolicyForRequest(policy: .reloadIgnoringLocalCacheData)
        ApplicationController.sharedInstance.webServiceHelper?.getWebServiceWith(url: baseURL, params: paramas, returningVO: newsResponseVO!, completionHandler: { (vo) in
            self.newsResponseVO = vo as? NewsResponseVO
            DispatchQueue.main.async
                {
                    self.entertainmentNewsTableView.reloadData()
            }
        })
    }
    
}
extension EntertainmentNewsViewController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(newsResponseVO?.articles.count != nil)
        {
            return (newsResponseVO?.articles.count)!
        }
        else
        {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 180.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsTableViewCell", for: indexPath) as! NewsTableViewCell
        let article = (newsResponseVO?.articles[indexPath.row])! as Article
        cell.headingLabel.text = article.title
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: 351.0, height: 156.0)
        gradient.colors = [UIColor.clear.cgColor,UIColor.clear.cgColor,UIColor.white.cgColor]
        ApplicationController.sharedInstance.webServiceHelper?.downloadImageFromURL(url: article.urlToImage, completionHandler: { (image) in
            DispatchQueue.main.async
                {
                    cell.bannerImageView.image = image
                    cell.bannerImageView.layer.addSublayer(gradient)
            }
        })
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let article = (newsResponseVO?.articles[indexPath.row])! as Article
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newsWebViewController = storyBoard.instantiateViewController(withIdentifier: "newsWebViewController") as? NewsWebViewController
        newsWebViewController?.url = article.url
        newsWebViewController?.heading = "Entertainment Weekly"
        self.present(newsWebViewController!, animated: true, completion: nil)
        
    }
}

