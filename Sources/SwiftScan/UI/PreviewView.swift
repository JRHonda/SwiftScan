//
//  PreviewView.swift
//  
//
//  Created by Justin Honda on 5/31/23.
//

import AVFoundation
import UIKit

final class PreviewView: UIView {
    /// Overrides the default type of layer,`CALayer`, for this view
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            assert(false, "⛔️ Underlying CALayer is not AVCaptureVideoPreviewLayer")
        }
        layer.videoGravity = .resizeAspectFill
        return layer
    }
    
    var session: AVCaptureSession? {
        get { videoPreviewLayer.session }
        set { videoPreviewLayer.session = newValue }
    }
}
