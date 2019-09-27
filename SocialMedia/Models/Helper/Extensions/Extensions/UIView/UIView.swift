//
//  UIView.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 15/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func origin (_ point : CGPoint){
        frame.origin.x = point.x
        frame.origin.y = point.y
    }
}

protocol Xibable { }

extension Xibable where Self: UIView {
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func setupXib() {
        backgroundColor = UIColor.clear
        let view = loadNib()
        view.frame = bounds
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|", options: [], metrics: nil, views: ["childView": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|", options: [], metrics: nil, views: ["childView": view]))
    }
}

extension UIView {
    func addBorder(edge: UIRectEdge = .top) {
        self.layer.addBorder(edge: edge)
    }
    
    func addBorder(edges: [UIRectEdge], color: UIColor = .white, thickness: CGFloat = 1) {
        self.layer.addBorder(edges: edges, color: color, thickness: thickness)
    }
    
    func addTopBorder() {
        addBorder(edge: .top)
    }
    
    func addBottomBorder() {
         addBorder(edge: .bottom)
    }
    
    func addTopBorder(color: UIColor) {
        addBorder(edge: .top, color: color)
    }
    
    func addBottomBorder(color: UIColor) {
        addBorder(edge: .bottom, color: color)
    }
    
    func addBorder(edge: UIRectEdge, color: UIColor) {
        self.layer.addBorder(edge: edge, color: color, thickness: 1)
    }
}
