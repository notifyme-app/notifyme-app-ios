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

class DiaryCollectionView: UICollectionView {
    private let flowLayout: DiaryCollectionViewFlowLayout

    // MARK: - Init

    init() {
        flowLayout = DiaryCollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = UIColor.clear
        contentInset = UIEdgeInsets(top: 0.0, left: Padding.small, bottom: 0.0, right: Padding.small)

        register(DairyEntryCollectionViewCell.self)
        register(DairyDateSectionHeaderSupplementaryView.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)

        if let flowLayout = collectionViewLayout as? DiaryCollectionViewFlowLayout {
            let collectionViewContentWidth = superview?.bounds.width ?? 0.0

            flowLayout.estimatedItemSize = CGSize(width: collectionViewContentWidth - 2.0 * Padding.mediumSmall, height: 80)
            flowLayout.minimumInteritemSpacing = 0
        }
    }
}
