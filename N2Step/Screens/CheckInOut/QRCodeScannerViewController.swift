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
import N2StepSDK

class QRCodeScannerViewController: BaseViewController {
    private var qrView: QRScannerView?
    private var qrOverlay = QRScannerOverlay()

    private let requestLabel = Label(.text, textAlignment: .center)
    private let qrErrorLabel = Label(.boldUppercaseSmall, textColor: UIColor.ns_red, textAlignment: .center)

    private var lastQrCode: String?

    private var timer: Timer?

    // MARK: - Init

    override init() {
        super.init()
        qrView = QRScannerView(delegate: self)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Scanning

    public func startScanning() {
        lastQrCode = nil
        startScanningProcess()
    }

    public func stopScanning() {
        lastQrCode = nil
        qrView?.stopScanning()
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ns_grayBackground
        setupQRView()
    }

    // MARK: - Setup

    private func setupQRView() {
        guard let qrView = self.qrView else { return }

        view.addSubview(qrView)

        qrView.snp.makeConstraints { make in
            make.height.equalTo(qrView.snp.width)
            make.top.equalToSuperview().inset(3 * Padding.large)
            make.left.right.equalToSuperview().inset(Padding.large + 1.5 * qrOverlay.lineWidth)
        }

        view.addSubview(qrOverlay)

        qrOverlay.snp.makeConstraints { make in
            make.edges.equalTo(qrView).inset(-1.5 * qrOverlay.lineWidth)
        }

        view.addSubview(requestLabel)
        requestLabel.text = "qrscanner_scan_qr_text".ub_localized

        requestLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Padding.large)
            make.left.right.equalToSuperview().inset(Padding.mediumSmall)
        }

        view.addSubview(qrErrorLabel)
        qrErrorLabel.text = "qrscanner_error".ub_localized

        qrErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(qrOverlay.snp.bottom).offset(Padding.small)
            make.left.right.equalToSuperview().inset(Padding.mediumSmall)
        }
    }

    // MARK: - Start scanning & error

    private func startScanningProcess() {
        qrView?.startScanning()
        qrErrorLabel.alpha = 0.0
        qrOverlay.lineColor = .ns_purple
    }

    private func showError() {
        qrErrorLabel.alpha = 1.0
        qrOverlay.lineColor = .ns_red

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { [weak self] _ in
            guard let strongSelf = self else { return }
            UIView.animate(withDuration: 0.2) {
                strongSelf.qrErrorLabel.alpha = 0.0
                strongSelf.qrOverlay.lineColor = .ns_purple
            }
        })
    }
}

extension QRCodeScannerViewController: QRScannerViewDelegate {
    func qrScanningDidFail() {
        // TODO: Show error
    }

    func qrScanningSucceededWithCode(_ str: String?) {
        if lastQrCode == nil {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        } else if let lastCode = lastQrCode {
            if let str = str, lastCode != str {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            }
        }

        guard let str = str else { return }
        lastQrCode = str

        let result = N2Step.getVenueInfo(qrCode: str)

        switch result {
        case let .success(info):
            stopScanning()
            let vc = CheckInConfirmViewController(qrCode: str, venueInfo: info)
            present(vc, animated: true, completion: nil)
        case let .failure(error):
            showError()
        }
    }

    func qrScanningDidStop() {
        // TODO: What to do?
    }
}
