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

// MARK: - UBLabelType Protocol

public protocol UBLabelType {
    var font: UIFont { get }
    var textColor: UIColor { get }
    var lineSpacing: CGFloat { get }
    var letterSpacing: CGFloat? { get }

    var isUppercased: Bool { get }

    /// between [0.0,1.0]: 0.0 disabled, 1.0 most hyphenation
    var hyphenationFactor: Float { get }

    var lineBreakMode: NSLineBreakMode { get }
}

// MARK: - UBLabel

class UBLabel<T: UBLabelType>: UILabel {
    private let type: T

    private var highlights: [(String, UIColor)] = []

    /// Simple way to initialize Label with T and optional textColor to override standard color of type. Standard multiline and left-aligned.
    init(_ type: T, textColor: UIColor? = nil, numberOfLines: Int = 0, textAlignment: NSTextAlignment = .left) {
        self.type = type

        super.init(frame: .zero)

        font = self.type.font
        self.textColor = textColor == nil ? self.type.textColor : textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var text: String? {
        didSet { update() }
    }

    var isHtmlContent: Bool = false {
        didSet { update() }
    }

    public func addHighlight(text: String, color: UIColor) {
        highlights.append((text, color))
        update()
    }

    /// :nodoc:
    private func update() {
        guard var textContent = text else {
            attributedText = nil
            return
        }

        // uppercase the text if type is uppercased
        if type.isUppercased {
            textContent = textContent.uppercased()
        }

        // create attributed string
        let textString: NSMutableAttributedString

        // check html
        do {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: isHtmlContent ? NSAttributedString.DocumentType.html : NSAttributedString.DocumentType.plain,
                .characterEncoding: String.Encoding.utf8.rawValue,
                .defaultAttributes: [:],
            ]

            textString = try NSMutableAttributedString(data: textContent.data(using: .utf8)!, options: options, documentAttributes: nil)
        } catch {
            textString = NSMutableAttributedString(string: textContent, attributes: [:])
        }

        let textRange = NSRange(location: 0, length: textString.length)

        if isHtmlContent {
            textString.ub_replaceFonts(with: font)
            if let textColor = textColor {
                textString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: textRange)
            }
        } else {
            // check paragraph style
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment

            let lineSpacing = numberOfLines == 1 ? 1.0 : type.lineSpacing

            let lineHeightMultiple = (font.pointSize / font.lineHeight) * lineSpacing
            paragraphStyle.lineSpacing = lineHeightMultiple * font.lineHeight - font.lineHeight
            paragraphStyle.lineBreakMode = type.lineBreakMode

            // check hyphenation
            if numberOfLines != 1 {
                paragraphStyle.hyphenationFactor = type.hyphenationFactor
            }

            // add attribute for paragraph
            textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)

            for (text, color) in highlights {
                let range = (textContent as NSString).range(of: text)
                textString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            }
        }

        // add attribute for kerning
        if let k = type.letterSpacing {
            textString.addAttribute(NSAttributedString.Key.kern, value: k, range: textRange)
        }

        // set attributed text
        attributedText = textString
    }
}

extension NSMutableAttributedString {
    func ub_replaceFonts(with font: UIFont) {
        // from: https://stackoverflow.com/questions/19921972/
        let baseFontDescriptor = font.fontDescriptor
        var changes = [NSRange: UIFont]()

        enumerateAttribute(.font, in: NSRange(location: 0, length: length), options: []) { foundFont, range, _ in
            if let htmlTraits = (foundFont as? UIFont)?.fontDescriptor.symbolicTraits,
               let adjustedDescriptor = baseFontDescriptor.withSymbolicTraits(htmlTraits) {
                let newFont = UIFont(descriptor: adjustedDescriptor, size: font.pointSize)
                changes[range] = newFont
            }
        }

        changes.forEach { range, newFont in
            removeAttribute(.font, range: range)
            addAttribute(.font, value: newFont, range: range)
        }
    }
}
