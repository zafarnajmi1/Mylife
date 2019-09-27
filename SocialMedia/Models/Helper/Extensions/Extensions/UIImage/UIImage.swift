//
//  UIImage.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 30/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit
import GPUImage

extension UIImage {
    func applyBlurEffect(radius: Float) -> UIImage {
        let imageToBlur = CIImage(image: self)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter?.setValue(radius, forKey: kCIInputRadiusKey)
        blurfilter?.setValue(imageToBlur, forKey: "inputImage")
        let resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage
        let blurredImage = UIImage(ciImage: resultImage)
        
        return blurredImage
    }
    
    func gaussainBlur(radius: Float = 0.6) -> UIImage {
        let image = self
        let filter = GaussianBlur()
        filter.blurRadiusInPixels = radius
        let filteredImage = image.filterWithOperation(filter)
        
        return filteredImage
    }
}

//extension UIImage {
//    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(size, false, 0)
//        color.setFill()
//        UIRectFill(CGRectMake(0, 0, size.width, size.height))
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
//    
//    func imageWithColor(tintColor: UIColor) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
//        
//        let context = UIGraphicsGetCurrentContext()! as CGContextRef
//        CGContextTranslateCTM(context, 0, self.size.height)
//        CGContextScaleCTM(context, 1.0, -1.0);
//        CGContextSetBlendMode(context, CGBlendMode.Normal)
//        
//        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
//        CGContextClipToMask(context, rect, self.CGImage)
//        tintColor.setFill()
//        CGContextFillRect(context, rect)
//        
//        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
//        UIGraphicsEndImageContext()
//        
//        return newImage
//        
//    }
//}
