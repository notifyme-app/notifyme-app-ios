//
/*
 * Copyright (c) 2020 Ubique Innovation AG <https://www.ubique.ch>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * SPDX-License-Identifier: MPL-2.0
 */

import Foundation

class ExternalLinkButton: UBButton {
    // MARK: - Init

    override init() {
        super.init()
        updateLayout()
    }

    private func updateLayout() {
        let color: UIColor = .ns_purple
        var image = UIImage(named: "icons-ic-link-external")

        image = image?.ub_image(with: color)
        titleLabel?.textAlignment = .left

        setTitleColor(color, for: .normal)

        let spacing: CGFloat = Padding.small

        imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: spacing)
        titleEdgeInsets = UIEdgeInsets(top: 4.0, left: spacing, bottom: 4.0, right: 0.0)

        setImage(image, for: .normal)

        titleLabel?.font = LabelType.text.font

        highlightXInset = -5.0
        highlightYInset = -5.0
        highlightedBackgroundColor = UIColor.ns_genericTouchState
        highlightCornerRadius = 3.0
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Fix content size

    override public var intrinsicContentSize: CGSize {
        guard !(title?.isEmpty ?? true) else { return .zero }
        var size = titleLabel?.intrinsicContentSize ?? super.intrinsicContentSize
        size.width = size.width + titleEdgeInsets.left + titleEdgeInsets.right + 30
        size.height = size.height + titleEdgeInsets.top + titleEdgeInsets.bottom + 10
        return size
    }
}
