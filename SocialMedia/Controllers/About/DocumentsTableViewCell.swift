//
//  DocumentsTableViewCell.swift
//  SocialMedia
//
//  Created by Imran Jameel on 1/22/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class DocumentsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblDocumentName: UILabel!
    @IBOutlet weak var btnDeleteDocument: UIButton!
    @IBOutlet weak var btnEditDocument: UIButton!
    @IBOutlet weak var btnViewDocument: UIButton!
    @IBOutlet var imgDocument: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
}
