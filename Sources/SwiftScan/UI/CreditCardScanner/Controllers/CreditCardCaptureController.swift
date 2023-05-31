//
//  CreditCardCaptureController.swift
//  
//
//  Created by Justin Honda on 5/31/23.
//

import AVFoundation
import UIKit

final class CreditCardCaptureController: UIViewController {
    @Published var cameraSetup = CameraManager()
    
    private lazy var previewView: PreviewView = {
        let view = PreviewView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate
    
    init(sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate) {
        self.sampleBufferDelegate = sampleBufferDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraSetup.sampleBufferDelegate = sampleBufferDelegate
        
        view.addSubview(previewView)
        
        NSLayoutConstraint.activate([
            previewView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            previewView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        previewView.session = cameraSetup.captureSession
        
        cameraSetup.setUpCamera { success, error in
            if let error {
                print("Error setting up camera: \(error.localizedDescription)")
                return
            }
            
            if success {
                DispatchQueue.global(qos: .background).async { [weak self] in
                    self?.cameraSetup.startCamera()
                }
            }
        }
    }
    
}
