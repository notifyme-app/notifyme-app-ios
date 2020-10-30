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

class CenterContentViewController : BaseViewController
{
    public var contentView : StackScrollView {
        return self.centerView.contentView
    }

    public var dismissCallback : (() -> ())?


    private let centerView = CenterContentView(maxHeight: 450)

    override init()
    {
        super.init()
        self.modalPresentationStyle = .overCurrentContext
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }

    // MARK: - Setup

    private func setup() {
        self.view.backgroundColor = UIColor.clear

        self.view.addSubview(self.centerView)

        self.centerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
         //  make.height.greaterThanOrEqualTo(150)
//            make.height.lessThanOrEqualTo(450)
            make.left.right.equalToSuperview().inset(Padding.medium)
        }

        self.centerView.dismissButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
            strongSelf.dismissCallback?()
        }
    }

    override func viewWillLayoutSubviews() {
        self.centerView.heightConstraint?.update(offset: self.centerView.contentView.scrollView.contentSize.height)
        super.viewWillLayoutSubviews()
    }
}
