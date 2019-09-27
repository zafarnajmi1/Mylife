//
//  FeedImageCell.swift
//  SocialMedia
//
//  Created by Macbook on 23/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit


protocol  FeedImageCellDelegate: class {
    func refreshTableView()
}

class FeedImageCell: UITableViewCell {
let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet var viewBottomTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewMultipleFeedImages: UIView!
    @IBOutlet weak var imgFeedImage1: UIImageView!
    @IBOutlet weak var imgFeedImage2: UIImageView!
    @IBOutlet weak var imgFeedImage3: UIImageView!
    @IBOutlet weak var imgFeeling: UIImageView!
    @IBOutlet weak var labelFeeling: UILabel!
    
    @IBOutlet var lblfeelingLocation: UILabel!
    @IBOutlet weak var btnAllImages: UIButton!
    @IBOutlet weak var btnMoreFeedImages: UIButton!
    @IBOutlet var imgFeed: UIImageView!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var actionprofile: UIButton!

    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblTime: UILabel!
    //@IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblDescription: UITextView!
    
    @IBOutlet var viewContainerBottom: UIView!
    
    @IBOutlet var oltLike: UIButton!
    @IBOutlet var lblLike: UILabel!
    @IBOutlet weak var actionLike: UIButton!
    
    @IBOutlet var oltComment: UIButton!
    @IBOutlet var lblComment: UILabel!
    @IBOutlet weak var actionComment: UIButton!
    
    @IBOutlet var oltShare: UIButton!
    @IBOutlet var lblShare: UILabel!
    @IBOutlet weak var actionShare: UIButton!
    
    @IBOutlet weak var oltRemovePost: UIButton!
    
    @IBOutlet weak var constraintDescriptionText: NSLayoutConstraint!
    
    @IBOutlet var moreBtnWitdth: NSLayoutConstraint!
    
    @IBOutlet var moreBtn: UIButton!
    
   
    
    var delegate: FeedImageCellDelegate!
    var myController: UIViewController!
    
    fileprivate var postId: Int!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        lblDescription.translatesAutoresizingMaskIntoConstraints = true
//        lblDescription.sizeToFit()
//        lblDescription.isScrollEnabled = false
        
        lblUserName.font = CommonMethods.getFontOfSize(size: 14)        
        lblDescription.font = CommonMethods.getFontOfSize(size: 12)
        
        lblLike.font = CommonMethods.getFontOfSize(size: 10)
        lblComment.font = CommonMethods.getFontOfSize(size: 10)
        lblShare.font = CommonMethods.getFontOfSize(size: 10)
        
        lblLike.text = "Like".localized
        lblComment.text = "Comment".localized
        lblShare.text = "Share".localized
        
        oltRemovePost.isHidden = true
        
        
        if(lang == "en")
        {
            lblUserName.textAlignment = .left
            lblDescription.textAlignment = .left
        }else
        {
            lblUserName.textAlignment = .right
            lblDescription.textAlignment = .right
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
            self.moreBtnWitdth.constant = 25 //20
            self.postId = postId
            self.moreBtn.setTitle("...", for: .normal)
        }
    }
    
    
    @IBAction func moreBtnTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "".localized, message: "Are you sure! you want to report this post".localized, preferredStyle: .alert)
        
       
        alert.addAction(UIAlertAction(title: "No".localized, style: .cancel, handler: nil))
       
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { action in
            self.requestToReportByPostId()
        }))
        if  myController != nil{
        self.delegate = myController as! FeedImageCellDelegate?
            self.myController.present(alert, animated: true)
        }
        
        
      
    }
    
    
}


extension FeedImageCell {
    
    func requestToReportByPostId () {
        
        
        PostManager.shared.reportPostBy(postId: self.postId ,  completion: { (error, rootModel) in
            
            if error == nil {
                let alertView = AlertView.prepare(title: "", message: (rootModel?.message!)!, okAction: { 
                    self.delegate.refreshTableView()
                })
                self.myController.present(alertView, animated: true, completion: nil)
                
            }
            else {
                self.myController.showError(message: error!)
            }
        })
        
    }
}

