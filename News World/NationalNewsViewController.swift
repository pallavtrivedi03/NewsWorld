//
//  NationalNewsViewController.swift
//  News World
//
//  Created by Pallav Trivedi on 11/02/17.
//  Copyright © 2017 Zeal Works. All rights reserved.
//

import UIKit

class NationalNewsViewController: UIViewController {
    @IBOutlet weak var sourceName: UILabel!

    @IBOutlet weak var nationalPickerView: UIPickerView!
    @IBOutlet weak var nationalNewsTableView: UITableView!
    let baseURL = "https://newsapi.org/v1/articles"
    let TOI = "the-times-of-india"
    let top = "top"
    var selectedSource:String?
    let apiKey = "392468ac567e4be4a2e4936476adbeff"
    let pickerDataSource = ["ABC News","BBC News","CNN","Google News","Mirror","The Guardian","The New York Times","The Telegraph","The Times of India","Time"]
    var newsResponseVO:NewsResponseVO?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if((UserDefaults.standard.string(forKey: "political")) != nil)
        {
            selectedSource = (UserDefaults.standard.string(forKey: "political"))
        }
        else
        {
            selectedSource = TOI
        }
        nationalNewsTableView.tableFooterView = UIView()
        nationalNewsTableView.register(UINib.init(nibName:"NewsTableViewCell",bundle:nil), forCellReuseIdentifier: "newsTableViewCell")
        callWebServiceForNationalNews()
    }

    func callWebServiceForNationalNews()
    {
        newsResponseVO = NewsResponseVO()
        let paramas = ["source":TOI,"sortBy":top,"apiKey":apiKey]
        ApplicationController.sharedInstance.webServiceHelper?.setCachePolicyForRequest(policy: .reloadIgnoringLocalCacheData)
        ApplicationController.sharedInstance.webServiceHelper?.getWebServiceWith(url: baseURL, params: paramas, returningVO: newsResponseVO!, completionHandler: { (vo) in
            self.newsResponseVO = vo as? NewsResponseVO
            DispatchQueue.main.async
            {
                self.nationalNewsTableView.reloadData()
            }
        })
    }
    @IBAction func didClickOnPickerButton(_ sender: UIButton)
    {
        if (nationalPickerView.isHidden == true)
        {
            nationalPickerView.isHidden = false
        }
        else
        {
            nationalPickerView.isHidden = true
        }
    }
    
}
extension NationalNewsViewController:UITableViewDelegate,UITableViewDataSource
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
       newsWebViewController?.heading = "The Times of India"
        self.present(newsWebViewController!, animated: true, completion: nil)

    }
}
extension NationalNewsViewController:UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
}
