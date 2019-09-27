//
//  FAQOpenCell.swift
//  SocialMedia
//
//  Created by My Technology on 07/03/2019.
//  Copyright © 2019 My Technology. All rights reserved.
//

import UIKit

class FAQOpenCell: UITableViewCell {
    @IBOutlet weak var lbl_question : UILabel!
    @IBOutlet weak var lbl_answer : UILabel!
    @IBOutlet weak var img_question : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func loadCell(faq : FaqsData){
        //        if lang == "en" {
        lbl_question.text = faq.translation.question
        lbl_answer.text = faq.translation.answer
        
        //        }
        //        else{
        //
        //        }
    }
}
