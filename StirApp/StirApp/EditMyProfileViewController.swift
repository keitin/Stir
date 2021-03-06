//
//  EditMyProfileViewController.swift
//  StirApp
//
//  Created by 松下慶大 on 2015/07/08.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit

class EditMyProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameTextFiled: UITextField!
    
    let photoPicker = UIImagePickerController()
    let currentUser = CurrentUser.sharedInstance
    var currentImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoPicker.delegate = self

        nameTextFiled.text = currentUser.name
        setIconImageView()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "backToMyPageVC")
        
        editButton.layer.cornerRadius = 5
        editButton.layer.masksToBounds = true
        editButton.backgroundColor = UIColor.subColor()
        setSelectImageButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setIconImageView() {
        if currentUser.image == nil {
            iconImageView.image = UIImage(named: "kinoponpopo")
        } else {
            iconImageView.image = currentUser.image
        }

        iconImageView.userInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: "openCameraRoll")
        iconImageView.addGestureRecognizer(gesture)
    
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
    }
    
    
    func openCameraRoll() {
        self.photoPicker.sourceType = .PhotoLibrary
        self.presentViewController(photoPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        currentImage = image
        iconImageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func tapEditBtn(sender: UIButton) {
        
        //更新処理
        currentUser.name = nameTextFiled.text
        currentUser.image = currentImage
        let callback = {() -> Void in
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        CurrentUser.editCurrentUser(currentUser, callback: callback)
        
    }


    @IBAction func tapSelectImageButton(sender: UIButton) {
        self.photoPicker.sourceType = .PhotoLibrary
        self.presentViewController(photoPicker, animated: true, completion: nil)
    }
    
    func setSelectImageButton() {
        let textLabel = UILabel()
        textLabel.frame.size = selectImageButton.frame.size
        textLabel.layer.position = CGPoint(x: 155, y: 15)
        textLabel.text = "Select Group Image"
        textLabel.font = UIFont(name: "Helvetica", size: 14)
        textLabel.textColor = UIColor.mainColor()
        selectImageButton.addSubview(textLabel)
    }
    
    func backToMyPageVC() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
}
