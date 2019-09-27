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
import GPUImage
import Material
import Hero
import SnapSliderFilters

class SwiftyPhotoViewController: UIViewController {
    
    var isImageTakenFromCamera = false
    
    // MARK: IBOutlets
    
    @IBOutlet var screenView: UIView!
    @IBOutlet var selectedImageView: UIImageView! {
        didSet {
            selectedImageView.contentMode = .scaleAspectFit
            
            if let identifier = imageViewHeroIdentifier {
                selectedImageView.heroID = identifier
            }
        }
    }
    
    @IBOutlet var buttonCancel: UIButton! {
        didSet {
            buttonCancel.setImage(Icon.cm.clear!.tint(with: UIColor.white)!, for: .normal)
        }
    }
    
    @IBOutlet var bottomContainerView: UIView!
    @IBOutlet var buttonPublishStory: UIButton!
    @IBOutlet var buttonSaveToGallery: UIButton!
    
    // MARK: IBActions
    @IBAction func onButtonPublishStoryClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func onButtonSaveToGalleyClicked(_ sender: UIButton) {
        let picture = SNUtils.screenShot(self.screenView)
        if let image = picture {
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            SwiftyPhotoAlbum.instance.save(image: image, completion: {
                self.showSnackbar()
                print("image saved to gallery")
            })
        }
    }
    
    
    // MARK: Properties
    // The screenView will be the screenshoted view : all its subviews will appear on it (so, don't add buttons in its subviews)
    fileprivate let slider: SNSlider = SNSlider(frame: CGRect(origin: CGPoint.zero, size: SNUtils.screenSize))
    
    fileprivate let textField = SNTextField(y: SNUtils.screenSize.height/2, width: SNUtils.screenSize.width, heightOfScreen: SNUtils.screenSize.height)
    fileprivate let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer()
    //fileprivate let buttonSave = SNButton(frame: CGRect(x: 20, y: SNUtils.screenSize.height - 35, width: 33, height: 30), withImageNamed: "saveButton")
    //fileprivate let buttonCamera = SNButton(frame: CGRect(x: 75, y: SNUtils.screenSize.height - 42, width: 45, height: 45), withImageNamed: "galleryButton")
    fileprivate var data:[SNFilter] = []
    
    var panGesture = UIPanGestureRecognizer()
    
    fileprivate var doneButton: FlatButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var selectedImage: UIImage?
    
    var imageViewHeroIdentifier: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
        if isImageTakenFromCamera {
            selectedImage = selectedImage?.resizeWithWidth(SNUtils.screenSize.width)
        }
        selectedImageView.image = selectedImage
        
        tapGesture.addTarget(self, action: #selector(handleTap))
        
           prepareView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(textField)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.setAnimationsEnabled(true)
    }
    
    @IBAction func popViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SwiftyPhotoViewController {
    @objc  override func prepareView() {
        super.prepareView()
        
        setupSlider()
        setupTextField()
        bringViewsToFront()
        prepareDoneButton()
        prepareSnackbar()
    }
}

extension SwiftyPhotoViewController {
    
    fileprivate func setupTextField() {
        self.tapGesture.delegate = self
        
        self.screenView.addSubview(textField)
        self.screenView.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self.textField, selector: #selector(SNTextField.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self.textField, selector: #selector(SNTextField.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self.textField, selector: #selector(SNTextField.keyboardTypeChanged(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
    }
    
    //MARK: Setup
    fileprivate func setupSlider() {
        self.createData(selectedImage!)
        self.slider.dataSource = self
        self.slider.isUserInteractionEnabled = true
        self.slider.isMultipleTouchEnabled = true
        self.slider.isExclusiveTouch = false
        
        self.screenView.addSubview(slider)
        
        self.slider.reloadData()
    }
    
    fileprivate func createData(_ image: UIImage) {
        self.data = SNFilter.generateFilters(SNFilter(frame: self.slider.frame, withImage: image), filters: SNFilter.filterNameList)
        
        //self.data[1].addSticker(SNSticker(frame: CGRect(x: 195, y: 30, width: 90, height: 90), image: UIImage(named: "stick2")!))
        //self.data[2].addSticker(SNSticker(frame: CGRect(x: 30, y: 100, width: 250, height: 250), image: UIImage(named: "stick3")!))
        //self.data[3].addSticker(SNSticker(frame: CGRect(x: 20, y: 00, width: 140, height: 140), image: UIImage(named: "stick")!))
    }
    
    fileprivate func updatePicture(_ newImage: UIImage) {
        createData(newImage)
        slider.reloadData()
    }
    
    func bringViewsToFront() {
        buttonCancel.superview?.bringSubviewToFront(buttonCancel)
        buttonSaveToGallery.superview?.bringSubviewToFront(buttonSaveToGallery)
        buttonPublishStory.superview?.bringSubviewToFront(buttonPublishStory)
    }
    
    //    fileprivate func setupPanGesture() {
    //        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
    //        viewDrag.isUserInteractionEnabled = true
    //        viewDrag.addGestureRecognizer(panGesture)
    //    }
    //
    //    func draggedView(_ sender:UIPanGestureRecognizer){
    //        self.view.bringSubview(toFront: viewDrag)
    //        let translation = sender.translation(in: self.view)
    //        viewDrag.center = CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
    //        sender.setTranslation(CGPoint.zero, in: self.view)
    //    }
    
    
    //    fileprivate func setupButtonSave() {
    //        self.buttonSave.setAction {
    //            [weak weakSelf = self] in
    //            let picture = SNUtils.screenShot(weakSelf?.screenView)
    //            if let image = picture {
    //                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    //            }
    //        }
    //
    //        self.view.addSubview(self.buttonSave)
    //    }
    //
    //    fileprivate func setupButtonCamera() {
    //        self.buttonCamera.setAction {
    //            [weak weakSelf = self] in
    //
    //            if let tmpImagePicker = weakSelf?.imagePicker {
    //                tmpImagePicker.allowsEditing = false
    //                tmpImagePicker.sourceType = .photoLibrary
    //
    //                weakSelf?.present(tmpImagePicker, animated: true, completion: nil)
    //            }
    //        }
    //
    //        //imagePicker.delegate = self
    //        self.view.addSubview(self.buttonCamera)
    //    }
    
}

extension SwiftyPhotoViewController: SNSliderDataSource {
    
    func numberOfSlides(_ slider: SNSlider) -> Int {
        return data.count
    }
    
    func slider(_ slider: SNSlider, slideAtIndex index: Int) -> SNFilter {
        
        return data[index]
    }
    
    func startAtIndex(_ slider: SNSlider) -> Int {
        return 0
    }
}

//MARK: - Extension Gesture Recognizer Delegate and touch Handler for TextField

extension SwiftyPhotoViewController: UIGestureRecognizerDelegate {
    @objc func handleTap() {
        self.textField.handleTap()
    }
}

extension SwiftyPhotoViewController: CameraSnackbarDelegate {
    func snackbarWillShow() {
        UIView.animate(withDuration: 0.2) {
            self.bottomContainerView.frame.origin.y -= 40
        }
    }
    
    func snackbarWillHide() {
        UIView.animate(withDuration: 0.2) {
            self.bottomContainerView.frame.origin.y += 40
        }
    }
}

extension SwiftyPhotoViewController {
    fileprivate func prepareDoneButton() {
        doneButton = FlatButton(title: "OK", titleColor: Color.yellow.base)
        doneButton.pulseAnimation = .backing
        doneButton.titleLabel?.font = snackbarController?.snackbar.textLabel.font
        doneButton.addTarget(self, action: #selector(self.done(_:)), for: .touchUpInside)
    }
    
    @objc fileprivate func done(_ sender: UIButton) {
        guard let snackbar = snackbarController else {
            return
        }
        
        _ = snackbar.animate(snackbar: .hidden, delay: 1)

    }
    
    fileprivate func prepareSnackbar() {
        guard let snackbar = snackbarController?.snackbar else {
            return
        }
        
        snackbar.text = "Saved To Gallery"
        snackbar.textLabel.font = UIFont.light
        snackbar.textLabel.textColor = UIColor.white
        snackbar.backgroundColor = UIColor.primary
        //snackbar.rightViews = [doneButton]
    }
    
    fileprivate func showSnackbar() {
        guard let snackbar = snackbarController else {
            return
        }
        
        _ = snackbar.animate(snackbar: .visible, delay: 1)
        _ = snackbar.animate(snackbar: .hidden, delay: 2)
    }
}

extension SwiftyPhotoViewController {
    @objc
    fileprivate func animateSnackbar() {
        showSnackbar()
    }
}


