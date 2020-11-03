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

class LargeTitleNavigationController: UIViewController {
    private static let headerHeight = 136.0

    let contentViewController: BaseViewController
    private let titleLabel = Label(.title, numberOfLines: 1)

    init(contentViewController: BaseViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)

        self.contentViewController.titleChangeCallback = { [weak self] title in
            guard let strongSelf = self else { return }
            strongSelf.titleLabel.text = title
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupContent()
    }

    private func setupHeader() {
        let background = UIView()
        background.backgroundColor = UIColor.white

        view.addSubview(background)

        background.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(LargeTitleNavigationController.headerHeight)
        }

        let stackView = UIStackView()
        stackView.spacing = 6.0
        stackView.alignment = .center

        let imageView = UIImageView(image: UIImage(named: "icons-ic-chevron-back"))
        imageView.ub_setContentPriorityRequired()

        background.addSubview(stackView)
        stackView.addArrangedView(imageView)
        stackView.addArrangedView(titleLabel)

        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20.0)
            make.bottom.equalToSuperview().inset(30.0)
        }

        stackView.isUserInteractionEnabled = false

        let button = UBButton()
        button.layer.cornerRadius = 22.0
        button.backgroundColor = .clear
        button.highlightedBackgroundColor = .lightGray

        background.insertSubview(button, at: 0)
        button.snp.makeConstraints { make in
            make.centerX.equalTo(imageView).offset(-5.0)
            make.centerY.equalTo(imageView)
            make.height.width.equalTo(44.0)
        }

        button.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.popViewController(animated: true)
        }
    }

    private func setupContent() {
        addChild(contentViewController)
        view.addSubview(contentViewController.view)

        contentViewController.view.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(LargeTitleNavigationController.headerHeight)
        }

        contentViewController.didMove(toParent: self)
    }
}
