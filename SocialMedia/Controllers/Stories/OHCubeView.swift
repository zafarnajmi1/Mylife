//
//  OHCubeView.swift
//  CubeController
//
//  Created by Øyvind Hauge on 11/08/16.
//  Copyright © 2016 Oyvind Hauge. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
@objc protocol OHCubeViewDelegate: class {
    
    @objc optional func cubeViewDidScroll(cubeView: OHCubeView)
}

@available(iOS 9.0, *)
public class OHCubeView: UIScrollView, UIScrollViewDelegate {
    
    weak var cubeDelegate: OHCubeViewDelegate?
    
    private let maxAngle: CGFloat = 60.0
    
    var childViews = [UIView]()
    
    lazy var stackView: UIStackView = {
        
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = NSLayoutConstraint.Axis.horizontal
        
        return sv
    }()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        configureScrollView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func addChildViews(views: [UIView]) {
        
        for view in views {
            
            view.layer.masksToBounds = true
            stackView.addArrangedSubview(view)
            
            addConstraint(NSLayoutConstraint(
                item: view,
                attribute: NSLayoutConstraint.Attribute.width,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self,
                attribute: NSLayoutConstraint.Attribute.width,
                multiplier: 1,
                constant: 0)
            )
            
            childViews.append(view)
        }
        
        /*
         let w = bounds.size.width
         let h = bounds.size.height
         
         for index in 0 ..< views.count {
         
         let view = views[index]
         
         view.frame = CGRectMake(CGFloat(index) * w, 0, w, h)
         view.layer.masksToBounds = true
         addSubview(view)
         
         childViews.append(view)
         }
         */
        //contentSize = CGSizeMake(CGFloat(childViews.count) * w, h)
    }
    
    public func addChildView(view: UIView) {
        addChildViews(views: [view])
    }
    
    public func scrollToViewAtIndex(index: Int, animated: Bool) {
        if index > -1 && index < childViews.count {
            
            let width = self.frame.size.width
            let height = self.frame.size.height

            let frame = CGRect(x: CGFloat(index)*width, y: 0, width: width, height: height)
//            let frame = CGRectMake(CGFloat(index)*width, 0, width, height)
            scrollRectToVisible(frame, animated: animated)
        }
    }
    
    // MARK: Scroll view delegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        transformViewsInScrollView(scrollView: scrollView)
        cubeDelegate?.cubeViewDidScroll?(cubeView: self)
    }
    
    // MARK: Private methods
    
    private func configureScrollView() {
        
        // Configure scroll view properties
        
        backgroundColor = UIColor.black
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        isPagingEnabled = true
        bounces = true
        delegate = self
        
        // Add layout constraints
        
        addSubview(stackView)
        
        addConstraint(NSLayoutConstraint(
            item: stackView,
            attribute: NSLayoutConstraint.Attribute.leading,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.leading,
            multiplier: 1,
            constant: 0)
        )
        
        addConstraint(NSLayoutConstraint(
            item: stackView,
            attribute: NSLayoutConstraint.Attribute.top,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.top,
            multiplier: 1,
            constant: 0)
        )
        
        addConstraint(NSLayoutConstraint(
            item: stackView,
            attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.height,
            multiplier: 1,
            constant: 0)
        )
        
        addConstraint(NSLayoutConstraint(
            item: stackView,
            attribute: NSLayoutConstraint.Attribute.centerY,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.centerY,
            multiplier: 1,
            constant: 0)
        )
        
        addConstraint(NSLayoutConstraint(
            item: self,
            attribute: NSLayoutConstraint.Attribute.trailing,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: stackView,
            attribute: NSLayoutConstraint.Attribute.trailing,
            multiplier: 1,
            constant: 0)
        )
        
        addConstraint(NSLayoutConstraint(
            item: self,
            attribute: NSLayoutConstraint.Attribute.bottom,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: stackView,
            attribute: NSLayoutConstraint.Attribute.bottom,
            multiplier: 1,
            constant: 0)
        )
    }
    
    private func transformViewsInScrollView(scrollView: UIScrollView) {
        
        let xOffset = scrollView.contentOffset.x
        let svWidth = scrollView.frame.width
        var deg = maxAngle / bounds.size.width * xOffset
        
        for index in 0 ..< childViews.count {
            
            let view = childViews[index]
            
            deg = index == 0 ? deg : deg - maxAngle
            let rad = deg * CGFloat(M_PI) / 180
            
            var transform = CATransform3DIdentity
            transform.m34 = 1 / 500
            transform = CATransform3DRotate(transform, rad, 0, 1, 0)
            
            view.layer.transform = transform
            
            let x = xOffset / svWidth > CGFloat(index) ? 1.0 : 0.0
            setAnchorPoint(anchorPoint: CGPoint(x: x, y: 0.5), forView: view)
            
            applyShadowForView(view: view, index: index)
        }
    }
    
    private func applyShadowForView(view: UIView, index: Int) {
        
        let w = self.frame.size.width
        let h = self.frame.size.height
        
        let r1 = frameFor(origin: contentOffset, size: self.frame.size)
        let r2 = frameFor(origin: CGPoint(x: CGFloat(index)*w, y: 0),
                          size: CGSize(width: w, height: h))
        
        // Only show shadow on right-hand side
        if r1.origin.x <= r2.origin.x {
            
            let intersection = r1.intersection(r2)
            let intArea = intersection.size.width*intersection.size.height
            let union = r1.union(r2)
            let unionArea = union.size.width*union.size.height
            
            view.layer.opacity = Float(intArea / unionArea)
        }
    }
    
    private func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
//        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
//        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)

        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    private func frameFor(origin: CGPoint, size: CGSize) -> CGRect {
        return CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height)
    }
}
