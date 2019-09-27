////
////  videoRecorderViewController.swift
////  SocialMedia
////
////  Created by Muhammad Umer on 30/10/2017.
////  Copyright © 2017 My Technology. All rights reserved.

import UIKit
import AVFoundation
import AVKit
import RecordButton

class videoRecorderViewController: UIViewController,AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print(error?.localizedDescription)
    }
    
    @IBOutlet weak var camPreview: UIView!
    @IBOutlet weak var recordButton: RecordButton!
    @IBOutlet weak var flashButton: UIButton!
    var flashEnabled = false
    let cameraButton = UIView()

    let captureSession = AVCaptureSession()

    let movieOutput = AVCaptureMovieFileOutput()

    var previewLayer: AVCaptureVideoPreviewLayer!

    var activeInput: AVCaptureDeviceInput!

    var outputURL: URL!
    

    var progressTimer : Timer!
    var progress : CGFloat! = 0


    override func viewDidLoad() {
        super.viewDidLoad()

        self.flashButton.isHidden = true
        addBackButton()
        if setupSession() {
            setupPreview()
            startSession()
        }

        // set up recorder button

        recordButton.progressColor = .red
        recordButton.closeWhenFinished = false
        recordButton.addTarget(self, action: #selector(videoRecorderViewController.record), for: .touchDown)
        recordButton.addTarget(self, action: #selector(videoRecorderViewController.stop), for: UIControl.Event.touchUpInside)
    }

    func setupPreview() {
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        camPreview.layer.addSublayer(previewLayer)
    }

    @objc func record() {
        startCapture()
        self.progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(videoRecorderViewController.updateProgress), userInfo: nil, repeats: true)
    }
    
    @objc  func updateProgress() {
        
        let maxDuration = CGFloat(5) // Max duration of the recordButton
        
        progress = progress + (CGFloat(0.05) / maxDuration)
        recordButton.setProgress(progress)
        
        if progress >= 1 {
            progressTimer.invalidate()
            stopRecording()
            progress = 0.0
            recordButton.setProgress(0)
            
        }
        
    }
    
    @objc func stop() {
        self.progressTimer.invalidate()
        stopRecording()
//        AVCaptureDevice.toggleTorch()
       
    }
    

    
    //MARK:- Setup Camera

    func setupSession() -> Bool {

        captureSession.sessionPreset = AVCaptureSession.Preset.high

        // Setup Camera
        let camera = AVCaptureDevice.default(for: AVMediaType.video)

        do {
            let input = try AVCaptureDeviceInput(device: camera!)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            }
        } catch {
            print("Error setting device video input: \(error)")
            return false
        }

        // Setup Microphone
        let microphone = AVCaptureDevice.default(for: AVMediaType.audio)

        do {
            let micInput = try AVCaptureDeviceInput(device: microphone!)
            if captureSession.canAddInput(micInput) {
                captureSession.addInput(micInput)
            }
        } catch {
            print("Error setting device audio input: \(error)")
            return false
        }


        // Movie output
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }

        return true
    }
    

    func setupCaptureMode(_ mode: Int) {
        // Video Mode

    }

    //MARK:- Camera Session
    func startSession() {


        if !captureSession.isRunning {
            videoQueue().async {
                self.captureSession.startRunning()
            }
        }
    }

    func stopSession() {
        if captureSession.isRunning {
            videoQueue().async {
                self.captureSession.stopRunning()
            }
        }
    }

    func videoQueue() -> DispatchQueue {
        return DispatchQueue.main
    }



    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation

        switch UIDevice.current.orientation {
        case .portrait:
            orientation = AVCaptureVideoOrientation.portrait
        case .landscapeRight:
            orientation = AVCaptureVideoOrientation.landscapeLeft
        case .portraitUpsideDown:
            orientation = AVCaptureVideoOrientation.portraitUpsideDown
        default:
            orientation = AVCaptureVideoOrientation.landscapeRight
        }

        return orientation
    }

    func startCapture() {

        startRecording()

    }

    //EDIT 1: I FORGOT THIS AT FIRST

    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString

        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }

        return nil
    }


    func startRecording() {

        if movieOutput.isRecording == false {

            let connection = movieOutput.connection(with: AVMediaType.video)
            if (connection?.isVideoOrientationSupported)! {
                connection?.videoOrientation = currentVideoOrientation()
            }

            if (connection?.isVideoStabilizationSupported)! {
                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }

            let device = activeInput.device
            if (device.isSmoothAutoFocusSupported) {
                do {
                    try device.lockForConfiguration()
                    device.isSmoothAutoFocusEnabled = false
                    device.unlockForConfiguration()
                } catch {
                    print("Error setting configuration: \(error)")
                }

            }

            //EDIT2: And I forgot this
            outputURL = tempURL()
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)

        }
        else {
            stopRecording()
        }

    }

    func stopRecording() {

        if movieOutput.isRecording == true {
            movieOutput.stopRecording()
        }
    }

    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {

    }

    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        if (error != nil) {
            print("Error recording movie: \(error!.localizedDescription)")
        } else {

            
           let videoAttachment = outputFileURL
            let videoURL = videoAttachment
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
            

        }
        outputURL = nil
    }
    func toggleFlash() {
        if let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch {
            do {
                try device.lockForConfiguration()
                let torchOn = !device.isTorchActive
                try device.setTorchModeOn(level: 1.0)
                device.torchMode = torchOn ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print("error")
            }
        }
    }

    @IBAction func toggleFlashTapped(_ sender: Any) {
        flashEnabled = !flashEnabled
        
        if flashEnabled == true {
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControl.State())
//            AVCaptureDevice.toggleTorch()
            toggleFlash()
        } else {
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControl.State())
//            AVCaptureDevice.toggleTorch()
            toggleFlash()
        }
    }
}

//extension AVCaptureDevice {
//    @discardableResult
//    class func toggleTorch() -> Bool {
//        guard let defaultDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .unspecified)
//            else {
//                print("early exit")
//                return false
//        }
//        // Check if the default device has torch
//        if  defaultDevice.hasTorch {
//            print("defaultDevice.hasTorch:", defaultDevice.hasTorch)
//
//            // Lock your default device for configuration
//            do {
//                // unlock your device when done
//                defer {
//                    defaultDevice.unlockForConfiguration()
//                    print("defaultDevice.unlockedForConfiguration:", true)
//                }
//                try defaultDevice.lockForConfiguration()
//                print("defaultDevice.lockedForConfiguration:", true)
//                // Toggles the torchMode
//                defaultDevice.torchMode = defaultDevice.torchMode == .on ? .off : .on
//                // Sets the torch intensity to 100% if torchMode is ON
//                if defaultDevice.torchMode == .on {
//                    do {
//                        try defaultDevice.setTorchModeOnWithLevel(1)
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        print("defaultDevice.torchMode:", defaultDevice.torchMode == .on)
//        return defaultDevice.torchMode == .on
//    }
//}

