//
//  DemoPopupViewController2.swift
//  PopupController
//
//  Created by 佐藤 大輔 on 2/4/16.
//  Copyright © 2016 Daisuke Sato. All rights reserved.
//

import UIKit
import UIKit
import Material
import SDWebImage
import NVActivityIndicatorView
import ImagePicker
import Lightbox

class PopupViewController: UIViewController, PopupContentViewController,ImagePickerDelegate {
   
    var pickedImnageUrl: URL?
   
    var selectedIndex = 0
    var defaults = UserDefaults.standard
    let user = ShareData.sharedUserInfo
  @IBOutlet weak var textcommentName: UITextField!
      @IBOutlet weak var image_attachementView: UIImageView!
    
    @IBOutlet var editCommentHeader: UILabel!
    @IBOutlet var editCommenCanecelBtn: UIButton!
    @IBOutlet var editCommentOkBtn: UIButton!
    
    
   // let lang = UserDefaults.standard.string(forKey: "area")
 
    var closeHandler: (() -> Void)?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        editCommentHeader.text = "Edit Comment".localized
        
        editCommentOkBtn.setTitle("OK".localized, for: .normal)
        editCommenCanecelBtn.setTitle("CANCEL".localized, for: .normal)
        
        
        
        
        self.user.flagAPI = false
        self.user.flagimage = false
        self.textcommentName.text = self.user.comment
        image_attachementView.sd_setImage(with: URL(string: self.user.attactment!), placeholderImage: UIImage(named: "placeHolderGenral"))
        image_attachementView.sd_setShowActivityIndicatorView(true)
        image_attachementView.sd_setIndicatorStyle(.gray)
        image_attachementView.clipsToBounds = true
        
        
    }
    // MARK:- Image Picker Delegate Metods
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        print("wrapper= ",images)
        guard images.count > 0 else { return }
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        print("Done Bitton = ",images)
     //   selectedViewForSelectedImage.isHidden=false
   image_attachementView.image = images[0]
      //  selectedImageNameLabel.text = "Image-25207000000"
        saveFileToDocumentsDirectory(image: images[0])
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func saveFileToDocumentsDirectory(image: UIImage) {
        if let savedUrl = FileManager.default.saveImageToDocumentsDirectory(image: image, name: "CommentPicture", extention: ".jpg") {
            
             self.user.flagimage = true
            self.pickedImnageUrl = savedUrl
         //   self.imgCounter = 1
            
            // onSendMessageButtonClick("Anything")
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        
    }
    func imagePickerControllerDidCancel(picker: ImagePickerController!)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onOpenCameraLibraryAction(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func onOkButtonClciked(_ sender: UIButton) {
         self.user.flagAPI = true
        self.user.comment = self.textcommentName.text!
        if( self.user.flagimage){
        self.user.pickedImnageUrl = self.pickedImnageUrl!
        }
        else{
          //  self.user.pickedImnageUrl = file
        }
          closeHandler?()
    }
    
    @IBAction func onCancelButtonClciked(_ sender: UIButton) {
         self.user.flagAPI = false

          closeHandler?()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layer.cornerRadius = 4
    }
    
    class func instance() -> PopupViewController {
        let storyboard = UIStoryboard(name: "PopupViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as! PopupViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: 300, height: 400)
    }
    
  
    
}

class AreaPopupCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
}
