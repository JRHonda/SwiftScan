//
//  CreditCardCaptureControllerRepresentable.swift
//  
//
//  Created by Justin Honda on 5/31/23.
//

import AVFoundation
import CoreHaptics
import SwiftUI
import Vision

/**
 TODO: - Add support for different device orientations
 */

struct CreditCardCaptureControllerRepresentable: UIViewControllerRepresentable {
    @Binding var creditCardNumber: String
    @Binding var confidence: VNConfidence
    let verticalPlacement: VerticalPlacement
    
    init(creditCardNumber: Binding<String>, confidence: Binding<VNConfidence>, verticalPlacement: VerticalPlacement = .center) {
        self._creditCardNumber = creditCardNumber
        self._confidence = confidence
        self.verticalPlacement = verticalPlacement
    }
    
    func makeUIViewController(context: Context) -> CreditCardCaptureController {
        CreditCardCaptureController(sampleBufferDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: CreditCardCaptureController, context: Context) {
        if context.coordinator.isCaptureComplete {
            uiViewController.cameraSetup.stopCamera()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        @Published var isCaptureComplete = false
        let creditCardTracker = CreditCardStringTracker()
        var parent: CreditCardCaptureControllerRepresentable
        var request: VNRecognizeTextRequest!
        private let mediumImpactHaptic = UIImpactFeedbackGenerator(style: .medium)
        
        init(_ parent: CreditCardCaptureControllerRepresentable) {
            self.parent = parent
            super.init()
            request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                request.recognitionLevel = .accurate
                request.usesLanguageCorrection = false
                
                // Calculate region of interest to match the dimensions (ratio) of a credit card
                let screenBounds = UIScreen.main.bounds
                let screenWidth = screenBounds.width
                let screenHeight = screenBounds.height
                
                let cutoutYCenter = screenHeight * (1 - parent.verticalPlacement.value)
                
                let cutoutWidth = screenWidth * 0.8
                let cutoutHeight = cutoutWidth / (1.586 * 2.0) // helps focus on expected area for card number
                let originY = (cutoutYCenter - (cutoutHeight / 4)) / screenHeight // helps focus on expected area for card number
                let hPadding = 0.27	
                
                request.regionOfInterest = .init(x: hPadding, y: originY, width: 1 - (hPadding * 2), height: cutoutHeight / screenHeight)
                
                let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
                do {
                    try requestHandler.perform([request])
                } catch {
                    print(String(describing: error))
                }
            }
        }
        
        // The Vision recognition handler.
        private func recognizeTextHandler(request: VNRequest, error: Error?) {
            guard let results = request.results as? [VNRecognizedTextObservation] else {
                return
            }
            
            let maxiumumCandidates = 1
            
            for visionResult in results {
                guard let candidate = visionResult.topCandidates(maxiumumCandidates).first else { continue }
                
                let digitized = candidate.string.digitized
                // 15 = Amex, 16 = Others (Visa, Mastercard, etc.)
                if digitized.count >= 15 && digitized.count < 17 {
                    creditCardTracker.logFrame(strings: [digitized])
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.mediumImpactHaptic.impactOccurred()
                        self?.parent.confidence = candidate.confidence
                        
                        if let confidentlyCapturedCreditCard = self?.creditCardTracker.getStableString() {
                            self?.parent.creditCardNumber = confidentlyCapturedCreditCard
                            self?.creditCardTracker.reset(string: confidentlyCapturedCreditCard)
                            self?.isCaptureComplete = true
                        } else {
                            self?.isCaptureComplete = false
                        }
                    }
                }
            }
        }
    }
}
