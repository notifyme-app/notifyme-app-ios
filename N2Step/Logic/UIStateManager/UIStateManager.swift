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

class UIStateManager: NSObject {
    static let shared = UIStateManager()

    override init() {
        // only one instance
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(updatePush), name: UIApplication.didBecomeActiveNotification, object: nil)

        refresh()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    // MARK: - Refresh triggers

    public func stateChanged() {
        refresh()
    }

    // MARK: - UI State Update

    var pushOk: Bool = true

    private(set) var uiState: UIStateModel! {
        didSet {
            let stateHasChanged = uiState != oldValue

            if stateHasChanged {
                observers = observers.filter { $0.object != nil }
                DispatchQueue.main.async {
                    self.observers.forEach { observer in
                        observer.block(self.uiState)
                    }
                }

                dprint("New UI State")
            }
        }
    }

    func refresh() {
        // disable updates until end of block update
        guard !isPerformingBlockUpdate else {
            return
        }

        // we don't have callback for push permission
        // thus fetch state with every refresh
        updatePush()

        // build new state, sending update to observers if changed
        uiState = UIStateLogic(manager: self).buildState()
    }

    // MARK: - Block Update

    private var isPerformingBlockUpdate = false

    func blockUpdate(_ update: () -> Void) {
        isPerformingBlockUpdate = true
        update()
        isPerformingBlockUpdate = false
        refresh()
    }

    // MARK: - State Observers

    struct Observer {
        weak var object: AnyObject?
        var block: (UIStateModel) -> Void
    }

    private var observers: [Observer] = []

    func addObserver(_ object: AnyObject, block: @escaping (UIStateModel) -> Void) {
        observers.append(Observer(object: object, block: block))
        block(uiState)
    }

    // MARK: - Permission Checks

    @objc private func updatePush() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let isEnabled = settings.alertSetting == .enabled
            DispatchQueue.main.async {
                if self.pushOk != isEnabled {
                    self.pushOk = isEnabled
                    self.refresh()
                }
            }
        }
    }
}
