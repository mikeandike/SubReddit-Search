//
//  NetworkController.swift
//  SubredditSearch
//
//  Created by Michael Sacks on 12/7/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import UIKit

class NetworkController {
    
    static let baseURLString = "https://www.reddit.com/r/"
    
    static func fetchTitlesWithSearchURL(subredditName: String, completion:(posts: [Post]?, error: NSError?) -> Void) {
        
        let searchString = "\(baseURLString)\(subredditName).json"
        
        if let url = NSURL(string: searchString) {
            let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                //MARK: - Handling errors
                if let error = error {
                    completion(posts: nil, error: error)
                }
                
                guard let data = data else {
                    completion(posts: nil, error: nil)
                    return
                }
                
                let jsonObject: AnyObject
                
                do {
                    //Turns data into JSON
                    jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                } catch(let error as NSError) {
                    completion(posts: nil, error: error)
                    return
                }
                
                //MARK: - Dealing with the JSON
                var arrayOfPosts = [Post]()
                
                if let dataDictionary = jsonObject["data"] as? [String : AnyObject] {
                    if let children = dataDictionary["children"] as? [AnyObject] {
                        for dict in children {
                            if let data = dict["data"] as? [String : AnyObject] {
                                if let title = data["title"] as? String {
                                    let url = data["url"] as! String?
                                    
                                    let newPost = Post(postTitle: title, urlString: url)
                                    arrayOfPosts.append(newPost)
                                }
                            }
                        }
                        completion(posts: arrayOfPosts, error: nil)
                    }
                } else {
                    completion(posts: nil, error: nil)
                }
            }
            
            dataTask.resume()
        }
    }
    
}
