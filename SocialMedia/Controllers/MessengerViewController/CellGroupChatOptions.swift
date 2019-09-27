//
//  CellGroupChatOptions.swift
//  SocialMedia
//
//  Created by Mughees Musaddiq on 24/01/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

protocol CellGroupChatOptionsDelegate {
    func publicCheckClick()
    func privateCheckClick()
}

class CellGroupChatOptions: UITableViewCell {

    var delegate: CellGroupChatOptionsDelegate?
    @IBOutlet weak var btnChangGroupPhoto: UIButton!
    @IBOutlet weak var btnAddParticipants: UIButton!
    @IBOutlet weak var btnChangeGroupName: UIButton!
    @IBOutlet weak var btnPublicCheckBox: UIButton!
    @IBOutlet var viewOptions: UIStackView!
    var public_Private_Status = "public"
    @IBOutlet weak var btnPrivateCheckBox: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var btnPublic: CheckBox! {
        didSet {
            btnPublic.isChecked = true
        }
    }
    
    @IBOutlet weak var btnPrivate: CheckBox! {
        didSet {
            btnPrivate.isChecked = false
        }
    }
    
    @IBAction func actionPublic(_ sender: Any) {
        
        btnPublic.isChecked = true
        btnPrivate.isChecked = false
        btnPrivate.setImage(UIImage(named: "radio"), for: .normal)
        btnPublic.setImage(UIImage(named: "selected-radio"), for: .normal)
        public_Private_Status = "public"
        print("\(public_Private_Status)")
        if let _delegate = delegate {
            _delegate.publicCheckClick()
        }
    }
    
    @IBAction func actionPrivate(_ sender: Any) {
        
        btnPublic.isChecked = false
        btnPrivate.isChecked = true
        btnPublic.setImage(UIImage(named: "radio"), for: .normal)
        btnPrivate.setImage(UIImage(named: "selected-radio"), for: .normal)
        public_Private_Status = "private"
        print("\(public_Private_Status)")
        if let _delegate = delegate {
            _delegate.privateCheckClick()
        }

    }
    
}
