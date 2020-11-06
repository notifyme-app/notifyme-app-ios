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

    private var titleTimer: Timer?
    private var checkIn: CheckIn?

    // MARK: - Init

    override init() {
        super.init()
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
            qrCodeViewController?.startScanning()
            stopTitleTimer()
            title = "checkin_title".ub_localized

        case let .checkIn(checkIn):
            currentCheckinViewController?.view.isHidden = false
            qrCodeViewController?.view.isHidden = true
            qrCodeViewController?.stopScanning()

            self.checkIn = checkIn
            currentCheckinViewController?.checkIn = checkIn
            startTitleTimer()
        }
    }

    // MARK: - Setup

    private func setupQRView() {
        let vc = QRCodeScannerViewController()
        addSubviewController(vc: vc)
        qrCodeViewController = vc
    }

    private func setupCheckinView() {
        let vc = CurrentCheckinViewController()
        addSubviewController(vc: vc)
        currentCheckinViewController = vc
    }

    // MARK: - Title timer

    private func startTitleTimer() {
        titleTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.title = strongSelf.checkIn?.timeSinceCheckIn() ?? ""
        })
        titleTimer?.fire()
    }

    private func stopTitleTimer() {
        titleTimer?.invalidate()
        titleTimer = nil
    }
}
