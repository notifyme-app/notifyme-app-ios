/*
 * Copyright (c) 2020 Ubique Innovation AG <https://www.ubique.ch>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * SPDX-License-Identifier: MPL-2.0
 */

import UIKit

public extension UIView {
    /// Adds shadow to UIView with black color and other parameters
    func ub_addShadow(with color: UIColor = UIColor.black, radius: CGFloat, opacity: CGFloat, xOffset: CGFloat, yOffset: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = Float(opacity)
        layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
        layer.shadowRadius = radius
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    /// Sets contentHuggingPriority and contentCompressionResistance to highest priority both vertical and horizontal
    @objc func ub_setContentPriorityRequired() {
        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }

    /// Sets a corner mask with support for iOS < 11.0
    func ub_roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            layer.cornerRadius = radius
            layer.maskedCorners = corners
        } else {
            layer.cornerRadius = 0
            let mask = CAShapeLayer()
            mask.frame = bounds

            var cornerMask = UIRectCorner()
            if corners.contains(.layerMinXMinYCorner) {
                cornerMask.insert(.topLeft)
            }
            if corners.contains(.layerMaxXMinYCorner) {
                cornerMask.insert(.topRight)
            }
            if corners.contains(.layerMinXMaxYCorner) {
                cornerMask.insert(.bottomLeft)
            }
            if corners.contains(.layerMaxXMaxYCorner) {
                cornerMask.insert(.bottomRight)
            }
            mask.path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners:
                cornerMask, cornerRadii: CGSize(width: radius, height: radius)
            ).cgPath
            layer.mask = mask
        }
    }
}
