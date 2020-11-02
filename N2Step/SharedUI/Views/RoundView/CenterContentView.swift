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
import SnapKit

class CenterContentView : UIView
{
    public let dismissButton = UBButton()
    public let contentView = StackScrollView()

    public var heightConstraint : Constraint?
    private let maxHeight = 450

    init(maxHeight: CGFloat)
    {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup()
    {
        self.backgroundColor = .white
        self.ub_addShadow(radius: 10, opacity: 0.3, xOffset: 0, yOffset: 0)
        self.layer.cornerRadius = 36

        self.dismissButton.title = "X"
        self.dismissButton.backgroundColor = .green

        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(Padding.large)
            make.left.right.bottom.equalToSuperview().inset(Padding.medium)
        }

        self.addSubview(self.dismissButton)

        self.dismissButton.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview().inset(Padding.small)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }

        self.contentView.scrollView.alwaysBounceVertical = false

        self.contentView.scrollView.snp.makeConstraints { (make) in
            make.height.lessThanOrEqualTo(self.maxHeight).priority(.required)
            self.heightConstraint = make.height.equalTo(0).offset(self.contentView.scrollView.contentSize.height).priority(.high).constraint
        }
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.heightConstraint?.update(offset: self.contentView.scrollView.intrinsicContentSize.height)
//        print("HEight \(self.contentView.scrollView.contentSize.height)")
//    }
}
