/*Copyright (c) 2016, Andrew Walz.
 
 Redistribution and use in source and binary forms, with or without modification,are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
 BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

import UIKit

class SwiftyRecordButton: SwiftyCamButton {
    
    private var circleBorder: CALayer!
    private var innerCircle: UIView!
    
    fileprivate var progressLayer: CAShapeLayer!
    fileprivate var gradientMaskLayer: CAGradientLayer!
    
    let progressColor = UIColor.red
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawButton()
    }
    
    private func drawButton() {
        self.backgroundColor = UIColor.clear
        
        circleBorder = CALayer()
        circleBorder.backgroundColor = UIColor.clear.cgColor
        circleBorder.borderWidth = 6.0
        circleBorder.borderColor = UIColor.white.cgColor
        circleBorder.bounds = self.bounds
        circleBorder.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        circleBorder.cornerRadius = self.frame.size.width / 2
        layer.insertSublayer(circleBorder, at: 0)
        
        let startAngle: CGFloat = CGFloat(Double.pi) + CGFloat(Double.pi / 2)
        let endAngle: CGFloat = CGFloat(Double.pi) * 3 + CGFloat(Double.pi / 2)
        let centerPoint: CGPoint = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        gradientMaskLayer = self.gradientMask()
        
        progressLayer = CAShapeLayer()
        progressLayer.path = UIBezierPath(arcCenter: centerPoint, radius: self.frame.size.width / 2 - 2, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        progressLayer.backgroundColor = UIColor.clear.cgColor
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.black.cgColor
        progressLayer.lineWidth = 6.0
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        gradientMaskLayer.mask = progressLayer
        
        gradientMaskLayer.mask = progressLayer
        layer.insertSublayer(gradientMaskLayer, at: 0)
    }
    
    public func growButton() {
        innerCircle = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        innerCircle.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        innerCircle.backgroundColor = UIColor.red
        innerCircle.layer.cornerRadius = innerCircle.frame.size.width / 2
        innerCircle.clipsToBounds = true
        self.addSubview(innerCircle)
        
        UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseOut, animations: {
            self.innerCircle.transform = CGAffineTransform(scaleX: 54.4, y: 54.4)
            self.circleBorder.setAffineTransform(CGAffineTransform(scaleX: 1.1, y: 1.1))
            self.circleBorder.borderWidth = (6 / 1.1)
            
        }, completion: nil)
    }
    
    fileprivate func gradientMask() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.locations = [0.0, 1.0]
        let topColor = progressColor
        let bottomColor = progressColor
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        return gradientLayer
    }
    
    public func shrinkButton() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.innerCircle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.circleBorder.setAffineTransform(CGAffineTransform(scaleX: 1.0, y: 1.0))
            self.circleBorder.borderWidth = 6.0
        }, completion: { (success) in
            self.innerCircle.removeFromSuperview()
            self.innerCircle = nil
        })
    }
    
    open func setProgress(_ newProgress: CGFloat) {
        progressLayer.strokeEnd = newProgress
    }
}