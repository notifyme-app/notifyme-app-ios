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

class NSFontSize {
    private static let normalBodyFontSize: CGFloat = 16.0

    public static func bodyFontSize() -> CGFloat {
        // default from system is 17.
        let bfs = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.body).pointSize - 1.0

        let preferredSize: CGFloat = normalBodyFontSize
        let maximum: CGFloat = 1.5 * preferredSize
        let minimum: CGFloat = 0.5 * preferredSize

        return min(max(minimum, bfs), maximum)
    }

    public static let fontSizeMultiplicator: CGFloat = {
        max(1.0, bodyFontSize() / normalBodyFontSize)
    }()
}

public enum LabelType: UBLabelType {
    case navigationBarTitle
    case heroTitle
    case title
    case subtitle
    case text
    case textBold
    case boldUppercase
    case boldUppercaseSmall

    public var font: UIFont {
        let bfs = NSFontSize.bodyFontSize()

        var boldFontName = "Inter-Bold"
        var regularFontName = "Inter-Regular"
        var lightFontName = "Inter-Light"

        if #available(iOS 13.0, *) {
            switch UITraitCollection.current.legibilityWeight {
            case .bold:
                boldFontName = "Inter-ExtraBold"
                regularFontName = "Inter-Bold"
                lightFontName = "Inter-Medium"
            default:
                break
            }
        }

        switch self {
        case .navigationBarTitle:
            return monospacedDigitFont(fontName: boldFontName, size: bfs + 10.0)
        case .heroTitle:
            return UIFont(name: boldFontName, size: bfs + 24.0)!
        case .title:
            return UIFont(name: boldFontName, size: bfs + 12.0)!
        case .subtitle:
            return UIFont(name: boldFontName, size: bfs)!
        case .text:
            return UIFont(name: lightFontName, size: bfs)!
        case .textBold:
            return UIFont(name: boldFontName, size: bfs)!
        case .boldUppercase:
            return UIFont(name: boldFontName, size: bfs)!
        case .boldUppercaseSmall:
            return UIFont(name: boldFontName, size: bfs - 3.0)!
        }
    }

    public var textColor: UIColor {
        switch self {
        case .boldUppercase, .boldUppercaseSmall:
            return .white
        default:
            return .ns_text
        }
    }

    public var lineSpacing: CGFloat {
        switch self {
        case .navigationBarTitle:
            return 1.0
        case .heroTitle:
            return 45.0 / 40.0
        case .title:
            return 28.0 / 30.0
        case .subtitle:
            return 22.0 / 16.0
        case .text:
            return 22.0 / 16.0
        case .textBold:
            return 22.0 / 16.0
        case .boldUppercase:
            return 26.0 / 16.0
        case .boldUppercaseSmall:
            return 1.0
        }
    }

    public var letterSpacing: CGFloat? {
        if self == .boldUppercase || self == .boldUppercaseSmall {
            return 1.0
        }

        return nil
    }

    public var isUppercased: Bool {
        if self == .boldUppercase || self == .boldUppercaseSmall {
            return true
        }

        return false
    }

    public var hyphenationFactor: Float {
        return 0.0
    }

    public var lineBreakMode: NSLineBreakMode {
        if self == .heroTitle { return .byWordWrapping }
        return .byTruncatingTail
    }

    /// Returns a font with monospaced digits of the given size
    func monospacedDigitFont(fontName: String, size: CGFloat) -> UIFont {
        let originalDescriptor = UIFont(name: fontName, size: size)!.fontDescriptor
        let featureArray: [[UIFontDescriptor.FeatureKey: Any]] = [
            [
                .featureIdentifier: kNumberSpacingType,
                .typeIdentifier: kMonospacedNumbersSelector,
            ],
        ]
        let descriptor = originalDescriptor.addingAttributes([.featureSettings: featureArray])
        return UIFont(descriptor: descriptor, size: 0)
    }
}

class Label: UBLabel<LabelType> {
    private var labelType: LabelType

    override init(_ type: LabelType, textColor: UIColor? = nil, numberOfLines: Int = 0, textAlignment: NSTextAlignment = .left) {
        labelType = type
        super.init(type, textColor: textColor, numberOfLines: numberOfLines, textAlignment: textAlignment)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            font = labelType.font
        }
    }
}
