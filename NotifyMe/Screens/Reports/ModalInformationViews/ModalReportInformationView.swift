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

class ModalReportInformationView: UIView {
    private let timeTitleLabel = Label(.boldUppercaseSmall, textColor: .ns_text)
    private let whereTitleLabel = Label(.boldUppercaseSmall, textColor: .ns_text)
    private let notesTitleLabel = Label(.boldUppercaseSmall, textColor: .ns_text)

    private let timeImageTextView = ImageTextView()
    private let whereImageTextView = ImageTextView()
    private let notesLabel = Label(.text)

    private let exposure: Exposure

    // MARK: - Init

    init(exposure: Exposure) {
        self.exposure = exposure
        super.init(frame: .zero)
        setup()
        setupContent()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = UIColor.ns_grayBackground
        layer.cornerRadius = 8.0

        let stackView = UIStackView()
        stackView.axis = .vertical

        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: Padding.medium, left: Padding.small * 1.5, bottom: Padding.medium, right: Padding.small * 1.5))
        }

        stackView.addArrangedView(timeTitleLabel)
        addEmptyView(stackView: stackView, height: 6.0)
        stackView.addArrangedView(timeImageTextView)
        addEmptyView(stackView: stackView, height: Padding.mediumSmall)

        stackView.addArrangedView(whereTitleLabel)
        addEmptyView(stackView: stackView, height: 6.0)
        stackView.addArrangedView(whereImageTextView)
        addEmptyView(stackView: stackView, height: Padding.mediumSmall)

        stackView.addArrangedView(notesTitleLabel)
        addEmptyView(stackView: stackView, height: 5.0)
        stackView.addArrangedView(notesLabel)
    }

    private func addEmptyView(stackView: UIStackView, height: CGFloat) {
        let v = UIView()
        stackView.addArrangedView(v)
        v.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }

    private func setupContent() {
        timeTitleLabel.text = exposure.exposureEvent.arrivalTime.ns_daysAgo()
        whereTitleLabel.text = "new_exposure_location_header".ub_localized
        notesTitleLabel.text = "new_exposure_notes_header".ub_localized

        // set time
        timeImageTextView.image = UIImage(named: "illus-calendar")

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"

        timeImageTextView.title = formatter.string(from: exposure.exposureEvent.arrivalTime)

        formatter.dateFormat = "HH:mm"

        let checkInTime = exposure.diaryEntry?.checkInTime ?? exposure.exposureEvent.arrivalTime
        let checkOutTime = exposure.diaryEntry?.checkOutTime ?? exposure.exposureEvent.departureTime

        timeImageTextView.text = [checkInTime, checkOutTime].map { formatter.string(from: $0) }.joined(separator: " – ")

        // set Notes
        notesLabel.text = exposure.diaryEntry?.comment ?? "-"

        // set Where

        whereImageTextView.title = exposure.diaryEntry?.venue.description
        whereImageTextView.text = exposure.diaryEntry?.venue.subtitle
        whereImageTextView.image = exposure.diaryEntry?.venue.image(large: false)
    }
}
