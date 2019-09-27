//
//  TermsAndConditionTableViewCell.swift
//  SocialMedia
//
//  Created by My Technology on 20/12/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class TermsAndConditionTableViewCell: UITableViewCell {

    //MARK: - outlets
    @IBOutlet var myDetailLabel: UILabel!
    @IBOutlet var myTitleLabel: UILabel!
       

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
