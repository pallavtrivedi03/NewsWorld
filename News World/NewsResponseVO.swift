//
//  NationalNewsResponseVO.swift
//  News World
//
//  Created by Pallav Trivedi on 11/02/17.
//  Copyright © 2017 Zeal Works. All rights reserved.
//

import UIKit

class NewsResponseVO: NSObject
{
    var articles = [Article]()
}
extension NewsResponseVO:WebServiceResponseVO
{
    func setData(response: Any)
    {
        if(response is [String:Any])
        {
            let dictionary = response as! [String:Any]
            let tempArticles = dictionary["articles"] as! [[String:Any]]
            for tempArticle in tempArticles
            {
                var article = Article()
                if let author = tempArticle["author"]! as? String
                {
                    article.author = author
                }
                if let description = tempArticle["description"]! as? String
                {
                    article.description = description
                }
                if let publishedAt = tempArticle["publishedAt"]! as? String
                {
                    article.publishedAt = publishedAt
                }
                if let title = tempArticle["title"]! as? String
                {
                    article.title = title
                }
                if let url = tempArticle["url"]! as? String
                {
                    article.url = url
                }
                if let urlToImage = tempArticle["urlToImage"]! as? String
                {
                    article.urlToImage = urlToImage
                }
                articles.append(article)
            }
        }
    }
}
