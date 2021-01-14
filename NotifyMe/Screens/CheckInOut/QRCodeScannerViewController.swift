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

import CrowdNotifierSDK
import Foundation

class QRCodeScannerViewController: BaseSubViewController {
    private var qrView: QRScannerView?
    private var qrOverlay = QRScannerFullOverlayView()

    private let errorContainer = UIView()
    private let errorView = ErrorView(errorModel: .noCameraPermission)

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
        timer?.invalidate()
        timer = nil
        lastQrCode = nil
        qrView?.stopScanning()
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ns_grayBackground
        setupQRView()

        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.startScanning()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopScanning()
    }

    // MARK: - Setup

    private func setupQRView() {
        guard let qrView = self.qrView else { return }

        view.addSubview(qrView)

        qrView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(qrOverlay)

        qrOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(requestLabel)
        requestLabel.text = "qrscanner_scan_qr_text".ub_localized

        requestLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Padding.large)
            make.left.right.equalToSuperview().inset(Padding.mediumSmall)
        }

        view.addSubview(qrErrorLabel)

        qrErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(qrOverlay.scannerOverlay.snp.bottom).offset(Padding.small)
            make.left.right.equalToSuperview().inset(Padding.mediumSmall)
        }

        errorContainer.backgroundColor = .ns_grayBackground
        view.addSubview(errorContainer)
        errorContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        errorContainer.addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Padding.large * 2)
            make.leading.trailing.equalToSuperview().inset(Padding.mediumSmall)
        }

        errorView.errorCallback = handleError(_:)
    }

    // MARK: - Start scanning & error

    private func startScanningProcess() {
        errorContainer.alpha = 0.0
        qrView?.startScanning()
        qrErrorLabel.alpha = 0.0
        qrOverlay.scannerOverlay.lineColor = .ns_purple
    }

    private func showError(_ error: ErrorViewModel) {
        // show a popup if version invalid
        if error == ErrorViewModel.qrCodeVersionInvalid {
            let vc = ErrorViewController(errorModel: error)
            present(vc, animated: true, completion: nil)
        } else {
            qrErrorLabel.alpha = 1.0
            qrErrorLabel.text = error.text
            qrOverlay.scannerOverlay.lineColor = .ns_red

            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { [weak self] _ in
                guard let strongSelf = self else { return }
                UIView.animate(withDuration: 0.2) {
                    strongSelf.qrErrorLabel.alpha = 0.0
                    strongSelf.qrOverlay.scannerOverlay.lineColor = .ns_purple
                }
            })
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension QRCodeScannerViewController: QRScannerViewDelegate {
    func qrScanningDidFail() {
        errorContainer.alpha = 1.0
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

        let result = CrowdNotifier.getVenueInfo(qrCode: str, baseUrl: Environment.current.qrGenBaseUrl)

        switch result {
        case let .success(info):
            stopScanning()
            let vc = CheckInConfirmViewController(qrCode: str, venueInfo: info)

            vc.dismissCallback = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.startScanning()
            }

            present(vc, animated: true, completion: nil)

        case let .failure(failure):
            if let url = URL(string: str), url.host == Environment.current.uploadHost {
                UIApplication.shared.open(url)
                navigationController?.popViewController(animated: true)
            } else {
                showError(failure.errorViewModel)
            }
        }
    }

    func qrScanningDidStop() {
        // TODO: What to do?
    }
}
