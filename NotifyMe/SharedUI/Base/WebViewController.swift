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
import WebKit

class WebViewController: ModalBaseViewController {
    // MARK: - Variables

    private let webView: WKWebView
    private var loadCount: Int = 0
    private let mode: Mode

    enum Mode {
        case local(String)
    }

    // MARK: - Init

    init(mode: Mode) {
        self.mode = mode

        let config = WKWebViewConfiguration()
        config.dataDetectorTypes = []

        switch mode {
        case .local:
            // Disable zoom in web view
            let source: String = "var meta = document.createElement('meta');" +
                "meta.name = 'viewport';" +
                "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
                "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
            let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd,
                                                    forMainFrameOnly: true)

            let contentController = WKUserContentController()
            contentController.addUserScript(script)
            config.userContentController = contentController
        }

        webView = WKWebView(frame: .zero, configuration: config)

        super.init(useXCloseButton: true)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        switch mode {
        case let .local(local):
            loadLocal(local)
        }
    }

    private func loadLocal(_ local: String) {
        guard let path = Bundle.main.path(forResource: local, ofType: "html", inDirectory: "Impressum/\(String.languageKey)/")
        else { return }

        let url = URL(fileURLWithPath: path)

        do {
            var string = try String(contentsOf: url)

            string = string.replacingOccurrences(of: "{VERSION}", with: Bundle.appVersion)
            string = string.replacingOccurrences(of: "{BUILD}", with: Bundle.buildNumber + Bundle.environment + "<br>" + (UBPushManager.shared.pushToken?.suffix(6) ?? "-"))
            string = string.replacingOccurrences(of: "{APPVERSION}", with: Bundle.appVersion)

            webView.loadHTMLString(string, baseURL: url.deletingLastPathComponent())
        } catch {}
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Setup

    private func setup() {
        webView.navigationDelegate = self

        contentView.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.delegate = self
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        switch navigationAction.navigationType {
        case .linkActivated:
            guard let url = navigationAction.request.url,
                  let scheme = url.scheme else {
                decisionHandler(.allow)
                return
            }

            if scheme == "http" || scheme == "https" || scheme == "mailto" || scheme == "tel" {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            }

            decisionHandler(.allow)
            return

        default:
            decisionHandler(.allow)
            return
        }
    }
}

extension Bundle {
    static var environment: String {
        switch Environment.current {
        case .dev:
            return " DEV"
        case .abnahme:
            return " ABNAHME"
        case .prod:
            return "p"
        }
    }
}
