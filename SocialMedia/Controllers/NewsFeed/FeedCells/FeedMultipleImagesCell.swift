//
//  FeedMultipleImagesCell.swift
//  SocialMedia
//
//  Created by Imran Jameel on 1/20/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class FeedMultipleImagesCell: UITableViewCell {
let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet var imgFeedOne: UIImageView!
    @IBOutlet var imgFeedTwo: UIImageView!
    @IBOutlet var imgFeedThree: UIImageView!
    
    
    @IBOutlet weak var imgPlay: UIImageView!
    
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblfeelingLocation: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
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
    @IBOutlet weak var actionprofile: UIButton!

    @IBOutlet weak var oltRemovePost: UIButton!
    
    
    
    
    @IBOutlet var moreBtnWitdth: NSLayoutConstraint!
    
    @IBOutlet var moreBtn: UIButton!
    
    
    
    var delegate: FeedImageCellDelegate!
    var myController: UIViewController!
    
    fileprivate var postId: Int!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblUserName.font = CommonMethods.getFontOfSize(size: 14)
        lblDescription.font = CommonMethods.getFontOfSize(size: 12)
        
        lblLike.font = CommonMethods.getFontOfSize(size: 10)
        lblComment.font = CommonMethods.getFontOfSize(size: 10)
        lblShare.font = CommonMethods.getFontOfSize(size: 10)
        
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
        
        let alert = UIAlertController(title: "", message: "Are you sure! you want to report this post".localized, preferredStyle: .alert)
        
        
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
extension FeedMultipleImagesCell {
    
    func requestToReportByPostId () {
        
        
        PostManager.shared.reportPostBy(postId: self.postId ,  completion: { (error, rootModel) in
            
            if error == nil {
                let alertView = AlertView.prepare(title: "", message: (rootModel?.message!)!, okAction: {
                   
                })
                self.myController.present(alertView, animated: true, completion: nil)
                
            }
            else {
                self.myController.showError(message: error!)
            }
        })
        
    }
}
