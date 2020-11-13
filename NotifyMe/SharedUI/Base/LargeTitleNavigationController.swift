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
    private static let headerHeight = 92.0

    let contentViewController: BaseViewController
    private let titleLabel = Label(.title, numberOfLines: 1)
    private let lineView = UIView()

    private let contentView = UIView()

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
        setupLine()
    }

    private func setupHeader() {
        let background = UIView()
        background.backgroundColor = UIColor.white

        view.addSubview(background)

        background.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.top.left.right.equalToSuperview()
        }

        view.addSubview(contentView)

        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(background)
            make.height.equalTo(LargeTitleNavigationController.headerHeight)
        }

        let stackView = UIStackView()
        stackView.spacing = 6.0
        stackView.alignment = .center

        let imageView = UIImageView(image: UIImage(named: "icons-ic-chevron-back"))
        imageView.ub_setContentPriorityRequired()

        contentView.addSubview(stackView)
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
        button.highlightedBackgroundColor = .ns_genericTouchState

        contentView.insertSubview(button, at: 0)
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

    private func setupLine() {
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1.0)
            make.top.equalTo(self.contentView.snp.bottom).offset(-1)
        }
        lineView.backgroundColor = UIColor.clear
    }

    private func setupContent() {
        addChild(contentViewController)
        view.addSubview(contentViewController.view)

        contentViewController.view.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(self.contentView.snp.bottom)
        }

        contentViewController.didMove(toParent: self)
        contentViewController.scrollViewContentOffsetDelegate = self
    }
}

extension LargeTitleNavigationController: ScrollViewContentOffsetUpdateDelegate {
    func didUpdateContentOffset(s: CGPoint) {
        UIView.animate(withDuration: 0.15) {
            if s.y > 0 {
                if self.lineView.backgroundColor == .clear {
                    self.lineView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                    self.lineView.ub_addShadow(with: .black, radius: 3.0, opacity: 1.0, xOffset: 0.0, yOffset: 3.0)
                }
            } else {
                if self.lineView.backgroundColor != .clear {
                    self.lineView.backgroundColor = .clear
                    self.lineView.ub_addShadow(with: .black, radius: 2.0, opacity: 0.0, xOffset: 0.0, yOffset: 2.0)
                }
            }
        }
    }
}
