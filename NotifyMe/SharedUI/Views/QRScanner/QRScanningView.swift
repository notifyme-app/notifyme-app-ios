//
//  QRScanningView.swift
//  AccessApp
//
//  Created by Stefan Mitterrutzner on 18.03.20.
//  Copyright © 2020 Ubique. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

/// Delegate callback for the QRScannerView.
protocol QRScannerViewDelegate: AnyObject {
    func qrScanningDidFail()
    func qrScanningSucceededWithCode(_ str: String?)
    func qrScanningDidStop()
}

class QRScannerView: UIView {
    weak var delegate: QRScannerViewDelegate?

    /// capture settion which allows us to start and stop scanning.
    var captureSession: AVCaptureSession?

    init(delegate: QRScannerViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        doInitialSetup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: overriding the layerClass to return `AVCaptureVideoPreviewLayer`.

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    override var layer: AVCaptureVideoPreviewLayer {
        return super.layer as! AVCaptureVideoPreviewLayer
    }

    override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: 350)
    }
}

extension QRScannerView {
    var isRunning: Bool {
        return captureSession?.isRunning ?? false
    }

    func startScanning() {
        doInitialSetup()
        captureSession?.startRunning()
    }

    func stopScanning() {
        captureSession?.stopRunning()
        delegate?.qrScanningDidStop()
    }

    /// Does the initial setup for captureSession
    private func doInitialSetup() {
        clipsToBounds = true
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            #if targetEnvironment(simulator)
                let json = """
                {"rp":{"name":"AccessApp","id":"mtls.ubique.ch"},"user":{"name":"asdf@asdfd.de","displayName":"asdf@asdfd.de","id":"AAAALA"},"challenge":"fjW_x2wrmT8oD5OdmgF4ppeS9_1zRaweVCk5Oz8nO5Q","pubKeyCredParams":[{"alg":-7,"type":"public-key"}],"excludeCredentials":[],"attestation":"none","extensions":{}}
                """
                stopScanning()
                found(code: json)
            #endif
            return
        }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            scanningDidFail()
            return
        }

        if captureSession?.canAddInput(videoInput) ?? false {
            captureSession?.addInput(videoInput)
        } else {
            scanningDidFail()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession?.canAddOutput(metadataOutput) ?? false {
            captureSession?.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417]
        } else {
            scanningDidFail()
            return
        }

        layer.session = captureSession
        layer.videoGravity = .resizeAspectFill
    }

    func scanningDidFail() {
        delegate?.qrScanningDidFail()
        captureSession = nil
    }

    func found(code: String) {
        delegate?.qrScanningSucceededWithCode(code)
    }
}

extension QRScannerView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from _: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            found(code: stringValue)
        }
    }
}
