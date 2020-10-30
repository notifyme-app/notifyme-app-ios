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

import UIKit

extension UICollectionReusableView: ReusableView {}

// MARK: - Registering and Reusing Cells

extension UICollectionView
{
    func register<T: UICollectionViewCell>(_ cellType: T.Type)
    {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T
    {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }
}


// MARK: - Registering and Reusing Supplementary Views

extension UICollectionView
{
    func register<T: UICollectionReusableView>(_ viewType: T.Type, forSupplementaryViewOfKind elementKind: String)
    {
        self.register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, for indexPath: IndexPath) -> T
    {
        guard let view = self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue supplementary view with identifier: \(T.reuseIdentifier)")
        }
        return view
    }
}

// MARK: - Registering and Reusing Decoration Views

extension UICollectionViewLayout
{
    func register<T: UICollectionReusableView>(_ viewType: T.Type)
    {
        self.register(T.self, forDecorationViewOfKind: T.reuseIdentifier)
    }
}

extension UICollectionViewLayoutAttributes
{
    convenience init<T: UICollectionReusableView>(forDecorationViewOfType viewType: T.Type, with indexPath: IndexPath)
    {
        self.init(forDecorationViewOfKind: T.reuseIdentifier, with: indexPath)
    }
}
