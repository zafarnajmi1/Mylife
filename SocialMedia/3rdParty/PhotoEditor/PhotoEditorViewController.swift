//
//  ViewController.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 4/23/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import NVActivityIndicatorView
import Photos

public final class PhotoEditorViewController: UIViewController, NVActivityIndicatorViewable,UIScrollViewDelegate {
    
    /** holding the 2 imageViews original image and drawing & stickers */
    @IBOutlet weak var canvasView: UIView!
    //To hold the image
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    //To hold the drawings and stickers
    @IBOutlet weak var canvasImageView: UIImageView!
    
    @IBOutlet weak var topToolbar: UIView!
    @IBOutlet weak var bottomToolbar: UIView!
    
    @IBOutlet weak var topGradient: UIView!
    @IBOutlet weak var bottomGradient: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var colorPickerView: UIView!
    @IBOutlet weak var colorPickerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var cancelButton: UIButton!
    //Controls
    @IBOutlet weak var cropButton: UIButton!
    @IBOutlet weak var stickerButton: UIButton!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    
    
    public var image: UIImage?
    /**
     Array of Stickers -UIImage- that the user will choose from
     */
    lazy var stickers : [UIImage] = {
        var stickers = [UIImage]()
        for i in 1...47 {
            let name = "sticker" + i.description
            stickers.append(UIImage(named: name)!)
        }
        
        return stickers
    }()
    /**
     Array of Colors that will show while drawing or typing
     */
    public var colors  : [UIColor] = []
    
    public var photoEditorDelegate: PhotoEditorDelegate?
    var colorsCollectionViewDelegate: ColorsCollectionViewDelegate!
    
    // list of controls to be hidden
    public var hiddenControls : [control] = []
    
    var stickersVCIsVisible = false
    var drawColor: UIColor = UIColor.black
    var textColor: UIColor = UIColor.white
    var isDrawing: Bool = false
    var lastPoint: CGPoint!
    var swiped = false
    var lastPanPoint: CGPoint?
    var lastTextViewTransform: CGAffineTransform?
    var lastTextViewTransCenter: CGPoint?
    var lastTextViewFont:UIFont?
    var activeTextView: UITextView?
    var imageViewToPan: UIImageView?
    var isTyping: Bool = false
    
    var stickersViewController: StickersViewController!
    
    var videoURL: URL?
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    
    
    //Register Custom font before we load XIB
    public override func loadView() {
        registerFont()
        super.loadView()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let vWidth = self.view.frame.width
        let vHeight = self.view.frame.height
        
        
    
    
        
        
        if let image = self.image {
            self.setImageView(image: image)
        }
        
        deleteView.layer.cornerRadius = deleteView.bounds.height / 2
        deleteView.layer.borderWidth = 2.0
        deleteView.layer.borderColor = UIColor.white.cgColor
        deleteView.clipsToBounds = true
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .bottom
        edgePan.delegate = self
        self.view.addGestureRecognizer(edgePan)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillChangeFrame(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        configureCollectionView()
        stickersViewController = StickersViewController(nibName: "StickersViewController", bundle: Bundle(for: StickersViewController.self))
        stickersViewController.stickers = self.stickers
        hideControls()
    }
    
    
    
  
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let url = self.videoURL {
            player = AVPlayer(url: url)
            playerController = AVPlayerViewController()
            
            guard player != nil && playerController != nil else {
                return
            }
            playerController!.showsPlaybackControls = false
            
            playerController!.player = player!
            self.addChild(playerController!)
            self.view.insertSubview(playerController!.view, at: 0)
            //self.view.addSubview(playerController!.view)
            playerController!.view.frame = view.frame
            playerController?.view.backgroundColor = .clear
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerController?.player?.currentItem)
            
            playerController?.player?.play()
            
            self.view.backgroundColor = UIColor.clear
            self.view.layer.backgroundColor = UIColor.clear.cgColor
            self.view.isOpaque = false
            
            self.imageView.backgroundColor = .clear
            self.imageView.isOpaque = false
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        playerController?.player?.pause()
        playerController?.player = nil
        self.player?.pause()
        
        self.player = nil
        
        print("player deallocated")
        if self.isMovingFromParent {
            
            if let _ = self.videoURL {
                //     playerController?.player?.pause()
                
                
                // if let play = playerController?.player {
                print("stopped")
                playerController?.player?.pause()
                playerController?.player = nil
                self.player?.pause()
                
                self.player = nil
                
                print("player deallocated")
                //                    } else {
                //                        print("player was already deallocated")
                //                    }
                
                
            }
        }
    }
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: CMTime.zero)
            self.player!.play()
        }
    }
    
    func configureCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 30, height: 30)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        colorsCollectionView.collectionViewLayout = layout
        colorsCollectionViewDelegate = ColorsCollectionViewDelegate()
        colorsCollectionViewDelegate.colorDelegate = self
        if !colors.isEmpty {
            colorsCollectionViewDelegate.colors = colors
        }
        colorsCollectionView.delegate = colorsCollectionViewDelegate
        colorsCollectionView.dataSource = colorsCollectionViewDelegate
        
        colorsCollectionView.register(
            UINib(nibName: "ColorCollectionViewCell", bundle: Bundle(for: ColorCollectionViewCell.self)),
            forCellWithReuseIdentifier: "ColorCollectionViewCell")
    }
    
    func setImageView(image: UIImage) {
        imageView.image = image
        //let size = image.suitableSize(widthLimit: UIScreen.main.bounds.width)
        // imageViewHeightConstraint.constant = (size?.height)!
    }
    
    func hideToolbar(hide: Bool) {
        topToolbar.isHidden = hide
        topGradient.isHidden = hide
        bottomToolbar.isHidden = hide
        bottomGradient.isHidden = hide
    }
    // MARK: - IBActions
    @IBAction func actionSend(_ sender: Any) {
        
        
        //        // Create the alert controller
//        let alertController = UIAlertController(title: "Upload Snap", message: "Are you sure you want to post this Snap?", preferredStyle: .alert)
//
//        // Create the actions
//        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//            UIAlertAction in
//            print("OK Pressed")
        
            let img = self.canvasView.toImage()
            self.photoEditorDelegate?.doneEditing(image: img)
            
            self.topToolbar.isHidden = true
            self.bottomToolbar.isHidden = true
            
            if let url = self.videoURL{
                self.imageView.isOpaque = false
                self.imageView.layer.isOpaque = false
                
                let color = UIColor.clear
                
                self.imageView.backgroundColor = color
                self.imageView.layer.backgroundColor = color.cgColor
                
                UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0)
                guard let context = UIGraphicsGetCurrentContext() else { return }
                self.view.layer.render(in: context)
                color.setFill()
                guard let screenshotImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
                UIGraphicsEndImageContext()
                
                self.mergeVideoAndImage(image: screenshotImage, video: url)
            } else {
                UIGraphicsBeginImageContextWithOptions(self.imageView.frame.size, true, 0)
                guard let context = UIGraphicsGetCurrentContext() else { return }
                self.view.layer.render(in: context)
                guard let screenshotImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
                UIGraphicsEndImageContext()
                
                self.saveImageAndToDocumentsDirectory(image: screenshotImage)
            }
            
            
            //self.dismiss(animated: true, completion: nil)
            
//        }
//        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default) {
//            UIAlertAction in
//            print("Cancel Pressed")
//        }
//
//        // Add the actions
//
//        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)
//
//
//        // Present the controller
//        self.present(alertController, animated: true, completion: nil)
        
        
        
        
    }
    
    func mergeVideoAndImage(image: UIImage, video url: URL) {
        let merge = Merge(config: .standard)
        let asset = AVAsset(url: url)
        
        merge.overlayVideo(video: asset, overlayImage: image, completion: { url in
            
            guard let videoUrl = url else { return }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)
                print("video saved: \(videoUrl)")
                self.saveVideoToDocumentsDirectory(url: videoUrl)
            }) { saved, error in
                if saved {
                    let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    print(error?.localizedDescription ?? "")
                }
            }
        }) { progress in
            print(progress)
        }
    }
    
    func saveVideoToDocumentsDirectory(url: URL) {
        if let savedURL = FileManager.default.saveFileToDocumentsDirectory(fileUrl: url, name: "SnapVideo", extention: ".mov") {
            
            //self.compressVideoBeforUploading(videoUrl: savedURL)
            
            
            self.uploadStory(fileUrl: savedURL)
            
            //            let alertController = UIAlertController(title : "Want to create Story",message: "",preferredStyle: .alert)
            //            let okAction = UIAlertAction(title: "OK",style: UIAlertActionStyle.default){ UIAlertAction in
            //                print("ok button tapped")
            //
            //            }
            //            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default){ UIAlertAction in
            //                print("cancel button pressed")
            //            }
            //            alertController.addAction(okAction)
            //            alertController.addAction(cancelAction)
            //            self.present(alertController, animated: true, completion: nil)
            
            
            
            
            //FeedsHandler.sharedInstance.isVideoSelected = true
            //FeedsHandler.sharedInstance.selectedVideoUrl = savedURL
        }
    }
    
    func saveImageAndToDocumentsDirectory(image: UIImage) {
        if let savedURL = FileManager.default.saveImageToDocumentsDirectory(image: image, name: "SnapPicture", extention: ".jpg") {
            
            self.uploadStory(fileUrl: savedURL)
            FeedsHandler.sharedInstance.isSelectdImage = true
            FeedsHandler.sharedInstance.selectedImage = image
            FeedsHandler.sharedInstance.selectedImageUrl = savedURL
            
        }
    }
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    func uploadStory(fileUrl: URL){
        self.showLoader()
        let userName = UserHandler.sharedInstance.userData?.fullName
        
        var parameters : [String: Any] = [:]
        var arrayOfDict : [[String : Any]] = []
        arrayOfDict.append(["type":"picture"])
        
        
        let stringValue : String? = notPrettyString(from: arrayOfDict)
        print("parameters, ", stringValue)
        parameters["values"] = stringValue
        
        print(parameters)
        
        FeedsHandler.uploadStory(fileUrl: fileUrl, params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            let _ = FileManager.default.removeFileFromDocumentsDirectory(fileUrl: fileUrl)
            
            self.stopAnimating()
            self.navigationController?.popViewController(animated: true)
            self.dismissVC(completion: nil)
        }) { (errorResponse) in
            print(errorResponse!)
            self.stopAnimating()
            self.stopAnimating()
        }
    }
    
    func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
}

extension PhotoEditorViewController {
    func compressVideoBeforUploading(videoUrl: URL) {
        let fileEntension = videoUrl.pathExtension
        
        let data = NSData(contentsOf: videoURL! as URL)!
        print("File size before compression: \(Double(data.length / 1048576)) mb")
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + "." + fileEntension)
        compressVideo(inputURL: videoURL!, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
            case .failed:
                break
            case .cancelled:
                break
            }
        }
    }
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetLowQuality) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}

extension PhotoEditorViewController: ColorDelegate {
    func didSelectColor(color: UIColor) {
        if isDrawing {
            self.drawColor = color
        } else if activeTextView != nil {
            activeTextView?.textColor = color
            textColor = color
        }
    }
}

extension UIImage {
    func imageByMakingWhiteBackgroundTransparent() -> UIImage? {
        if let rawImageRef = self.cgImage {
            let colorMasking: [CGFloat] = [200, 255, 200, 255, 200, 255]
            return UIImage(cgImage: rawImageRef.copy(maskingColorComponents: colorMasking)!)
        }
        return nil
    }
}




