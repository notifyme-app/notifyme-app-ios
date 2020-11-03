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

class ReportsViewController: BaseViewController {
    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()

        UIStateManager.shared.addObserver(self) { [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.update(state)
        }
    }

    // MARK: - Update

    private func update(_ state: UIStateModel) {
        switch state.reportState {
        case .noReport:
            title = "no_report_title".ub_localized

        case let .report(reports):
            title = reports.count > 1 ? "report_title_plural".ub_localized.replacingOccurrences(of: "{NUMBER}", with: "\(reports.count)") : "report_title_singular".ub_localized
        }
    }
}
