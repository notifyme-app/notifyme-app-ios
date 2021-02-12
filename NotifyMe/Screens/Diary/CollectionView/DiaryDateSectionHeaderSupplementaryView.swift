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

class DiaryDateSectionHeaderSupplementaryView: UICollectionReusableView {
    private let label = Label(.boldUppercaseSmall, textColor: .ns_text)

    var customHeaderView: UIView? {
        willSet {
            customHeaderView?.removeFromSuperview()
        }
        didSet {
            update()
        }
    }

    public var date: Date? {
        didSet {
            if let d = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE, MMM d"
                label.text = formatter.string(from: d)
            }
        }
    }

    public var text: String? {
        didSet {
            label.text = text
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(label)

        label.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: Padding.small, right: Padding.small))
        }
    }

    private func update() {
        if let view = customHeaderView {
            addSubview(view)
            view.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
            }

            label.snp.remakeConstraints { make in
                make.top.equalTo(view.snp.bottom).offset(Padding.large)
                make.bottom.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: Padding.small, right: Padding.small))
            }
        } else {
            label.snp.remakeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: Padding.small, right: Padding.small))
            }
        }
    }
}
