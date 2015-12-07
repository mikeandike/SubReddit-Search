//
//  ViewController.swift
//  SubredditSearch
//
//  Created by Michael Sacks on 12/7/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var postsDataSource:[Post] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func searchButtonTapped(sender: UIButton) {
        
        if let searchText = searchTextField.text {
            NetworkController.fetchTitlesWithSearchURL(searchText, completion: { (posts, error) -> Void in
                if let posts = posts {
                    self.postsDataSource = posts
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                } else if let error = error {
                    let alertController = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    
                    alertController.addAction(action)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(alertController, animated: true, completion: nil)
                    })
                    
                    
                }
            })
        }
        
    }
    
    
    
    // MARK: - TableView Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        cell.textLabel?.text = postsDataSource[indexPath.row].title
        if let url = postsDataSource[indexPath.row].URL {
            cell.detailTextLabel?.text = "\(url)"
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let url = postsDataSource[indexPath.row].URL {
            let safariViewController = SFSafariViewController(URL: url)
            self.presentViewController(safariViewController, animated: true, completion: nil)
        }
    }
}

