//
//  QRScannerOverlay.swift
//  AccessApp
//
//  Created by Stefan Mitterrutzner on 24.03.20.
//  Copyright © 2020 Ubique. All rights reserved.
//

import UIKit

open class QRScannerOverlay: UIView {
    var lineWidth: CGFloat = 5

    var lineColor: UIColor = .black

    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.clear
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func drawCorners(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor.withAlphaComponent(0.7).cgColor)

        let height = rect.size.height
        let width = rect.size.width

        let offset: CGFloat = 0.1
        let rectangleSize = min(height, width) - 2 * min(height, width) * offset
        let xOffset = (width - rectangleSize) / 2
        let yOffset = (height - rectangleSize) / 2
        let cornerLenght = rectangleSize * 0.2

        // Top left
        context.beginPath()
        context.move(to: .init(x: xOffset, y: yOffset + cornerLenght))
        context.addLine(to: .init(x: xOffset, y: yOffset))
        context.addLine(to: .init(x: xOffset + cornerLenght, y: yOffset))
        context.strokePath()

        // Top right
        context.beginPath()
        context.move(to: .init(x: xOffset + rectangleSize - cornerLenght, y: yOffset))
        context.addLine(to: .init(x: xOffset + rectangleSize, y: yOffset))
        context.addLine(to: .init(x: xOffset + rectangleSize, y: yOffset + cornerLenght))
        context.strokePath()

        // Bottom left
        context.beginPath()
        context.move(to: .init(x: xOffset, y: yOffset + rectangleSize - cornerLenght))
        context.addLine(to: .init(x: xOffset, y: yOffset + rectangleSize))
        context.addLine(to: .init(x: xOffset + cornerLenght, y: yOffset + rectangleSize))
        context.strokePath()

        // Bottom right
        context.beginPath()
        context.move(to: .init(x: xOffset + rectangleSize - cornerLenght, y: yOffset + rectangleSize))
        context.addLine(to: .init(x: xOffset + rectangleSize, y: yOffset + rectangleSize))
        context.addLine(to: .init(x: xOffset + rectangleSize, y: yOffset + rectangleSize - cornerLenght))
        context.strokePath()
    }

    override public func draw(_ rect: CGRect) {
        drawCorners(rect)
    }
}
