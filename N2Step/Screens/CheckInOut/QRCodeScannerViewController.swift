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

class QRCodeScannerViewController : BaseViewController {
    var qrView: QRScannerView?

    // MARK: - Init

    override init() {
        super.init()
        qrView = QRScannerView(delegate: self)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setupQRView()
    }

    // MARK: - Setup

    private func setupQRView() {
        guard let qrView = self.qrView else { return }

        view.addSubview(qrView)

        qrView.snp.makeConstraints { make in
            make.height.equalTo(qrView.snp.width)
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(Padding.medium)
        }
    }
}

extension QRCodeScannerViewController: QRScannerViewDelegate {
    func qrScanningDidFail() {
        // TODO: Show error
    }

    func qrScanningSucceededWithCode(_ str: String?) {
        guard let str = str else { return }
        let vc = CheckInConfirmViewController(qrCode: str)
        present(vc, animated: true, completion: nil)
    }

    func qrScanningDidStop() {
        // TODO: What to do?
    }
}
