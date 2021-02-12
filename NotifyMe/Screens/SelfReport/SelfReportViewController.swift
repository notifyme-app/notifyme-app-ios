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

import CrowdNotifierSDK
import UIKit

class SelfReportViewController: LocalAuthenticationViewController {
    private let cancelButton = TextButton(text: "Abbrechen")

    private let diaryViewController = DiaryViewController(bypassAuthentication: true) // We already authenticate with the parent view controller

    private let thankyouMessage = Label(.title)

    private let bottomContainer = UIView()
    private let bottomButton = BigButton(style: .small, text: "Tagebuch teilen")

    private let backend = Environment.current.backendService

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

        thankyouMessage.text = "Vielen Dank & Gute Besserung"
        thankyouMessage.alpha = 0
        view.addSubview(thankyouMessage)
        thankyouMessage.snp.makeConstraints { make in
            make.top.equalTo(cancelButton.snp.bottom).offset(Padding.mediumSmall)
            make.leading.trailing.equalToSuperview().inset(Padding.mediumSmall)
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

        bottomButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.uploadDiary()
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

    private func uploadDiary() {
        var entries = DiaryEntryWrapper()
        entries.diaryEntries = CheckInManager.shared.getDiary().compactMap {
            guard let checkOutTime = $0.checkOutTime else { return nil }

            var entry = DiaryEntry()
            entry.name = $0.venue.name
            entry.location = $0.venue.location
            entry.room = $0.venue.room
            entry.venueType = $0.venue.venueType.diaryEntryVenueType
            entry.checkinTime = UInt64($0.checkInTime.millisecondsSince1970)
            entry.checkOutTime = UInt64(checkOutTime.millisecondsSince1970)
            return entry
        }

        if let body = try? entries.serializedData() {
            let endpoint = backend.endpoint("debug/diaryEntries", method: .post, body: body)

            let task = URLSession.shared.dataTask(with: endpoint.request()) { [weak self] _, _, error in
                guard let strongSelf = self else { return }

                if let e = error {
                    DispatchQueue.main.async {
                        let errorModel = ErrorViewModel(title: "Fehler", text: e.localizedDescription, buttonText: "Ok")
                        let errorVC = ErrorViewController(errorModel: errorModel)
                        strongSelf.present(errorVC, animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        strongSelf.setFinishedMessage()
                    }
                }
            }

            task.resume()
        }
    }

    private func setFinishedMessage() {
        UIView.animate(withDuration: 0.25) {
            self.diaryViewController.view.alpha = 0
            self.thankyouMessage.alpha = 1
        }
        bottomButton.title = "Fertig"
        bottomButton.touchUpCallback = cancelButton.touchUpCallback
    }

    override func handleError(_: Error) {
        dismiss(animated: true)
    }
}

extension VenueInfo.VenueType {
    var diaryEntryVenueType: DiaryEntry.VenueType {
        switch self {
        case .other: return .other
        case .meetingRoom: return .meetingRoom
        case .cafeteria: return .cafeteria
        case .privateEvent: return .privateEvent
        case .canteen: return .canteen
        case .library: return .library
        case .lectureRoom: return .lectureRoom
        case .shop: return .shop
        case .gym: return .gym
        case .kitchenArea: return .kitchenArea
        case .officeSpace: return .officeSpace
        }
    }
}
