//
//  CALayer.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 18/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor = UIColor.black.withAlphaComponent(0.4), thickness: CGFloat = 0.5) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect.init(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect.init(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
    func addBorder(edges: [UIRectEdge], color: UIColor = UIColor.black.withAlphaComponent(0.4), thickness: CGFloat = 0.5) {
        
        let border = CALayer()
        
        for edge in edges {
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
                break
            default:
                break
            }
        }
                
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }

}
