//
//  FollowersViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 09/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit

import NVActivityIndicatorView

class MyFollowingsViewController: UIViewController, NVActivityIndicatorViewable,ViewStateProtocol {
    
    @IBOutlet weak var MyFollowingstableview: UITableView!

    @IBOutlet weak var view_topHeaderView: UIView!
    // MARK: - Properties
    var  arrayDataMyFollowers  = [FollowersData]()
    var errorMessage: String? = "Please Try Again"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        view_topHeaderView.isHidden = true
        self.title = "My Followings".localized
        getMyFollowings()
        addBackButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Animation Loader
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    
    //MARK: - API Calling Function
    func getMyFollowings() {
        
        self.showLoader()
        UserHandler.myFollowings(success: { (success) in
            
            if (success.statusCode == 200)
            {
                self.stopAnimating()
                self.arrayDataMyFollowers = success.data
                if self.arrayDataMyFollowers.count > 0
                {
                    self.view_topHeaderView.isHidden = false
                    self.MyFollowingstableview.reloadData()
                }
                else
                {
                    // Create the alert controller
                    let alertController = UIAlertController(title: "Success", message: "You have no followings.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else
            {
                self.stopAnimating()
                self.displayAlertMessage(success.message)
            }
            
        })
        { (error) in
            print("error = ",error!)
            self.stopAnimating()
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            
            
            
        }
    }
    
}

// MARK: - TableView Delegate Functions
extension MyFollowingsViewController:  UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrayDataMyFollowers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyFollowings.className, for: indexPath) as! MyFollowings
        
        let arrayFollowers = arrayDataMyFollowers[indexPath.row]

        cell.imageViewProfile.sd_setImage(with: URL(string: arrayFollowers.image), placeholderImage: UIImage(named: "placeholder.png"))
        cell.imageViewProfile.sd_setShowActivityIndicatorView(true)
        cell.imageViewProfile.sd_setIndicatorStyle(.gray)
        cell.imageViewProfile.contentMode = .scaleAspectFill
        cell.imageViewProfile.clipsToBounds = true
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(userImageTapped(tapGestureRecognizer:)))
        cell.imageViewProfile.tag = indexPath.row
        cell.imageViewProfile.isUserInteractionEnabled = true
        cell.imageViewProfile.addGestureRecognizer(imageTapGesture)
        
        cell.labelName.text = arrayFollowers.fullName
        cell.labelLocation.text = ""
//        cell.labelLocation.text = arrayFollowers.email

        let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
        cell.labelName.tag = indexPath.row
        cell.labelName.isUserInteractionEnabled = true
        cell.labelName.addGestureRecognizer(userNameTapGesture)

        return cell
    }
    @objc func userNameTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let index = tapGestureRecognizer.view?.tag
        let objFollower = arrayDataMyFollowers[index!]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        controller.isFromOtherUser = true
        controller.otherUserId = objFollower.id
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc func userImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let index = tapGestureRecognizer.view?.tag
        let objFollower = arrayDataMyFollowers[index!]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        controller.isFromOtherUser = true
        controller.otherUserId = objFollower.id
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

// MARK: - Cell Class
class MyFollowings: UITableViewCell {
    
    @IBOutlet weak var imageViewProfile: UIImageView! {
        didSet {
            imageViewProfile.roundWithClearColor()
        }
    }
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelLocation: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
    }
    
}

