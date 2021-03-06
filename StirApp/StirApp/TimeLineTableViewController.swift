//
//  TimeLineTableViewController.swift
//  StirApp
//
//  Created by 松下慶大 on 2015/06/12.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit

class TimeLineTableViewController: UITableViewController {

    var tweets: Array<Tweet> = []
    var currentGroup: Group!
    let currentUser = CurrentUser.sharedInstance
    var flag: Bool = true
    var curretFakeUser: User?
    var page: Int = 1
    var myActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //セルの登録
        self.tableView.registerNib(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "TweetTableViewCell")
        
        //セルの高さを可変
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //下に引っ張ってリロード
        var refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Loading...")
        refresh.addTarget(self, action: "reloadTimeLine", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
        
        tableView.separatorColor = UIColor.clearColor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HirakakuProN-W6", size: 17)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.title = currentGroup.name
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "modalToNewTweetViewController")
        
        let callBack = { () -> Void in
            self.tweets = StockTweets.sharedInstance.tweets
            self.tableView.reloadData()
        }
        
        //ツイートをdbからフェッチ
        StockTweets.fetchTweets(currentGroup, page: page, callBack: callBack)
        
        //フェイクユーザを取得しポップアップを表示
        fetchCurrentUserInGroup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tweets.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell", forIndexPath: indexPath) as! TweetTableViewCell
        let tweet = tweets[indexPath.row]
        cell.tweetLabel?.text = tweet.text

        cell.tweetLabel.fixLabelHeight(tweet.text)
        cell.nameLabel.text = tweet.user.fakeUser?.name
        cell.iconImageView.image = tweet.user.fakeUser?.image!
        cell.timeLabel.text = tweet.time
        return cell
    }
    
    
    func fetchCurrentUserInGroup() {
        
        let callback = { (fakeUser: User, isChecked: Bool) -> Void in
            
            if !isChecked {
                let informationView = InformationView(frame: self.view.frame)
                informationView.fakeUser = fakeUser
                informationView.group = self.currentGroup
                informationView.setUpInfoView()
                self.tabBarController?.view.addSubview(informationView)
            }
        }
        
        curretFakeUser = currentUser.fetchCurrentUserInGroup(currentGroup, callback: callback)
        
    }


    func reloadTimeLine() {
        let callBack = { () -> Void in
            self.tweets = StockTweets.sharedInstance.tweets
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
        
        //ツイートをdbからフェッチ
        StockTweets.fetchTweets(currentGroup, page: page, callBack: callBack)
        
        //フェイクユーザを取得しポップアップを表示
        fetchCurrentUserInGroup()
    }
    
    
    //ページネーション
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.height) {
            leadMore()
            
            //インジケータ
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
            myActivityIndicator = UIActivityIndicatorView()
            myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
            myActivityIndicator.color = UIColor.blackColor()
            myActivityIndicator.center = footerView.center
            footerView.addSubview(myActivityIndicator)
            myActivityIndicator.startAnimating()
            self.tableView.tableFooterView = footerView
        }
    }
    
    func leadMore() {
        if tweets.count >= 15 {
            page++
        }
        let callBack = { () -> Void in
            self.tweets = StockTweets.sharedInstance.tweets
            self.tableView.reloadData()
            self.myActivityIndicator.stopAnimating()
        }
        //ツイートをdbからフェッチ
        StockTweets.fetchTweets(currentGroup, page: page, callBack: callBack)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func changeFakeUser() {
        if flag == true {
            flag = false
        } else {
            flag = true
        }
        self.tableView.reloadData()
    }
    
    //segue
    func modalToNewTweetViewController() {
        performSegueWithIdentifier("modalToNewTweetViewController", sender: nil)
    }
    
    func modalFakeUsersTableViewController() {
        performSegueWithIdentifier("modalFakeUsersTableViewController", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "modalToNewTweetViewController" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let newTweetViewController = navigationController.viewControllers.first as! NewTweetViewController
            newTweetViewController.currentGroup = self.currentGroup
        } else if segue.identifier == "modalFakeUsersTableViewController" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let fakeUserTableViewController = navigationController.viewControllers.first as! FakeUsersListTableViewController
            fakeUserTableViewController.currentGroup = self.currentGroup
        }
    }
    
    func fixLabelHeight(text: String, label: UILabel) {
        let lineHeight:CGFloat = 25.0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
    }

}
