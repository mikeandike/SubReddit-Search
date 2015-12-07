//
//  Post.swift
//  SubredditSearch
//
//  Created by Michael Sacks on 12/7/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import UIKit

struct Post {
    var title: String
    var URL: NSURL?
    
    init(postTitle: String, urlString: String?) {
        self.title = postTitle
        self.URL = NSURL(string: urlString!)
    }
}
