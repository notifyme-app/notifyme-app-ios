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

class DairyEntryCollectionViewCell : UICollectionViewCell
{
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.snp.makeConstraints { (make) in
            make.height.equalTo(80.0)
        }

        self.backgroundColor = UIColor.green
        self.layer.cornerRadius = 5.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
