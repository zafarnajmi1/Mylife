//
//  GothamCameraViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 20/09/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import GLKit
import AVFoundation
import CoreMedia
import Foundation
import Photos
import Vision

extension SegueIdentifiable {
    static var gothamCameraController : SegueIdentifier {
        return SegueIdentifier(rawValue: GothamCameraViewController.className)
    }
}

class GothamCameraViewController: UIViewController {
    let eaglContext = EAGLContext(api: .openGLES2)
    let captureSession = AVCaptureSession()
    
    //@IBOutlet var imageView: GLKView!
    @IBOutlet var buttonCapture: UIButton!
    
    private(set) public var currentCamera = AVCaptureDevice.Position.front
    
    var outputImage: CIImage?
    let imageView = GLKView()
    
    let comicEffect = CIFilter(name: "CIComicEffect")!
    let eyeballImage = CIImage(image: UIImage(named: "eyeball.png")!)!
    
    var cameraImage: CIImage?
    
    lazy var ciContext: CIContext = {
        [unowned self] in
        
        return  CIContext(eaglContext: self.eaglContext!)
        }()
    
    lazy var detector: CIDetector = {
        [unowned self] in
        
        CIDetector(ofType: CIDetectorTypeFace, context: self.ciContext,  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh, CIDetectorTracking: true])
        }()!
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        initialiseCaptureSession()
        view.addSubview(imageView)
        imageView.context = eaglContext!
        imageView.delegate = self
        buttonCapture.superview?.bringSubviewToFront(buttonCapture)
    }
    
    @IBAction func actionCapture(_ sender: UIButton) {
        guard let outputImage = outputImage else {
            return
        }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let processedImage = UIImage(cgImage: cgImage)
        
        let sView = UIView(frame: CGRect(x: 0, y: 0, width: 140, height: 200))
        let imageView = UIImageView(image: processedImage)
        imageView.frame = sView.frame
        sView.addSubview(imageView)
        
        self.view.addSubview(sView)
        
        SwiftyPhotoAlbum.instance.save(image: processedImage) {
            print("Image saved")
        }
    }
    
    func initialiseCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        guard let frontCamera = (AVCaptureDevice.devices(for: AVMediaType.video) )
            .filter({ $0.position == .front })
            .first else {
                fatalError("Unable to access front camera")
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            
            captureSession.addInput(input)
        }
        catch {
            fatalError("Unable to access front camera")
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        captureSession.startRunning()
    }
    
    /// Detects either the left or right eye from `cameraImage` and, if detected, composites
    /// `eyeballImage` over `backgroundImage`. If no eye is detected, simply returns the
    /// `backgroundImage`.
    func eyeImage(_ cameraImage: CIImage, backgroundImage: CIImage, leftEye: Bool) -> CIImage {
        let compositingFilter = CIFilter(name: "CISourceAtopCompositing")!
        let transformFilter = CIFilter(name: "CIAffineTransform")!
        
        let halfEyeWidth = eyeballImage.extent.width / 2
        let halfEyeHeight = eyeballImage.extent.height / 2
        
        if let features = detector.features(in: cameraImage).first as? CIFaceFeature, leftEye ? features.hasLeftEyePosition : features.hasRightEyePosition {
            let eyePosition = CGAffineTransform(
                translationX: leftEye ? features.leftEyePosition.x - halfEyeWidth : features.rightEyePosition.x - halfEyeWidth,
                y: leftEye ? features.leftEyePosition.y - halfEyeHeight : features.rightEyePosition.y - halfEyeHeight)
            
            transformFilter.setValue(eyeballImage, forKey: "inputImage")
            transformFilter.setValue(NSValue(cgAffineTransform: eyePosition), forKey: "inputTransform")
            let transformResult = transformFilter.value(forKey: "outputImage") as! CIImage
            
            compositingFilter.setValue(backgroundImage, forKey: kCIInputBackgroundImageKey)
            compositingFilter.setValue(transformResult, forKey: kCIInputImageKey)
            
            return  compositingFilter.value(forKey: "outputImage") as! CIImage
        }
        else {
            return backgroundImage
        }
    }
    
    override func viewDidLayoutSubviews() {
        imageView.frame = view.bounds
    }
}

extension GothamCameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        //connection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!
        
        guard connection.isVideoOrientationSupported else { return }
        guard connection.isVideoMirroringSupported else { return }
        connection.videoOrientation = .portrait
        connection.isVideoMirrored = currentCamera == .front
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)
        
        DispatchQueue.main.async {
            self.imageView.setNeedsDisplay()
        }
        
        if #available(iOS 11, *) {
            DispatchQueue.global().async {
                self.processForLandmarks(self.cameraImage!)
            }
        }
    }
}

extension GothamCameraViewController: GLKViewDelegate {
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        guard let cameraImage = cameraImage else {
            return
        }
        
        let leftEyeImage = eyeImage(cameraImage, backgroundImage: cameraImage, leftEye: true)
        let rightEyeImage = eyeImage(cameraImage, backgroundImage: leftEyeImage, leftEye: false)
        
        outputImage = rightEyeImage
        
        ciContext.draw(outputImage!, in: CGRect(x: 0, y: 0, width: imageView.drawableWidth, height: imageView.drawableHeight), from: outputImage!.extent)
        
        //comicEffect.setValue(rightEyeImage, forKey: kCIInputImageKey)
        //outputImage = comicEffect.value(forKey: kCIOutputImageKey) as! CIImage
        //ciContext.draw(outputImage!, in: CGRect(x: 0, y: 0, width: imageView.drawableWidth, height: imageView.drawableHeight), from: outputImage!.extent)
    }
}

@available(iOS 11, *)
extension GothamCameraViewController {
    func processForLandmarks(_ ciimage: CIImage) {
        let processedImage = convert(ciimage: ciimage)
        let service = LandmarksService()
        service.landmarks(forImage: processedImage) { results in
            switch results {
            case .succes(let faces):
                DispatchQueue.main.async {
                    self.draw(faces)
                }
            case .error(let error):
                print(error)
            }
        }
    }
    
    private func draw(_ faces: [Face]) {
        faces.forEach { face in
            let boundingBoxLayer = CAShapeLayer()
            boundingBoxLayer.path = UIBezierPath(rect: face.rect).cgPath
            boundingBoxLayer.fillColor = nil
            boundingBoxLayer.strokeColor = UIColor.red.cgColor
            imageView.layer.addSublayer(boundingBoxLayer)
            
            let lines: [LandmarkLine] = face.landmarks.map { landmark in
                let points = landmark.points.map { point in
                    return CGPoint(x: face.rect.minX + point.x * face.rect.width,
                                   y: face.rect.minY + (1 - point.y) * face.rect.height)
                }
                
                let layer = self.layer(withPoints: points)
                return LandmarkLine(description: landmark.type.rawValue,
                                    layer: layer)
            }
            
            imageView.layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
            
            lines.forEach { line in
                line.layer.frame = imageView.frame
                imageView.layer.addSublayer(line.layer)
            }
        }
    }
    
    private func layer(withPoints points: [CGPoint]) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.strokeColor = UIColor.red.cgColor
        layer.lineWidth = 2
        let path = UIBezierPath()
        path.move(to: points.first!)
        points.forEach { point in
            path.addLine(to: point)
        }
        layer.path = path.cgPath
        return layer
    }
    
    func convert(ciimage: CIImage) -> UIImage {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(ciimage, from: ciimage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
}

