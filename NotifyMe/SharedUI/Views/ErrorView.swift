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

class ErrorView: UIView {
    private let iconView = UIImageView()
    private let titleLabel = Label(.boldUppercase, textColor: .ns_error, textAlignment: .center)
    private let textLabel = Label(.text, textAlignment: .center)
    private let button = TextButton(text: "", textColor: .ns_text, underlined: true)

    private let topPadding: CGFloat

    var errorCallback: ((ErrorViewModel?) -> Void)?

    var errorModel: ErrorViewModel? {
        didSet { update() }
    }

    init(errorModel: ErrorViewModel? = nil, topPadding: CGFloat = 0) {
        self.errorModel = errorModel
        self.topPadding = topPadding

        super.init(frame: .zero)

        setupView()
        update()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .ns_grayBackground
        layer.cornerRadius = 31

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Padding.small)
        }

        iconView.ub_setContentPriorityRequired()

        stackView.addSpacerView(topPadding)
        stackView.addArrangedSubview(iconView)
        stackView.addSpacerView(Padding.small)
        stackView.addArrangedSubview(titleLabel)
        stackView.addSpacerView(5)
        stackView.addArrangedSubview(textLabel)
        stackView.addSpacerView(Padding.mediumSmall)
        stackView.addArrangedSubview(button)

        button.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.didTapButton()
        }
    }

    @objc private func didTapButton() {
        errorCallback?(errorModel)
    }

    private func update() {
        iconView.image = errorModel?.icon ?? UIImage(named: "icons-ic-error")
        titleLabel.text = errorModel?.title
        textLabel.text = errorModel?.text
        button.title = errorModel?.buttonText
    }
}
