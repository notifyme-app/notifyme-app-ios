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
    case textSemiBold
    case textBold
    case boldUppercase

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
            return UIFont(name: boldFontName, size: bfs + 10.0)!
        case .heroTitle:
            return UIFont(name: boldFontName, size: bfs + 25.0)!
        case .title:
            return UIFont(name: boldFontName, size: bfs + 15.0)!
        case .subtitle:
            return UIFont(name: boldFontName, size: bfs + 4.0)!
        case .text:
            return UIFont(name: regularFontName, size: bfs)!
        case .textSemiBold:
            // TODO: fix
            return UIFont(name: boldFontName, size: bfs)!
        case .textBold:
            return UIFont(name: boldFontName, size: bfs)!
        case .boldUppercase:
            return UIFont(name: boldFontName, size: bfs)!
        }
    }

    public var textColor: UIColor {
        switch self {
        case .boldUppercase:
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
            return 45.0 / 41.0
        case .title:
            return 37.0 / 31.0
        case .subtitle:
            return 24.0 / 20.0
        case .text:
            return 20.0 / 16.0
        case .textSemiBold:
            return 20.0 / 16.0
        case .textBold:
            return 20.0 / 16.0
        case .boldUppercase:
            return 26.0 / 16.0
        }
    }

    public var letterSpacing: CGFloat? {
        if self == .boldUppercase {
            return 1.0
        }

        return nil
    }

    public var isUppercased: Bool {
        if self == .boldUppercase {
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
