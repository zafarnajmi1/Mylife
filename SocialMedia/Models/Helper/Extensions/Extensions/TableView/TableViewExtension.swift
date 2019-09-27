//
//  TableViewExtension.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 05/09/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit

extension UITableView {
    func scrollToBottom(animated: Bool) {
        let y = contentSize.height - frame.size.height
        setContentOffset(CGPoint(x: 0, y: (y<0) ? 0 : y), animated: animated)
    }
}
