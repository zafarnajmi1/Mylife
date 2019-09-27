//
//  ChatCells.swift
//  SocialMedia
//
//  Created by Macbook on 17/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//


import UIKit

class ChatsTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
//////Receved
class SenderCell: UITableViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var messageBackground: UIImageView!
   
    @IBOutlet var senderName: UILabel!
    
    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
        self.messageBackground.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        self.profilePic.layer.cornerRadius = self.profilePic.frame.height/2
      //  self.profilePic.layer.borderColor = CommonMethods.getAppColor().cgColor
        self.profilePic.layer.borderWidth = 0.5
        self.profilePic.contentMode = .scaleAspectFill
        self.profilePic.clipsToBounds = true
        
        //self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        //self.message.font = UIFont (name: Constants.AppFont.halvaticaThin, size: 20.0)
        
        self.message.font = UIFont(name:"Times New Roman", size: 20.0)
        self.messageBackground.layer.cornerRadius = 15
        self.messageBackground.clipsToBounds = true
    }
}
//////sender
// MARK: - Delegates - Protocols
protocol tapOnMessageAttachement {
    
    func sendCellIndex(cell: SenderCellWithImage)
}

class SenderCellWithImage: UITableViewCell {
    
    var delegate:tapOnMessageAttachement!
    
    @IBOutlet weak var videoPlayerButton: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var messageAttachment: UIImageView!
    @IBOutlet weak var imOverlayForVideoAttachement: UIImageView!
    @IBOutlet weak var lblDateTime: UILabel!
   

    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        self.profilePic.layer.cornerRadius = self.profilePic.frame.height/2
        //  self.profilePic.layer.borderColor = CommonMethods.getAppColor().cgColor
        self.profilePic.layer.borderWidth = 0.5
        self.profilePic.contentMode = .scaleAspectFill
        self.profilePic.clipsToBounds = true
        
        // self.message.font = UIFont (name: Constants.AppFont.halvaticaThin, size: 16.0)
        
        self.messageBackground.layer.cornerRadius = 15
        self.messageBackground.clipsToBounds = true
        self.messageAttachment.layer.cornerRadius = 10
        self.messageAttachment.clipsToBounds = true
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        messageAttachment.isUserInteractionEnabled = true
        messageAttachment.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.delegate?.sendCellIndex(cell: self)
    }
    
    //MARK:- Actions
    
    @IBAction func actionVideoPlayBtn(_ sender: Any) {
        self.delegate?.sendCellIndex(cell: self)
    }
}

//////Recevoed
class ReceiverCell: UITableViewCell {
    
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var messageBackground: UIImageView!
//    @IBOutlet weak var messageBackground: UIView!
     @IBOutlet weak var messageRead: UIImageView!
    @IBOutlet weak var time: UILabel!
    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
        self.messageBackground.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        //self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
      //  self.message.font = UIFont (name: Constants.AppFont.halvaticaThin, size: 16.0)
        self.message.font = UIFont(name:"Times New Roman", size: 20.0)
        self.messageBackground.layer.cornerRadius = 15
        self.messageBackground.clipsToBounds = true
        
        
        
        
        
        
        
        
    }
}

protocol tapOnMessageAttachementReciever {
    
    func ReceiverSendCellIndex(cell: RecieverCellWithAttachment)
}

class RecieverCellWithAttachment: UITableViewCell {
    
    var delegate:tapOnMessageAttachementReciever!
    
    @IBOutlet weak var videoPlayerButton: UIButton!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var messageAttachment: UIImageView!
 @IBOutlet weak var messageRead: UIImageView!
    @IBOutlet weak var lblDateTime: UILabel!
    
    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
 
        self.messageBackground.layer.cornerRadius = 15
        self.messageBackground.clipsToBounds = true
        self.messageAttachment.layer.cornerRadius = 10
        self.messageAttachment.clipsToBounds = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        messageAttachment.isUserInteractionEnabled = true
        messageAttachment.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.delegate?.ReceiverSendCellIndex(cell: self)
    }

//    //MARK:- Actions
    @IBAction func actionVideoPlayBtn(_ sender: Any) {
        self.delegate?.ReceiverSendCellIndex(cell: self)
    }
}

