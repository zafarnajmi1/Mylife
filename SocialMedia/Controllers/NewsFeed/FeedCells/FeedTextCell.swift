//
//  FeedTextCell.swift
//  SocialMedia
//
//  Created by iOSDev on 10/24/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit



protocol  FeedTextCellDelegate: class {
    func refreshFeedTextCellTableView()
}

class FeedTextCell: UITableViewCell {
let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
   // @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblFeeling: UILabel!
    @IBOutlet var lblStatus: UITextView!
    @IBOutlet var lblfeelingLocation: UILabel!
    
    @IBOutlet weak var imgFeeling: UIImageView!
    @IBOutlet weak var viewContainerBottom: UIView!
    
    @IBOutlet weak var oltLike: UIButton!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var actionLikes: UIButton!
    
    @IBOutlet weak var oltComments: UIButton!
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var actionComments: UIButton!
    
    @IBOutlet weak var oltShares: UIButton!
    @IBOutlet weak var lblShares: UILabel!
    @IBOutlet weak var actionShares: UIButton!
    @IBOutlet weak var actionprofile: UIButton!

    @IBOutlet weak var oltRemovePost: UIButton!
    
    
    
    @IBOutlet var moreBtnWitdth: NSLayoutConstraint!
    
    @IBOutlet var moreBtn: UIButton!
    
    
    
    var delegate: FeedTextCellDelegate!
    var myController: UIViewController!
    
    fileprivate var postId: Int!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblUserName.font = CommonMethods.getFontOfSize(size: 14) 
        lblStatus.font = CommonMethods.getFontOfSize(size: 12)
        
        lblLikes.font = CommonMethods.getFontOfSize(size: 10)
        lblComments.font = CommonMethods.getFontOfSize(size: 10)
        lblShares.font = CommonMethods.getFontOfSize(size: 10)
    
        oltRemovePost.isHidden = true
        
        if(lang == "ar")
        {
            lblStatus.textAlignment = .right
            lblUserName.textAlignment = .right
        }else
        {
            lblStatus.textAlignment = .left
            lblUserName.textAlignment = .left
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData( myId: Int , userId: Int, postId: Int) {
        if myId == userId {
            self.moreBtnWitdth.constant = 0
            
        }
        else {
            self.moreBtn.setTitle("...", for: .normal)
            self.moreBtnWitdth.constant = 25 //20
            self.postId = postId
        }
    } 
    
    @IBAction func moreBtnTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "".localized, message: "Are you sure! you want to report this post".localized, preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "No".localized, style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { action in
            self.requestToReportByPostId()
        }))
        if  myController != nil{
            self.delegate = myController as! FeedTextCellDelegate?
            self.myController.present(alert, animated: true)
        }
        
         //menow
        
        
    }
}



extension FeedTextCell {
    
    func requestToReportByPostId () {
        
        
        PostManager.shared.reportPostBy(postId: self.postId ,  completion: { (error, rootModel) in
            
            if error == nil {
                let alertView = AlertView.prepare(title: "", message: (rootModel?.message!)!, okAction: {
                    self.delegate.refreshFeedTextCellTableView()
                })
                self.myController.present(alertView, animated: true, completion: nil)
                
            }
            else {
                self.myController.showError(message: error!)
            }
        })
        
    }
}


