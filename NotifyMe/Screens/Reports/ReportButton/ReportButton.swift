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

class ReportButton: UBButton {
    private static let buttonHeight: CGFloat = 72.0

    private let checkImageView = UIImageView()
    private let chevronImageView = UIImageView(image: UIImage(named: "icons-ic-chevron-right"))
    private let topTitleLabel = Label(.boldUppercase, numberOfLines: 1)

    private let messageLabel = Label(.heroTitle, textColor: .ns_text)
    private let subtextLabel = Label(.text)

    private let errorView = ErrorView()
    private let smallErrorView = SmallErrorView()

    private var heightConstraint: Constraint?
    private var bottomConstraint: Constraint?
    private var errorBottomConstraint: Constraint?
    private var smallErrorBottomConstraint: Constraint?

    var errorCallback: ((ErrorViewModel?) -> Void)? {
        get { errorView.errorCallback }
        set { errorView.errorCallback = newValue }
    }

    // MARK: - Init

    override init() {
        super.init()
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Content

    public func setContent(title: String, message: String? = nil, messageHighlight: String? = nil, subText: String? = nil, error: ErrorViewModel? = nil) {
        let hasMessage = message != nil

        let color = hasMessage ? UIColor.ns_red : UIColor.ns_green
        let checkImage = UIImage(named: "icons-ic-check-filled")?.ub_image(with: color)

        checkImageView.image = checkImage
        topTitleLabel.text = title
        topTitleLabel.textColor = color

        errorView.errorModel = error
        smallErrorView.errorModel = error

        if error != nil {
            if hasMessage { // Show only small error view
                errorView.isHidden = true
                smallErrorView.isHidden = false

                messageLabel.text = message
                if let m = messageHighlight {
                    messageLabel.addHighlight(text: m, color: color)
                }

                subtextLabel.text = subText

                heightConstraint?.deactivate()
                bottomConstraint?.deactivate()
                smallErrorBottomConstraint?.activate()
                errorBottomConstraint?.deactivate()
            } else {
                messageLabel.text = nil
                subtextLabel.text = nil
                errorView.isHidden = false
                smallErrorView.isHidden = true

                heightConstraint?.deactivate()
                bottomConstraint?.deactivate()
                smallErrorBottomConstraint?.deactivate()
                errorBottomConstraint?.activate()
            }

        } else {
            errorView.isHidden = true
            smallErrorView.isHidden = true
            errorBottomConstraint?.deactivate()
            smallErrorBottomConstraint?.deactivate()

            messageLabel.text = message
            if let m = messageHighlight {
                messageLabel.addHighlight(text: m, color: color)
            }

            subtextLabel.text = subText

            if hasMessage {
                heightConstraint?.deactivate()
                bottomConstraint?.activate()
            } else {
                heightConstraint?.activate()
                bottomConstraint?.deactivate()
            }
        }

        setNeedsLayout()
        layoutIfNeeded()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = UIColor.white
        highlightedBackgroundColor = .ns_genericTouchState
        checkImageView.ub_setContentPriorityRequired()
        chevronImageView.ub_setContentPriorityRequired()

        ub_addShadow(radius: 20.0, opacity: 0.17, xOffset: 0, yOffset: 2.0)
        layer.cornerRadius = ReportButton.buttonHeight * 0.5
        highlightCornerRadius = ReportButton.buttonHeight * 0.5

        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = Padding.small

        stackView.addArrangedView(checkImageView)
        stackView.addArrangedView(topTitleLabel)
        stackView.addArrangedView(chevronImageView)

        let view = UIView()
        addSubview(view)

        view.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(ReportButton.buttonHeight)
        }

        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(Padding.mediumSmall)
        }

        addSubview(messageLabel)

        messageLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Padding.mediumSmall)
            make.top.equalTo(stackView.snp.bottom).offset(Padding.large)
        }

        addSubview(subtextLabel)

        subtextLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Padding.mediumSmall)
            make.top.equalTo(self.messageLabel.snp.bottom).offset(Padding.mediumSmall)
            self.bottomConstraint = make.bottom.equalToSuperview().inset(Padding.large).constraint
        }

        addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(5)
            make.top.equalTo(stackView.snp.bottom).offset(Padding.medium)
            self.errorBottomConstraint = make.bottom.equalToSuperview().inset(5).constraint
        }

        snp.makeConstraints { make in
            self.heightConstraint = make.height.equalTo(ReportButton.buttonHeight).constraint
        }

        addSubview(smallErrorView)
        smallErrorView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(5)
            self.smallErrorBottomConstraint = make.bottom.equalToSuperview().inset(5).constraint
            make.top.equalTo(subtextLabel.snp.bottom).offset(5)
        }

        bottomConstraint?.deactivate()
        heightConstraint?.deactivate()
        errorBottomConstraint?.deactivate()
        smallErrorBottomConstraint?.deactivate()

        for v in subviews {
            if v is ErrorView {
                continue
            }
            v.isUserInteractionEnabled = false
        }
    }
}
