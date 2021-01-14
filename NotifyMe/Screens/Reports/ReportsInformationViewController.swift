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
    private let collectionView = DiaryCollectionView()

    private var exposure: [[Exposure]] = []
    private var error: ErrorViewModel?
    private var hasError: Bool {
        error != nil
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        UIStateManager.shared.addObserver(self) { [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.update(state)
        }
    }

    // MARK: - State update

    private func update(_ state: UIStateModel) {
        switch state.exposureState {
        case .noExposure:
            exposure = []
            collectionView.reloadData()
        case let .exposure(_, exposureByDay):
            exposure = exposureByDay
            collectionView.reloadData()
        }

        error = state.errorState.error
    }

    // MARK: - Setup

    private func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ReportInformationViewCollectionViewCell.self)
        collectionView.register(ErrorCollectionViewCell.self)

        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        collectionView.setup()
    }
}

extension ReportsInformationViewController: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in _: UICollectionView) -> Int {
        return exposure.count + 1
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
            let cell = ReportInformationViewCollectionViewCell().contentView
            let s = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
            let size = cell.systemLayoutSizeFitting(s, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultHigh)

            return CGSize(width: size.width, height: size.height)
        } else {
            return DiaryCollectionView.diaryCellSize(width: width, exposure: exposure(for: indexPath))
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        baseViewController?.scrollViewContentOffsetDelegate?.didUpdateContentOffset(s: scrollView.contentOffset)
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            let exposure = self.exposure(for: indexPath)
            present(ModalReportViewController(exposure: exposure), animated: true, completion: nil)
        }
    }

    func collectionView(_: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section > 0
    }
}

extension ReportsInformationViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? (hasError ? 2 : 1) : exposures(for: section).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if hasError, indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(for: indexPath) as ErrorCollectionViewCell
                cell.errorView.errorModel = error
                cell.errorView.errorCallback = handleError(_:)
                return cell
            }
            let cell = collectionView.dequeueReusableCell(for: indexPath) as ReportInformationViewCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath) as DiaryEntryCollectionViewCell
            cell.exposure = exposure(for: indexPath)

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Supplementary views other than section headers are not supported.")
        }

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as DiaryDateSectionHeaderSupplementaryView

        if indexPath.section > 0 {
            let d = exposures(for: indexPath.section).first?.exposureEvent.arrivalTime ?? Date()
            headerView.text = d.ns_daysAgo()
        }

        return headerView
    }

    private func exposure(for indexPath: IndexPath) -> Exposure {
        return exposures(for: indexPath.section)[indexPath.row]
    }

    private func exposures(for section: Int) -> [Exposure] {
        return exposure[section - 1]
    }
}
