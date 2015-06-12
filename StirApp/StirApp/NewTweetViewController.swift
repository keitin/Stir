//
//  NewTweetViewController.swift
//  StirApp
//
//  Created by 松下慶大 on 2015/06/12.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    let placeholderLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setIconImageView()
        makePlaceholderLabel()
        tweetTextView.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "×", style: UIBarButtonItemStyle.Plain, target: self, action: "backToTimeLineViewController")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "sendTweet")
        
        //Registing Notification Center
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "willShowKeyBoard", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //lifting Notification Center
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendTweet() {
        self.tweetTextView.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func backToTimeLineViewController() {
        self.tweetTextView.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func makePlaceholderLabel() {
        placeholderLabel.frame.origin = CGPointMake(0, 8)
        placeholderLabel.text = "いまなにしてる？"
        placeholderLabel.sizeToFit()
        placeholderLabel.textColor = UIColor.grayColor()
        placeholderLabel.font = UIFont(name: "HiraKakuProN-W3", size: 15)
        tweetTextView.addSubview(placeholderLabel)
    }
    
    func setIconImageView() {
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        iconImageView.clipsToBounds = true
    }
    
    //keyBoard
    func willShowKeyBoard() {
        placeholderLabel.hidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}