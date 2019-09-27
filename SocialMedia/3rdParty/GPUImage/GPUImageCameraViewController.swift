//
//  GPUImageCameraViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 29/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import GPUImage
import Material
import Popover
import ImagePicker
import Lightbox

extension SegueIdentifiable {
    static var gpuImageCameraController : SegueIdentifier {
        return SegueIdentifier(rawValue: GPUImageCameraViewController.className)
    }
}

protocol GPUImageCameraDelegate {
    func gpuImageCapture(_ image : UIImage)
}

class GPUImageCameraViewController: UIViewController,ImagePickerDelegate{
    
    var imagePickerController = UIImagePickerController()
    
    
    
    static var arrayOfImages = [UIImage]()
    static var arrayOfImagesURLS = [URL]()
    var flag:Bool = true
    var popover = Popover()

    var delegate : GPUImageCameraDelegate?
    
    let maximumVideoDuration: Double = 10
    var progressTimer: Timer!
    var progress: CGFloat! = 0
    
    var movieOutput: MovieOutput? = nil
    
    var fileURL: URL?
    
    var pictureUrl: URL?
    
    var cameraLocation: PhysicalCameraLocation = .backFacing
    public var flashEnabled = false
    
    
    @IBOutlet weak var recordButton: SwiftyRecordButton! {
        didSet {
            recordButton.delegate = self
            recordButton.isMultipleTouchEnabled=false
            
        }
    }
    @IBOutlet var filterView: RenderView!
    @IBOutlet var slider: UISlider!
    
    var camera: Camera?
    
    var defaultVideoDevice: AVCaptureDevice?
    
    @IBOutlet var filterLabel: UILabel! {
        didSet {
            filterLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var buttonFlash: UIButton!
    
    @IBAction func actionFlash(_ sender: UIButton) {
        toggleFlash()
    }
    
    @IBOutlet weak var buttonSwitchCamera: UIButton!
    
    
    @IBAction func actionSwitchCamera(_ sender: UIButton) {
        switchCamera()
    }
    
    var buttonCancel: UIButton!
    
    var isFilterChanged = false
    
    fileprivate(set) public var pinchGesture  : UIPinchGestureRecognizer!
    fileprivate(set) public var panGesture    : UIPanGestureRecognizer!
    
    fileprivate var previousPanTranslation    : CGFloat = 0.0
    
    var filterIndex = 2
    var filter: FilterOperationInterface?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GPUImageCameraViewController.arrayOfImages.removeAll()
        GPUImageCameraViewController.arrayOfImagesURLS.removeAll()
        
        addGestureRecognizers()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)

        let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        let label = UILabel(frame: aView.frame)
        
        let font = UIFont.light(ofSize: 16)
        label.textAlignment = .center
        label.font = font
        label.text = "Tap for picture. Tap and hold to record snap. Swipe left-right to change filters"
        label.textColor = .gray
        label.numberOfLines = 3
        aView.addSubview(label)
        
        let options = [
            .type(.up),
            .cornerRadius(4),
            .animationIn(0.5),
            .arrowSize(CGSize.zero)
            ] as [PopoverOption]
        
        popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.popover.show(aView, fromView: self.recordButton)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.popover.dismiss()
            })
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }
    func imagePickerControllerDidCancel(picker: ImagePickerController!)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        DispatchQueue.main.async {
            self.setupCamera()
            //self.prepareCamera()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeCamera()
    }
    
    func prepareInputDevice() -> Bool {
        switch cameraLocation {
        case .frontFacing:
            if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
                defaultVideoDevice = frontCameraDevice
                
                return true
            }
            
            break
            
        case .backFacing:
            if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
                defaultVideoDevice = backCameraDevice
                
                return true
            }
            break
        }
        
        return false
    }
    
    func setupCamera() {
        prepareCamera()
        configureView()
    }
    
    func removeCamera() {
        if let _ = camera
        {
            camera?.stopCapture()
            camera?.removeAllTargets()
            camera = nil
        }
    }
    
    func prepareCamera() {
        buttonCancel = UIButton(frame: CGRect(x: 20, y: 20, width: 50, height: 50))
        //buttonCancel.setImage(Icon.cm.clear!.tint(with: UIColor.white)!, for: .normal)
        buttonCancel.setImage(#imageLiteral(resourceName: "cancel-cross"), for: .normal)
        buttonCancel.addTarget(self, action: #selector(self.onBackButtonClciked), for: .touchUpInside)

        filterLabel.superview?.addSubview(buttonCancel)

        buttonCancel.superview?.bringSubviewToFront(buttonCancel)

        do {
            var preset: String

            if UIDevice.isiPad {
                preset = AVCaptureSession.Preset.vga640x480.rawValue
            } else {
                preset = AVCaptureSession.Preset.hd1280x720.rawValue
            }

            if prepareInputDevice() {
                if let device = defaultVideoDevice {
                    camera = try Camera(sessionPreset: preset, cameraDevice: device, location: cameraLocation)
                    camera!.runBenchmark = false
                    
                    flag = true

//                    let imagePickerController = ImagePickerController()
//                    imagePickerController.imageLimit = 1
//                    imagePickerController.delegate = self
//                    present(imagePickerController, animated: true, completion: nil)
                }
            } else
            {
                //displayAlertMessage("Unable to open Camera")
                let alert = UIAlertController(title: "Alert".localized, message: "Unable to open Camera".localized, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler:  { action in
                        self.dismiss(animated: true, completion: nil)
                 }))
                
            }
            
        } catch {
            camera = nil
            print("Couldn't initialize camera with error: \(error)")
        }
    }
    
    func configureView() {
        guard let camera = camera else {
            let errorAlertController = UIAlertController(title: NSLocalizedString("Error".localized, comment: "Error".localized), message: "Couldn't initialize camera".localized, preferredStyle: .alert)
            errorAlertController.addAction(UIAlertAction(title: NSLocalizedString("OK".localized, comment: "OK".localized), style: .default, handler:  { action in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(errorAlertController, animated: true, completion: nil)
            return
        }
        
        filter = filterOperations[filterIndex]
        
        guard let currentFilterConfiguration = filter else {
            return
        }
        
        if filterIndex == 2 {
            currentFilterConfiguration.updateBasedOnSliderValue(0.0)
        }
        
        UIView.animate(withDuration: 0.4) {
            self.filterLabel.text = currentFilterConfiguration.titleName
        }
        
        self.title = currentFilterConfiguration.titleName
        
        // Configure the filter chain, ending with the view
        if let view = self.filterView {
            camera.addTarget(currentFilterConfiguration.filter)
            currentFilterConfiguration.filter.addTarget(view)
            camera.startCapture()
        }
        
        if let slider = self.slider {
            switch currentFilterConfiguration.sliderConfiguration {
            case .disabled:
                slider.minimumValue = 0
                slider.maximumValue = 2
                slider.value = 2
                slider.isHidden = false
                self.updateSliderValue()
                break
                //slider.isHidden = true
            //                case let .Enabled(minimumValue, initialValue, maximumValue, filterSliderCallback):
            case let .enabled(minimumValue, maximumValue, initialValue):
                slider.minimumValue = minimumValue
                slider.maximumValue = maximumValue
                slider.value = initialValue
                slider.isHidden = false
                self.updateSliderValue()
            }
        }
        
    }
    
    @IBAction func updateSliderValue() {
        if let currentFilterConfiguration = self.filter {
            switch (currentFilterConfiguration.sliderConfiguration) {
            case .enabled(_, _, _):
                DispatchQueue.main.async {
                    currentFilterConfiguration.updateBasedOnSliderValue(Float(self.slider!.value))
                }
                
            case .disabled:
                DispatchQueue.main.async {
                    currentFilterConfiguration.updateBasedOnSliderValue(Float(0.0))
                }
                break
            }
        }
    }
    
    func removeFilter() {
        guard let previousFilter = filter?.filter else {
            return
        }
        
        previousFilter.removeAllTargets()
    }
    
    
    func startRecordTimer() {
        self.progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgress() {
        progress = progress + (CGFloat(0.05) / CGFloat(maximumVideoDuration))
        recordButton.setProgress(progress)
        
        if progress >= 1 {
            progressTimer.invalidate()
        }
    }
    
    func stopRecordTimer() {
        progress = 0
        recordButton.setProgress(progress)
        progressTimer.invalidate()
    }
}

extension GPUImageCameraViewController {
    func switchCamera() {
        removeCamera()
        
        let currentCameraLocation = cameraLocation
        
        switch currentCameraLocation {
        case .backFacing:
            cameraLocation = .frontFacing
            break
            
        case .frontFacing:
            cameraLocation = .backFacing
            break
        }
        
        DispatchQueue.main.async {
            self.setupCamera()
        }
    }
    
    func toggleFlash() {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        if let device = device {
            if (device.hasTorch) {
                do {
                    try device.lockForConfiguration()
                    if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                        device.torchMode = AVCaptureDevice.TorchMode.off
                    } else {
                        do {
                            try device.setTorchModeOn(level: 1.0)
                        } catch {
                            print(error)
                        }
                    }
                    
                    device.unlockForConfiguration()
                    
                    flashEnabled = !flashEnabled
                    
                    if flashEnabled {
                        buttonFlash.setImage(#imageLiteral(resourceName: "flash"), for: UIControl.State())
                    } else {
                        buttonFlash.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControl.State())
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
//    func toggleFlash() {
//        if cameraLocation == .backFacing {
//            if let device = defaultVideoDevice {
//                if device.isFlashAvailable {
//                    if device.isFlashActive {
//                        changeFlashSettings(device: device, mode: .off)
//                    } else {
//                        changeFlashSettings(device: device, mode: .on)
//                    }
//                }
//
//                flashEnabled = !flashEnabled
//
//                if flashEnabled {
//                    buttonFlash.setImage(#imageLiteral(resourceName: "flash"), for: UIControlState())
//                } else {
//                    buttonFlash.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
//                }
//            }
//        }
//    }
    
    fileprivate func changeFlashSettings(device: AVCaptureDevice, mode: AVCaptureDevice.FlashMode) {
        do {
            try device.lockForConfiguration()
            device.flashMode = mode
            device.unlockForConfiguration()
        } catch {
            print("[SwiftyCam]: \(error)")
        }
    }
}

extension GPUImageCameraViewController {
    
    func startRecording() {
        do {
            let documentsDir = try FileManager.default.url(for:.documentDirectory, in:.userDomainMask, appropriateFor:nil, create:true)
            fileURL = URL(string: "video.mp4", relativeTo:documentsDir)!
            
            do {
                try FileManager.default.removeItem(at: fileURL!)
            } catch {
            }
            // 1280x720
            
            var size: Size
            
            if UIDevice.isiPad {
                size = Size(width: 480, height: 640)
            } else {
                size = Size(width: 720, height: 1280)
            }
            
            movieOutput = try MovieOutput(URL: fileURL!, size: size, liveVideo: true)
            camera!.audioEncodingTarget = movieOutput
            
            
            filter!.filter --> movieOutput!
            movieOutput!.startRecording()
        } catch {
            fatalError("Couldn't initialize movie, error: \(error)")
        }
    }
    
    func stopRecording() {
        movieOutput?.finishRecording {
            
            DispatchQueue.main.async {
                guard let url = self.fileURL else  { return }
                self.finishedProcessedVideo(at: url)
            }
            self.camera?.audioEncodingTarget = nil
            self.movieOutput = nil
        }
    }
    
    func finishedProcessedVideo(at url: URL) {
        let controller = PhotoEditorViewController(nibName: "PhotoEditorViewController", bundle: Bundle(for: PhotoEditorViewController.self))
        controller.isHeroEnabled = true
        controller.motionTransitionType = .autoReverse(presenting: .auto)
        controller.videoURL = url
        controller.hiddenControls = [.crop, .share]
        
        self.presentVC(controller)
        
        
        let _ = VideoViewController(videoURL: url)
        //controller.isMotionEnabled = true
        //controller.motionModalTransitionType = .autoReverse(presenting: .auto)
        
        //self.presentVC(controller)
    }
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func capturePicture() {
        do {
            //let documentsDir = try FileManager.default.url(for:.documentDirectory, in:.userDomainMask, appropriateFor:nil, create:true)
            //pictureUrl = URL(string: "snap.png", relativeTo:documentsDir)!
            
            let documentsDir = try FileManager.default.url(for:.documentDirectory, in:.userDomainMask, appropriateFor:nil, create:true)
            let url = URL(string:"StoryImage.png", relativeTo: documentsDir)!
            
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                
            }
            
            guard let filter = self.filter?.filter else  { return }
            
            filter.saveNextFrameToURL(url, format:.png)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                print(url)
                
                do {
                    let imageData = try Data(contentsOf: url)
                    let image = UIImage(data: imageData)
                    
                   
                    self.dismiss(animated: false, completion: {
                        if let _delegate = self.delegate, let _image =  image {
                            _delegate.gpuImageCapture(_image)
                        }
                    })
//                    let photoEditor = PhotoEditorViewController(nibName: "PhotoEditorViewController", bundle: Bundle(for: PhotoEditorViewController.self))
//                    photoEditor.isHeroEnabled = true
//                    photoEditor.heroModalAnimationType = .auto
//                    photoEditor.image = image
//                    photoEditor.hiddenControls = [.crop, .share]
//
//                    self.present(photoEditor, animated: true, completion: nil)
                    
                } catch {
                    print(error)
                }
            })
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    func finishedProcessingPicture(at url: URL) {
        
    }
    
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
        GPUImageCameraViewController.arrayOfImages.removeAll()
        GPUImageCameraViewController.arrayOfImages = images
         imagePicker.dismiss(animated: true, completion: nil)
        //imagesAreSelected()
        
        
        
        
        
        //        for image in images {
        //             saveFileToDocumentsDirectory(image: image,count: 1)
        //        }
        
//        for index in 0..<images.count {
//            //saveFileToDocumentsDirectory(image: images[index],count: index)
//        }
        
        
        
        
       
    }
    
    fileprivate func addGestureRecognizers() {
                pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchRecognized(pinch:)))
                pinchGesture.delegate = self
                filterView.addGestureRecognizer(pinchGesture)
        //
        //        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTapGesture(tap:)))
        //        singleTapGesture.numberOfTapsRequired = 1
        //        singleTapGesture.delegate = self
        //        previewLayer.addGestureRecognizer(singleTapGesture)
        //
        //        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGesture(tap:)))
        //        doubleTapGesture.numberOfTapsRequired = 2
        //        doubleTapGesture.delegate = self
        //        previewLayer.addGestureRecognizer(doubleTapGesture)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(pan:)))
        panGesture.delegate = self
        filterView.addGestureRecognizer(panGesture)
    }
    
    @objc func pinchRecognized(pinch: UIPinchGestureRecognizer) {
        print("pich gesture working man")
        //        pinch.view?.transform = (pinch.view?.transform)!.scaledBy(x:   pinch.scale, y: pinch.scale)
        //        pinch.scale = 1
        
        // test for zoom
        if #available(iOS 10.0, *) {
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
            var zoomFactor: CGFloat = 1.00
            
            func minMaxZoom(_ factor: CGFloat) -> CGFloat { return min(max(factor, 1.0), device!.activeFormat.videoMaxZoomFactor) }
            
            func update(scale factor: CGFloat) {
                do {
                    try device?.lockForConfiguration()
                    defer { device?.unlockForConfiguration() }
                    device?.videoZoomFactor = factor
                } catch {
                    debugPrint(error)
                }
            }
            
            let newScaleFactor = minMaxZoom(pinch.scale * zoomFactor)
            
            switch pinch.state {
            case .began: fallthrough
            case .changed: update(scale: newScaleFactor)
            case .ended:
                zoomFactor = minMaxZoom(newScaleFactor)
                update(scale: zoomFactor)
            default: break
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        
    }
}

extension GPUImageCameraViewController: UIGestureRecognizerDelegate {
    @objc fileprivate func panGesture(pan: UIPanGestureRecognizer) {
        guard let direction = pan.direction else {
            return
        }
        
        let currentTranslation    = pan.translation(in: view).y
        let translationDifference = currentTranslation - previousPanTranslation
        
        if direction == .up || direction == .down {
            
            if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
                previousPanTranslation = 0.0
            } else {
                previousPanTranslation = currentTranslation
            }
            
            if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
                previousPanTranslation = 0.0
            } else {
                previousPanTranslation = currentTranslation
            }
        } else if direction == .left {
            
            if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
                
                filterIndex += 1
                
                
                
                if filterIndex >= filterOperations.count {
                    filterIndex = 0
                }
                
                removeFilter()
                configureView()
            }
        } else if direction == .right {
            if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
                
                filterIndex -= 1
                
                if filterIndex < 2 {
                    filterIndex = 0
                }
                
                removeFilter()
                configureView()
            }
        }
    }
}

extension GPUImageCameraViewController: SwiftyCamButtonDelegate {
    func buttonWasTapped() {
        capturePicture()
    }
    
    func buttonDidBeginLongPress() {
        Timer.after(0.02) {
            self.recordButton.growButton()
            self.startRecordTimer()
            self.startRecording()
        }
    }
    
    func buttonDidEndLongPress() {
        do {
            try recordButton.shrinkButton()
        } catch {
          
        }
        stopRecordTimer()
        stopRecording()
    }
    
    func longPressDidReachMaximumDuration() {
        stopRecordTimer()
        stopRecording()
    }
    
    func setMaxiumVideoDuration() -> Double {
        return maximumVideoDuration
    }
}
