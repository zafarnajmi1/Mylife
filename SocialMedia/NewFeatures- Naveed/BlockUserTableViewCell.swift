//
//  BlockUserTableViewCell.swift
//  SocialMedia
//
//  Created by My Technology on 21/12/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import SDWebImage


protocol BlockUserTableViewCellDelegate: class {
    func refreshTablView()
}

class BlockUserTableViewCell: UITableViewCell {

     //MARK: Outlets
    
    @IBOutlet var myImage: UIImageView!
    @IBOutlet var myTitle: UILabel!
    @IBOutlet var unblockBtn: UIButton!
    //MARK: Properties
    var myController: UIViewController!
    var userId: Int!
    var delegate: BlockUserTableViewCellDelegate!
    
    
     //MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.unblockBtn.setTitle("Unblock".localized, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    //MARK: Base Config
    
    func setData(model: BlockedUserDataModel) {
        self.userId = model.id!
        
        self.myTitle.text = model.full_name
      
        self.myImage.sd_setImage(with: URL(string:model.image!), placeholderImage: UIImage(named: "placeHolderGenral"))
        
        self.myImage.sd_setShowActivityIndicatorView(true)
        self.myImage.sd_setIndicatorStyle(.gray)
        self.myImage.clipsToBounds = true
        self.myImage.roundWithClearColor()
    }
    
    //MARK: Actions
    
    
    @IBAction func unblockBtnTapped(_ sender: Any) {
        self.requestToUnblockUserById()
    }
    
}


extension BlockUserTableViewCell {
    
    func requestToUnblockUserById () {
        
        
        UserBlockManager.shared.unblockUserBy(userId: userId, completion: { (error, rootModel) in
            
            if error == nil {
                let alertView = AlertView.prepare(title: "".localized, message: ((rootModel?.message!)?.localized)!, okAction: { 
                    self.delegate.refreshTablView()
                })
                self.myController.present(alertView, animated: true, completion: nil)
                
            }
            else {
                self.myController.showError(message: error!)
            }
        })
        
    }
}
