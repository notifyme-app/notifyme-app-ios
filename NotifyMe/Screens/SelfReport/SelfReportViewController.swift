//
/*
 * Copyright (c) 2021 Ubique Innovation AG <https://www.ubique.ch>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * SPDX-License-Identifier: MPL-2.0
 */

import UIKit

class SelfReportViewController: LocalAuthenticationViewController {
    private let cancelButton = TextButton(text: "Abbrechen")

    private let diaryViewController = DiaryViewController(bypassAuthentication: true) // We already authenticate with the parent view controller

    private let bottomContainer = UIView()
    private let bottomButton = BigButton(style: .small, text: "Tagebuch teilen")

    override func handleSuccess() {
        addSubviews()
        setupButtons()

        addContent()
    }

    private func addSubviews() {
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(Padding.mediumSmall)
        }

        addChild(diaryViewController)
        view.addSubview(diaryViewController.view)
        diaryViewController.view.snp.makeConstraints { make in
            make.top.equalTo(cancelButton.snp.bottom).offset(Padding.mediumSmall)
            make.leading.trailing.equalToSuperview()
        }
        diaryViewController.didMove(toParent: self)

        bottomContainer.backgroundColor = .white
        bottomContainer.ub_addShadow(radius: 10, opacity: 0.1, xOffset: 0, yOffset: -5)
        view.addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints { make in
            make.top.equalTo(diaryViewController.view.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        bottomContainer.addSubview(bottomButton)
        bottomButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(Padding.medium)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(bottomContainer.safeAreaLayoutGuide).inset(Padding.large)
            } else {
                make.bottom.equalToSuperview().inset(Padding.large)
            }
        }
    }

    private func setupButtons() {
        cancelButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true)
        }
    }

    private func addContent() {
        let title = Label(.title)
        title.text = "Sie wurden positiv getestet?"

        let explanation = Label(.text)
        explanation.text = "Unterstützen Sie das Contact Tracing, indem Sie Ihr Tagebuch teilen."

        let headerContainer = UIView()
        headerContainer.addSubview(title)
        headerContainer.addSubview(explanation)

        title.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        explanation.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(Padding.small)
            make.leading.trailing.bottom.equalToSuperview()
        }

        diaryViewController.collectionView.setup()
        diaryViewController.customHeaderView = headerContainer
    }

    override func handleError(_: Error) {
        dismiss(animated: true)
    }
}
