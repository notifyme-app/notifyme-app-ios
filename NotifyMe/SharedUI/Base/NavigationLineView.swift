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

class NavigationLineView: UIView {
    // MARK: - Init

    init() {
        super.init(frame: .zero)
        snp.makeConstraints { make in
            make.height.equalTo(1.0)
        }
        backgroundColor = .clear
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Update

    public func updateColor(offset: CGFloat) {
        UIView.animate(withDuration: 0.15) {
            if offset > 0 {
                if self.backgroundColor == .clear {
                    self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                    self.ub_addShadow(with: .black, radius: 3.0, opacity: 1.0, xOffset: 0.0, yOffset: 3.0)
                }
            } else {
                if self.backgroundColor != .clear {
                    self.backgroundColor = .clear
                    self.ub_addShadow(with: .black, radius: 2.0, opacity: 0.0, xOffset: 0.0, yOffset: 2.0)
                }
            }
        }
    }
}
