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

class BaseViewController: UIViewController {
    init()
    {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    public func addOval()
    {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.92, alpha: 1.0)
        self.view.insertSubview(view, at: 0)

        let size : CGFloat = 1188.0

        view.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.bottom).offset(-390)
            make.left.equalToSuperview().offset(-114)
            make.height.width.equalTo(size)
        }

        view.layer.cornerRadius = size * 0.5
    }
}
