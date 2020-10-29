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

class CheckInViewController : BaseViewController
{
    var qrView : QRScannerView?

    // MARK: - Init

    override init()
    {
        super.init()
        self.title = "checkin_title".ub_localized
        self.qrView = QRScannerView(delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupQRView()
    }

    // MARK: - Setup

    private func setupQRView()
    {
        guard let qrView = self.qrView else { return }

        self.view.addSubview(qrView)

        qrView.snp.makeConstraints({ (make) in
            make.height.equalTo(qrView.snp.width)
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(Padding.medium)
        })
    }
}

extension CheckInViewController : QRScannerViewDelegate
{
    func qrScanningDidFail() {
        // TODO: Show error
    }

    func qrScanningSucceededWithCode(_ str: String?) {
        guard let str = str else { return }
        let vc = CheckInConfirmViewController(qrCode: str)
        self.present(vc, animated: true, completion: nil)
    }

    func qrScanningDidStop() {
        // TODO: What to do?
    }
}
