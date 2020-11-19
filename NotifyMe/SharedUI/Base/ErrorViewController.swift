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

import UIKit

class ErrorViewController: CenterContentViewController {
    private let errorView: ErrorView

    init(errorModel: ErrorViewModel) {
        errorView = ErrorView(errorModel: errorModel, topPadding: Padding.large + 5)
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }

        contentView.addArrangedView(errorView)

        errorView.errorCallback = { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
        }
    }
}
