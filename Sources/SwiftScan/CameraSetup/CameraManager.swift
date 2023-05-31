//
//  CameraManager.swift
//  
//
//  Created by Justin Honda on 5/31/23.
//

import AVFoundation
import Foundation
import UIKit

public final class CameraManager: ObservableObject {
    
    // MARK: - Properties
    
    public weak var sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    public var captureSession = AVCaptureSession()
    private let captureSessionQueue = DispatchQueue(label: "com.lagunalabs.easyscan.CaptureSessionQueue")
    
    var captureDevice: AVCaptureDevice?
    
    var videoDataOutput = AVCaptureVideoDataOutput()
    let videoDataOutputQueue = DispatchQueue(label: "com.lagunalabs.easyscan.VideoDataOutputQueue")
    
    var bufferAspectRatio: Double = 1920.0 / 1080.0
    
    // MARK: - Methods
    
    public func requestPermissionToUseCamera(_ completion: @escaping (Bool) -> Void) {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        guard authorizationStatus != .authorized else {
            if authorizationStatus == .authorized {
                completion(true)
            } else {
                completion(false)
            }
            return
        }
        AVCaptureDevice.requestAccess(for: .video, completionHandler: completion)
    }
    
    public func setUpCamera(_ completion: (Bool, Error?) -> Void) {
        captureSessionQueue.sync { [weak self] in
            self?.setUp(completion)
        }
    }
    
    public func startCamera() {
        if captureSession.isRunning {
            print("ℹ️ A capture session is already running!")
        } else {
            captureSession.startRunning()
        }
    }
    
    public func stopCamera() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        } else {
            print("ℹ️ No active capture session to stop!")
        }
    }
    
    // MARK: - Helpers
    
    /// Credit: Apple via https://developer.apple.com/documentation/vision/extracting_phone_numbers_from_text_in_images
    private func setUp(_ completion: (Bool, Error?) -> Void) {
        guard let captureDevice = createCaptureDevice() else {
            completion(false, CameraSetupError.couldNotCreateCaptureDevice)
            return
        }
        
        self.captureDevice = captureDevice
        
        // Requesting 4K buffers allows recognition of smaller text but consumes
        // more power. Use the smallest buffer size necessary to minimize
        // battery usage.
        if captureDevice.supportsSessionPreset(.hd4K3840x2160) {
            captureSession.sessionPreset = .hd4K3840x2160
            bufferAspectRatio = 3840.0 / 2160.0
        } else {
            captureSession.sessionPreset = .hd1920x1080
            bufferAspectRatio = 1920.0 / 1080.0
        }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
        } catch {
            completion(false, CameraSetupError.couldNotCreateDeviceInput(error))
            return
        }
        
        // Configure the video data output.
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(sampleBufferDelegate, queue: videoDataOutputQueue)
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
            // There's a trade-off here. Enabling stabilization temporally gives more
            // stable results and should help the recognizer converge, but if it's
            // enabled, the VideoDataOutput buffers don't match what's displayed on
            // screen, which makes drawing bounding boxes difficult. Disable stabilization
            // in this app to allow drawing detected bounding boxes on screen.
            videoDataOutput.connection(with: .video)?.preferredVideoStabilizationMode = .off
        } else {
            completion(false, CameraSetupError.couldNotAddVDOOutput)
            return
        }
        
        do {
            try captureDevice.lockForConfiguration()
            captureDevice.videoZoomFactor = 1
            captureDevice.autoFocusRangeRestriction = .near
            captureDevice.unlockForConfiguration()
        } catch {
            completion(false, CameraSetupError.couldNotSetZoomLevel(error))
            return
        }
        
        completion(true, nil)
    }
    
    private func createCaptureDevice() -> AVCaptureDevice? {
        if let device = AVCaptureDevice.default(.builtInTripleCamera, for: .video, position: .back) {
            return device
        }
        
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        }
        
        if let device = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) {
            return device
        }
        
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        return nil
    }
    
}

// MARK: - CameraSetupError

enum CameraSetupError: Error {
    case couldNotCreateCaptureDevice
    case couldNotCreateDeviceInput(Error)
    case couldNotAddVDOOutput
    case couldNotSetZoomLevel(Error)
}
