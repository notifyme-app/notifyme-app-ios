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

class OnboardingTitleViewController: OnboardingStepViewController {
    private let imageView = UIImageView()
    private let titleLabel = Label(.heroTitle, textAlignment: .center)
    private let textLabel = Label(.text, textAlignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        let isSmall = view.frame.size.width <= 375
        let isUltraSmall = view.frame.size.width <= 320

        button.title = "onboarding_continue_button".ub_localized

        let stackView = StackScrollView(axis: .vertical, spacing: 0, stackViewHorizontalInset: Padding.medium - Padding.small)

        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(isSmall ? 80 : 134.0)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.button.snp.top).offset(-Padding.large)
        }

        stackView.scrollView.alwaysBounceVertical = false

        // image view
        imageView.contentMode = .scaleAspectFit
        let s = isSmall ? (isUltraSmall ? 0.7 : 0.8) : 1.0
        imageView.image = UIImage(named: "onboarding-title")?.ub_image(byScaling: CGFloat(s))
        stackView.addArrangedView(imageView)

        // title label
        let v = UIView()
        v.addSubview(titleLabel)

        let topInset = isSmall ? (2.0 * Padding.mediumSmall) : (2.0 * Padding.mediumSmall + Padding.medium)

        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Padding.mediumSmall)
            make.top.equalToSuperview().inset(topInset)
            make.bottom.equalToSuperview()
        }

        stackView.addArrangedView(v)

        titleLabel.text = "app_name".ub_localized
        titleLabel.addHighlight(text: "app_name_highlight".ub_localized, color: .ns_purple)

        // text
        let v2 = UIView()
        v2.addSubview(textLabel)

        textLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Padding.medium)
            make.top.equalToSuperview().inset(Padding.small + 5.0)
            make.bottom.equalToSuperview()
        }

        stackView.addArrangedView(v2)

        textLabel.lineBreakMode = .byWordWrapping
        textLabel.text = "onboarding_subtitle".ub_localized
    }

    override var viewsInTopOrder: [UIView] {
        get { return [imageView, titleLabel, textLabel, button] }
        set { super.viewsInTopOrder = newValue }
    }
}
