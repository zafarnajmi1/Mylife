//
//  CellFeedMultipleImagesDeail.swift
//  SocialMedia
//
//  Created by My Technology on 22/01/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import ImageScrollView

class CellFeedMultipleImagesDeail: UITableViewCell {

    @IBOutlet weak var imgDetailImage: UIImageView!
    @IBOutlet weak var oltDownloadImage: UIButton!
    @IBOutlet weak var showImageForZoomButton: UIButton!
    @IBOutlet weak var imgScrollView: ImageScrollView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       // addDownloadButton()
    }
    
    
    
    func addDownloadButton() {
        let imageRecord = UIImage (named: "save")
        let tintedImageRecord = imageRecord?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        oltDownloadImage.setImage(tintedImageRecord, for: .normal)
        oltDownloadImage.tintColor = UIColor.clear
        oltDownloadImage.layer.cornerRadius = 20
        oltDownloadImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
