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
import UIKit

class ConfigManager {
    // MARK: - Config

    public static let shared = ConfigManager()

    private static var configErrorViewController: ErrorViewController?

    // MARK: - API

    public func startConfigRequest(window: UIWindow?) {
        loadConfig { config in
            // self must be strong
            if let config = config {
                self.presentAlertIfNeeded(config: config, window: window)
            }
        }
    }

    // MARK: - Helpers

    private func presentAlertIfNeeded(config: Config, window: UIWindow?) {
        if config.forceUpdate {
            if Self.configErrorViewController == nil {
                let errorVC = ErrorViewController(errorModel: .appUpdateNeeded)
                window?.rootViewController?.topViewController.present(errorVC, animated: false, completion: nil)
                Self.configErrorViewController = errorVC
            }
        } else {
            if Self.configErrorViewController != nil {
                Self.configErrorViewController?.dismiss(animated: true, completion: nil)
                Self.configErrorViewController = nil
            }
        }
    }

    public func loadConfig(completion: @escaping ((Config?) -> Void)) {
        let backend = Environment.current.configService

        let endpoint = backend.endpoint("config", headers: ["User-Agent": Environment.userAgentHeader])

        let task = URLSession.shared.dataTask(with: endpoint.request()) { data, _, error in

            if error != nil {
                completion(nil)
                return
            }

            let decoder = JSONDecoder()

            if let d = data, let config = try? decoder.decode(Config.self, from: d) {
                DispatchQueue.main.async {
                    completion(config)
                }

                return
            }

            completion(nil)
        }

        task.resume()
    }
}

private extension UIViewController {
    var topViewController: UIViewController {
        if let p = presentedViewController {
            return p.topViewController
        } else {
            return self
        }
    }
}
