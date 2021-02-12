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

class OnboardingUsageNotesViewController: OnboardingStepViewController {
    private let imageView = UIImageView(image: UIImage(named: "onboarding-usage"))
    private let titleLabel = Label(.title, textAlignment: .center)

    private let usageNotesStackview = UIStackView()
    private let infoStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        let isSmall = view.frame.size.width <= 375
        let isUltraSmall = view.frame.size.width <= 320

        button.title = "ok_button".ub_localized

        let stackView = StackScrollView(axis: .vertical, spacing: 0, stackViewHorizontalInset: Padding.mediumSmall)

        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(isSmall ? (isUltraSmall ? 60.0 : 80.0) : 134.0)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.button.snp.top).offset(-Padding.large)
        }

        stackView.scrollView.alwaysBounceVertical = false

        // image view
        if !isUltraSmall {
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedView(imageView)
        }

        // title label
        let v = UIView()
        v.addSubview(titleLabel)

        let topInset = isSmall ? (isUltraSmall ? 0.0 : 2.0 * Padding.mediumSmall) : (2.0 * Padding.mediumSmall + Padding.medium)

        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Padding.mediumSmall)
            make.top.equalToSuperview().inset(topInset)
            make.bottom.equalToSuperview()
        }

        stackView.addArrangedView(v)

        titleLabel.text = "onboarding_hints_for_usage".ub_localized
        titleLabel.addHighlight(text: "onboarding_hints_for_usage_highlight".ub_localized, color: .ns_purple)

        setupStackViews()

        stackView.addSpacerView(2.0 * Padding.medium)

//        stackView.addArrangedView(usageNotesStackview)
//        stackView.addSpacerView(Padding.medium)

        stackView.addArrangedView(infoStackView)
    }

    private func setupStackViews() {
        let errorImageView = UIImageView(image: UIImage(named: "onboarding-error"))
        errorImageView.ub_setContentPriorityRequired()

        // Usage notes
        let label = Label(.text, textColor: .ns_red)
        label.text = "onboarding_hint1".ub_localized

        usageNotesStackview.alignment = .top
        usageNotesStackview.spacing = Padding.small
        usageNotesStackview.addArrangedView(errorImageView)
        usageNotesStackview.addArrangedView(label)

        // Info / AGB
        let infoImageView = UIImageView(image: UIImage(named: "icons-ic-info-outline")?.ub_image(with: .ns_purple))
        infoImageView.ub_setContentPriorityRequired()

        let agbLabel = Label(.text)
        agbLabel.text = "onboarding_hint2".ub_localized

        let externalLink = ExternalLinkButton()
        externalLink.title = "onboarding_agb_link_title".ub_localized
        externalLink.touchUpCallback = {
            if let url = URL(string: "onboarding_agb_link".ub_localized) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }

        let linkContainer = UIView()
        linkContainer.addSubview(externalLink)
        externalLink.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Padding.small)
            make.left.bottom.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }

        let v = UIStackView()
        v.axis = .vertical
        v.addArrangedView(agbLabel)
        v.addArrangedView(linkContainer)

        infoStackView.alignment = .top
        infoStackView.spacing = Padding.small
        infoStackView.addArrangedView(infoImageView)
        infoStackView.addArrangedView(v)
    }

    // MARK: - Ordered views

    override var viewsInTopOrder: [UIView] {
        get { return [imageView, titleLabel, button, usageNotesStackview, infoStackView] }
        set { super.viewsInTopOrder = newValue }
    }
}
