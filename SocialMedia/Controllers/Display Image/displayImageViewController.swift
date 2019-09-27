//
//  displayImageViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 24/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit

class displayImageViewController: UIViewController,UIScrollViewDelegate {

   
    var imageString = String()
    @IBOutlet weak var imageViewDisplayImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var imgScrollView: UIScrollView!
    var state = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.isHidden = true
        // Do any additional setup after loading the view.
        self.title = ""
        imageViewDisplayImage.sd_setImage(with: URL(string: imageString), placeholderImage: UIImage(named: "placeHolderGenral"))
        imageViewDisplayImage.sd_setShowActivityIndicatorView(true)
        imageViewDisplayImage.sd_setIndicatorStyle(.gray)
        imageViewDisplayImage.clipsToBounds = true
        addBackButton()
        if state == true{
            backButton.isHidden = false
        }
        
        let vWidth = self.view.frame.width
        let vHeight = self.view.frame.height
        
//        imageViewDisplayImage.sd_setImage(with: URL(string: String(describing: urlString)), placeholderImage: UIImage(named: "placeHolderGenral"))
        
        //        imgScrollView = UIScrollView()
        //        imgScrollView.delegate = self
        imgScrollView.frame = CGRect(x: 0, y: 0, width: vWidth, height: vHeight)
        imgScrollView.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
        imgScrollView.alwaysBounceVertical = false
        imgScrollView.alwaysBounceHorizontal = false
        imgScrollView.showsVerticalScrollIndicator = true
        imgScrollView.flashScrollIndicators()
        
        imgScrollView.minimumZoomScale = 1.0
        imgScrollView.maximumZoomScale = 10.0
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        imgScrollView.addGestureRecognizer(doubleTapGest)
        
        
        
    }

    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if imgScrollView.zoomScale == 1 {
            imgScrollView.zoom(to: zoomRectForScale(scale: imgScrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            imgScrollView.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageViewDisplayImage.frame.size.height / scale
        zoomRect.size.width  = imageViewDisplayImage.frame.size.width  / scale
        let newCenter = imageViewDisplayImage.convert(center, from: imgScrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageViewDisplayImage
    }
    
    

    @IBAction func actionBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveimageButtonAction(_ sender: Any) {
        let url : String = imageString
        
        let imageView : UIImageView = UIImageView()
        imageView.sd_setImage(with: URL(string: String(describing: url)), completed: { (img, error , cacheType , imgUrl) in
            if img != nil {
                UIImageWriteToSavedPhotosAlbum(img!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        })
    }
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!".localized, message: "Picture has been saved to your photos".localized, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK".localized, style: .default))
            present(ac, animated: true)
        }
    }
    

}
