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

class CheckInConfirmViewController: BaseViewController {
    private let qrCode: String

    // MARK: - Init

    init(qrCode: String) {
        self.qrCode = qrCode
        super.init()

        title = qrCode
        modalPresentationStyle = .overCurrentContext
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.8) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }

    // MARK: - Setup

    private func setup() {
        self.view.backgroundColor = UIColor.clear

        let view = UIView()
        self.view.addSubview(view)

        view.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(450)
            make.left.right.equalToSuperview().inset(Padding.medium)
        }

        view.backgroundColor = UIColor.white

        let label = UILabel()
        label.text = qrCode
        label.textAlignment = .center
        label.textColor = .black

        view.addSubview(label)

        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(Padding.medium)
        }
    }
}
