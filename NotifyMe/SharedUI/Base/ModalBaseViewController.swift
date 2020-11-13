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

class ModalBaseViewController: BaseViewController {
    public let dismissButton = TextButton(text: "done_button".ub_localized)
    public let contentView: StackScrollView

    // MARK: - Init

    init(horizontalContentInset: CGFloat = 0) {
        contentView = StackScrollView(stackViewHorizontalInset: horizontalContentInset)
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }

        contentView.scrollView.ub_enableDefaultKeyboardObserver()

        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Padding.large + Padding.small)
            make.bottom.left.right.equalToSuperview()
        }

        view.addSubview(dismissButton)

        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Padding.small)
            make.right.equalToSuperview().inset(Padding.mediumSmall)
        }

        dismissButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
        }
    }
}
