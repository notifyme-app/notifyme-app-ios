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

class DiaryViewController: LocalAuthenticationViewController {
    let collectionView: DiaryCollectionView
    private let emptyView: DiaryEmptyView

    private var diary: [[CheckIn]] = []
    private var exposures: [Exposure] = []

    var customHeaderView: UIView? {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - Init

    init(bypassAuthentication: Bool = false) {
        collectionView = DiaryCollectionView()
        emptyView = DiaryEmptyView()

        super.init()

        self.bypassAuthentication = bypassAuthentication
        title = "diary_title".ub_localized
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        setup()

        super.viewDidLoad()
    }

    // MARK: - Collection View

    private func setup() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        setupCollectionView()

        view.addSubview(emptyView)

        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        setupEmptyView()
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.setup()

        collectionView.alpha = 0.0
    }

    private func setupEmptyView() {
        emptyView.alpha = 0.0
    }

    private func showDiary() {
        UIStateManager.shared.addObserver(self) { [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.update(state)
        }
    }

    private func update(_ state: UIStateModel) {
        diary = state.diaryState

        switch state.exposureState {
        case .exposure(exposure: let exposures, exposureByDay: _):
            self.exposures = exposures
        case .noExposure:
            exposures = []
        }

        emptyView.alpha = diary.count == 0 ? 1.0 : 0.0
        collectionView.alpha = (diary.count == 0) ? 0.0 : 1.0

        collectionView.reloadData()
    }

    override func handleSuccess() {
        showDiary()
    }

    override internal func handleError(_: Error) {
        navigationController?.popViewController(animated: true)
    }
}

extension DiaryViewController: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in _: UICollectionView) -> Int {
        return diary.count
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            let indexPath = IndexPath(item: 0, section: section)
            let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        } else {
            return CGSize(width: view.bounds.width, height: 56.0)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewContentOffsetDelegate?.didUpdateContentOffset(s: scrollView.contentOffset)
    }
}

extension DiaryViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diary[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as DiaryEntryCollectionViewCell

        let entry = diary[indexPath.section][indexPath.item]

        if let exposure = exposureForDiary(diaryEntry: entry) {
            cell.exposure = exposure
        } else {
            cell.checkIn = entry
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Supplementary views other than section headers are not supported.")
        }

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as DiaryDateSectionHeaderSupplementaryView
        headerView.date = diary[indexPath.section].first?.checkInTime

        if indexPath.section == 0 {
            headerView.customHeaderView = customHeaderView
        }

        return headerView
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width - 2.0 * Padding.mediumSmall

        let entry = diary[indexPath.section][indexPath.item]
        if let exposure = exposureForDiary(diaryEntry: entry) {
            return DiaryCollectionView.diaryCellSize(width: width, exposure: exposure)
        }

        return DiaryCollectionView.diaryCellSize(width: width, checkIn: entry)
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let d = diary[indexPath.section][indexPath.item]

        if let exposure = exposureForDiary(diaryEntry: d) {
            present(ModalReportViewController(exposure: exposure), animated: true, completion: nil)
        } else {
            present(CheckinEditViewController(checkIn: diary[indexPath.section][indexPath.item]), animated: true, completion: nil)
        }
    }

    private func exposureForDiary(diaryEntry: CheckIn) -> Exposure? {
        return exposures.first { (e) -> Bool in
            if let d = e.diaryEntry {
                return d.identifier == diaryEntry.identifier
            }

            return false
        }
    }
}
