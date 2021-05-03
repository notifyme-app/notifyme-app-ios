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
import SnapKit
import UIKit

struct LargeTitleNavigationControllerCustomTitle {
    let image: UIImage?
    let color: UIColor
    let title: String
}

class LargeTitleNavigationController: UIViewController {
    private static let headerHeight = 92.0

    let contentViewController: BaseViewController
    private let titleLabel = Label(.title, numberOfLines: 1, textAlignment: .center)
    private let lineView = NavigationLineView()

    private let contentView = UIView()

    private let customTitleView = CustomTitleView()

    init(contentViewController: BaseViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)

        self.contentViewController.titleChangeCallback = { [weak self] title in
            guard let strongSelf = self else { return }
            strongSelf.customTitleView.alpha = 0.0
            strongSelf.titleLabel.alpha = 1.0
            strongSelf.titleLabel.text = title
        }

        self.contentViewController.customTitleChangeCallback = { [weak self] customTitle in
            guard let strongSelf = self else { return }
            strongSelf.titleLabel.alpha = 0.0
            strongSelf.customTitleView.alpha = 1.0
            strongSelf.customTitleView.customTitle = customTitle
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
        background.backgroundColor = .white

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

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(stackView)
            make.centerX.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(6)
        }

        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20.0)
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

        contentView.addSubview(customTitleView)

        customTitleView.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(titleLabel)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(titleLabel)
            make.height.equalTo(50.0)
        }
    }

    private func setupLine() {
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.contentView.snp.bottom).offset(-1)
        }
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
        lineView.updateColor(offset: s.y)
    }
}

private class CustomTitleView: UIView {
    private let imageView = UIImageView()
    private let label = Label(.boldUppercase)

    var customTitle: LargeTitleNavigationControllerCustomTitle? {
        didSet { update() }
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = 10

        imageView.ub_setContentPriorityRequired()
        label.ub_setContentPriorityRequired()

        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.centerX.top.bottom.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }

        stackView.addArrangedView(imageView)
        stackView.addArrangedView(label)
    }

    // MARK: - Update

    private func update() {
        guard let ct = customTitle else { return }

        label.text = ct.title
        label.textColor = ct.color
        imageView.isHidden = ct.image == nil
        imageView.image = ct.image?.ub_image(with: ct.color)
    }
}
