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

class CenterContentViewController: BaseViewController {
    public var contentView: StackScrollView {
        return centerView.contentView
    }

    public var dismissCallback: (() -> Void)?

    public var hasDismissButton: Bool = true {
        didSet { centerView.dismissButton.isHidden = !hasDismissButton }
    }

    private let centerView = CenterContentView(maxHeight: 450)

    override init() {
        super.init()
        modalPresentationStyle = .overCurrentContext
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.15) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIView.animate(withDuration: 0.15) {
            self.view.backgroundColor = UIColor.clear
        }
    }

    // MARK: - Setup

    private func setup() {
        view.backgroundColor = UIColor.clear

        view.addSubview(centerView)

        centerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(Padding.medium)
        }

        centerView.dismissButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
            strongSelf.dismissCallback?()
        }
    }

    override func viewWillLayoutSubviews() {
        centerView.heightConstraint?.update(offset: centerView.contentView.scrollView.contentSize.height)
        super.viewWillLayoutSubviews()
    }
}
