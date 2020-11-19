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

class ModalBaseViewController: BaseViewController {
    public let dismissButton = TextButton(text: "done_button".ub_localized)
    private let leftButton = TextButton(text: "".ub_localized, lightFont: true)
    private let titleLabel = Label(.boldUppercase, textColor: .ns_text)

    public let contentView: StackScrollView

    private let lineView = NavigationLineView()

    public var leftButtonTitle: String? {
        didSet { self.updateLeftButton() }
    }

    override public var title: String? {
        didSet { updateTitle() }
    }

    public var leftButtonTouchCallback: (() -> Void)?

    public let topBackgroundColor: UIColor

    // MARK: - Init

    init(horizontalContentInset: CGFloat = 0, backgroundColor: UIColor = .white) {
        topBackgroundColor = backgroundColor
        contentView = StackScrollView(stackViewHorizontalInset: horizontalContentInset)
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }

        view.backgroundColor = topBackgroundColor

        contentView.backgroundColor = .white
        contentView.scrollView.delegate = self
        contentView.scrollView.ub_enableDefaultKeyboardObserver()

        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Padding.large + 1.5 * Padding.small)
            make.bottom.left.right.equalToSuperview()
        }

        view.addSubview(dismissButton)

        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Padding.small)
            make.right.equalToSuperview().inset(Padding.mediumSmall)
        }

        view.addSubview(leftButton)

        leftButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Padding.small)
            make.left.equalToSuperview().inset(Padding.mediumSmall)
        }

        leftButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.leftButtonTouchCallback?()
        }

        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(dismissButton)
            make.left.greaterThanOrEqualTo(leftButton.snp.right).offset(Padding.small)
            make.right.lessThanOrEqualTo(self.dismissButton.snp.left).offset(-Padding.small)
        }

        dismissButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
        }

        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(contentView.snp.top)
        }
    }

    private func updateLeftButton() {
        leftButton.isHidden = true

        if let t = leftButtonTitle {
            leftButton.title = t
            leftButton.isHidden = false
        }
    }

    private func updateTitle() {
        titleLabel.text = title
    }
}

extension ModalBaseViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        lineView.updateColor(offset: scrollView.contentOffset.y)
    }
}
