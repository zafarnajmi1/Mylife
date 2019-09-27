//
//  DisplayZoomableImageViewController.swift
//  SocialMedia
//
//  Created by Imran Jameel on 3/19/18.
//  Copyright © 2018 My Technology. All rights reserved.
//


import UIKit

class DisplayZoomableImageViewController: UIViewController,UIScrollViewDelegate {

    var image = UIImage()
    var urlString =  String()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollImg: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vWidth = self.view.frame.width
        let vHeight = self.view.frame.height
        
        imageView.sd_setImage(with: URL(string: String(describing: urlString)), placeholderImage: UIImage(named: "placeHolderGenral"))
        
        //        scrollImg = UIScrollView()
        //        scrollImg.delegate = self
        scrollImg.frame = CGRect(x: 0, y: 0, width: vWidth, height: vHeight)
        scrollImg.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()
        
        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 10.0
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollImg.addGestureRecognizer(doubleTapGest)
        
        //  self.view.addSubview(scrollImg)
        
    }
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollImg.zoomScale == 1 {
            scrollImg.zoom(to: zoomRectForScale(scale: scrollImg.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollImg.setZoomScale(1, animated: true)
        }
    }
    
    @IBAction func zoomInButtonAction(_ sender: Any) {
        if scrollImg.zoomScale == 1 {
            let point = CGPoint.init(x: imageView.frame.width/2, y: imageView.frame.height/2)
            scrollImg.zoom(to: zoomRectForScale(scale: scrollImg.maximumZoomScale, center: point), animated: true)
        } else {
            // scrollImg.setZoomScale(1, animated: true)
        }
    }
    @IBAction func zoomOutButtonAction(_ sender: Any) {
        if scrollImg.zoomScale == 1 {
            //            let point = CGPoint.init(x: imageView.frame.width/2, y: imageView.frame.height/2)
            //            scrollImg.zoom(to: zoomRectForScale(scale: scrollImg.maximumZoomScale, center: point), animated: true)
        } else {
            scrollImg.setZoomScale(1, animated: true)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageView.convert(center, from: scrollImg)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    
}


