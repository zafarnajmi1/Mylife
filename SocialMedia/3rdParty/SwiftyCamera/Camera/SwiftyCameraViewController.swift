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
import Material

extension SegueIdentifiable {
    static var swiftyCameraViewController : SegueIdentifier {
        return SegueIdentifier(rawValue: SwiftyCameraViewController.className)
    }
}

public protocol RecordedVideoDelegate {
    func transmitRecordedVideoURL(url:URL)
}

class SwiftyCameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    
    var recordedVideoDelegate : RecordedVideoDelegate?
    
    @IBOutlet weak var captureButton: SwiftyRecordButton!
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    
    @IBOutlet var buttonCancel: UIButton!
    
    var progressTimer : Timer!
    var progress : CGFloat! = 0
    
    @IBAction func actionCamera(_ sender: Any) {
       // startVideoRecording()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = "Record Video"
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(onBackButtonClciked))
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
      
        //  self.navigationController?.navigationBar.topItem?.backBarButtonItem?.title = "Back"

        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(onBackButtonClciked))
        //        navigationItem.leftBarButtonItem?.setBackgroundImage(#imageLiteral(resourceName: "back"), for: .normal,@objc  barMetrics: .default)
        
        //setUpNavBar()
        cameraDelegate = self
        pinchToZoom = true
        swipeToZoom = true
        swipeToZoomInverted = true
        maxZoomScale = 2.0
        maximumVideoDuration = 30.0 // 30 seconds
        shouldUseDeviceOrientation = true
        allowAutoRotate = true
        audioEnabled = true
        
        captureButton.delegate = self

      //  buttonCancel.setImage(Icon.cm.clear!.tint(with: UIColor.white)!, for: .normal)
       // buttonCancel.addTarget(self, action: #selector(onCloseCameraViewController), for: .touchUpInside)
                
    //    navigationController?.presentTransparentNavigationBar()
      //  navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.6)
        
       // hideStatusBar()

    }
   
    
    func onCloseCameraViewController() {
        onBackButtonClciked()
        releaseCamera()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if FeedsHandler.sharedInstance.isVideoSelected || FeedsHandler.sharedInstance.isSelectdImage{
            releaseCamera()
            //self.navigationController?.popViewController(animated: true)

        }
//        UIApplication.shared.isStatusBarHidden = true
//        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingToParent {
            UIApplication.shared.isStatusBarHidden = false
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
    }
    
    func moveToOldPicturePreview(_ photo: UIImage) {
        let controller = UIStoryboard.mainStoryboard.instantiateVC(SwiftyPhotoViewController.self)!
        
        let cameraSnackbarController = CameraSnackbarController(rootViewController: controller)
        cameraSnackbarController.isHeroEnabled = true
        cameraSnackbarController.snackbarDelegate = controller
        
        controller.isHeroEnabled = true
        controller.heroModalAnimationType = .auto
        controller.isImageTakenFromCamera = true
        controller.selectedImage = photo
        
        self.modalPresentationStyle = .overCurrentContext
        self.presentVC(cameraSnackbarController)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        //moveToOldPicturePreview(photo)
        
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController", bundle: Bundle(for: PhotoEditorViewController.self))
        photoEditor.isHeroEnabled = true
        photoEditor.heroModalAnimationType = .auto
        //photoEditor.photoEditorDelegate = self
        photoEditor.image = photo
        //Colors for drawing and Text, If not set default values will be used
        //photoEditor.colors = [.red,.blue,.green]
        //Stickers that the user will choose from to add on the image
        //To hide controls - array of enum control
        photoEditor.hiddenControls = [.crop, .share]
        present(photoEditor, animated: true, completion: nil)
        
        //let controller = SwiftyPhotoViewController(image: photo)
        //self.present(newVC, animated: true, completion: nil)
        
        //controller.isMotionEnabled = true
        //controller.motionModalTransitionType = .autoReverse(presenting: .auto)
        
        //self.pushVC(controller)
        
        //performSegue(withIdentifier: SwiftyPhotoViewController.className)
    }
    
    func startRecordTimer() {
          self.progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgress() {
        
        let maxDuration = CGFloat(30) // Max duration of the recordButton
        
        progress = progress + (CGFloat(0.05) / maxDuration)
        captureButton.setProgress(progress)
        
        if progress >= 1 {
            progressTimer.invalidate()
        }
        
    }
    
   
    
    func stopRecordTimer() {
        captureButton.setProgress(0)
        self.progressTimer.invalidate()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        captureButton.growButton()
        startRecordTimer()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        captureButton.shrinkButton()
        stopRecordTimer()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {

        //Here it present controller over the controller   --Imran
        self.navigationController?.popViewController(animated: true)
        recordedVideoDelegate?.transmitRecordedVideoURL(url: url)
        
//
//        let controller = VideoViewController(videoURL: url)
//        controller.isMotionEnabled = true
//        controller.motionModalTransitionType = .autoReverse(presenting: .auto)
//        self.presentVC(controller)
       

        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        if !buttonCancel.frame.contains(point) || !captureButton.frame.contains(point) || !flipCameraButton.frame.contains(point) || !flashButton.frame.contains(point){
            let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
            focusView.center = point
            focusView.alpha = 0.0
            view.addSubview(focusView)
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
                focusView.alpha = 1.0
                focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            }, completion: { (success) in
                UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                    focusView.alpha = 0.0
                    focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
                }, completion: { (success) in
                    focusView.removeFromSuperview()
                })
            })
        }
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print(camera)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error) {
        print(error)
    }
    
    @IBAction func cameraSwitchTapped(_ sender: Any) {
        switchCamera()
    }
    
    @IBAction func toggleFlashTapped(_ sender: Any) {
        flashEnabled = !flashEnabled
        
        if flashEnabled == true {
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControl.State())
        } else {
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControl.State())
        }
    }
}

