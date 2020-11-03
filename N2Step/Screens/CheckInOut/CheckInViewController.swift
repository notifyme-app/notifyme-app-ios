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

class CheckInViewController: BaseViewController {
    private var qrCodeViewController: QRCodeScannerViewController?
    private var currentCheckinViewController: CurrentCheckinViewController?

    // MARK: - Init

    override init() {
        super.init()
        title = "checkin_title".ub_localized
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setupQRView()
        setupCheckinView()

        UIStateManager.shared.addObserver(self) { [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.update(state)
        }
    }

    // MARK: - Update

    private func update(_ state: UIStateModel) {
        switch state.checkInState {
        case .noCheckIn:
            currentCheckinViewController?.view.isHidden = true
            qrCodeViewController?.view.isHidden = false

        case let .checkIn(checkIn):
            currentCheckinViewController?.view.isHidden = false
            qrCodeViewController?.view.isHidden = true

            currentCheckinViewController?.checkIn = checkIn
        }
    }

    // MARK: - Setup

    private func setupQRView() {
        let vc = QRCodeScannerViewController()
        addChild(vc)
        view.addSubview(vc.view)

        vc.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        vc.didMove(toParent: self)
        qrCodeViewController = vc
    }

    private func setupCheckinView() {
        let vc = CurrentCheckinViewController()
        addChild(vc)
        view.addSubview(vc.view)

        vc.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        vc.didMove(toParent: self)
        currentCheckinViewController = vc
    }
}
