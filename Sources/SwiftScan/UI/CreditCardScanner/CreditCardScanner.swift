//
//  CreditCardScanner.swift
//  
//
//  Created by Justin Honda on 5/31/23.
//

import SwiftUI
import Vision

public struct CreditCardScanner<Content: View, TextDecoration: View>: View {
    @Binding var creditCardNumber: String
    @Binding var confidence: VNConfidence
    let verticalPlacement: VerticalPlacement
    let cutoutConfiguation: CutoutBorderConfiguration
    let surroundingView: () -> Content
    let textDecorationView: () -> TextDecoration
    
    @State private var cutoutBorderColor: Color
    
    public init(
        number: Binding<String>,
        confidence: Binding<VNConfidence> = .constant(.zero),
        verticalPlacement: VerticalPlacement = .center,
        cutoutConfiguration: CutoutBorderConfiguration = .roundedWhite,
        surroundingView: @escaping () -> Content = { Color.white.opacity(0.5) },
        textDecorationView: @escaping () -> TextDecoration = { Text("") }
    ) {
        self._creditCardNumber = number
        self._confidence = confidence
        self.verticalPlacement = verticalPlacement
        self.cutoutConfiguation = cutoutConfiguration
        self.surroundingView = surroundingView
        self.textDecorationView = textDecorationView
        self._cutoutBorderColor = .init(initialValue: cutoutConfiguration.color)
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let cardCaptureCutoutWidth = proxy.size.width * 0.8
            let cardCaptureCutoutHeight = cardCaptureCutoutWidth / 1.586 // ISO/IEC 7810 credit card aspect ratio
            let size = CGSize(width: cardCaptureCutoutWidth, height: cardCaptureCutoutHeight)
            let position = CGPoint(x: proxy.size.width / 2, y: proxy.size.height * verticalPlacement.value)
            ZStack {
                surroundingView()
                Color.white
                    .frame(width: cardCaptureCutoutWidth, height: cardCaptureCutoutHeight)
                    .cornerRadius(10)
                    .blendMode(.destinationOut)
                    .position(.init(x: proxy.size.width / 2, y: proxy.size.height * verticalPlacement.value))
                    .overlay {
                        makeCutoutBorder(size: size, position: position)
                            .overlay {
                                textDecorationView()
                                    .position(position)
                                    .offset(
                                        y: cutoutConfiguation.textDecorationPosition == .below
                                            ? (size.height / 2) + 24
                                            : (-size.height / 2) - 24
                                    )
                            }
                    }
                    .onChange(of: confidence) { updatedConfidence in
                        cutoutBorderColor = updatedConfidence.borderColor
                    }
            }
            .compositingGroup()
            .background {
                CreditCardCaptureControllerRepresentable(
                    creditCardNumber: $creditCardNumber,
                    confidence: $confidence,
                    verticalPlacement: verticalPlacement
                )
                .ignoresSafeArea()
            }
        }
        .animation(.default, value: cutoutBorderColor)
    }
    
    private func makeCutoutBorder(size: CGSize, position: CGPoint) -> some View {
        RoundedRectangle(cornerRadius: cutoutConfiguation.cornerRadius, style: cutoutConfiguation.style)
            .stroke(cutoutBorderColor, lineWidth: cutoutConfiguation.lineWidth)
            .frame(width: size.width, height: size.height)
            .position(position)
            .if(cutoutConfiguation.cornerDecoration == .sharp) {
                $0.modifier(AddSharpCornersOnlyModifier(length: cutoutConfiguation.sharpCornerLength, color: cutoutConfiguation.cornerDecorationColor, lineWidth: cutoutConfiguation.lineWidth + 0.5, size: size, position: position))
            }
            .if(cutoutConfiguation.cornerDecoration == .rounded) {
                $0.modifier(AddRoundedCornersOnlyModifier(cornerRadius: cutoutConfiguation.cornerRadius, color: cutoutConfiguation.cornerDecorationColor, lineWidth: cutoutConfiguation.lineWidth + 0.5, size: size, position: position))
            }
    }
}

// MARK: - Previews

struct CreditCardScanner_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardScanner(number: .constant(""))
    }
}
