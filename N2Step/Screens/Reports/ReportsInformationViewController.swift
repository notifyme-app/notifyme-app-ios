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

class ReportsInformationViewController: BaseSubViewController {
    private let stackScrollView = StackScrollView(axis: .vertical, spacing: 0)

//    private let reportInformationView = ReportInformationView(title: "report_information_title".ub_localized, text: "report_information_text".ub_localized, color: .ns_red, buttonTitle: "report_information_button_title".ub_localized)

    private let collectionView = DiaryCollectionView()

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ReportInformationViewCollectionViewCell.self)

        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        collectionView.setup()
    }
}

extension ReportsInformationViewController: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in _: UICollectionView) -> Int {
        // TODO: set real values
        return 3
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
        }

        return CGSize(width: view.bounds.width, height: 56.0)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width - 2.0 * Padding.mediumSmall

        if indexPath.section == 0 {
            // TODO: this could be better
            let cell = ReportInformationViewCollectionViewCell().contentView
            let s = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
            let size = cell.systemLayoutSizeFitting(s, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)

            return CGSize(width: size.width, height: size.height)
        } else {
            return CGSize(width: width, height: 200.0)
        }
    }
}

extension ReportsInformationViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: set real values
        return section == 0 ? 1 : 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath) as ReportInformationViewCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath) as DiaryEntryCollectionViewCell
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Supplementary views other than section headers are not supported.")
        }

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as DiaryDateSectionHeaderSupplementaryView
        // TODO: set real values

        return headerView
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            present(PotentialInfectionWhatToDoViewController(), animated: true, completion: nil)
        } else {
            // TODO: set checkin...
            present(CheckinEditViewController(checkIn: nil
            ), animated: true, completion: nil)
        }
    }
}
