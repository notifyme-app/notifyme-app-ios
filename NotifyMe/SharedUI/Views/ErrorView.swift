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

struct ErrorViewModel {
    let title: String
    let text: String
    let buttonText: String
    let icon: UIImage?

    init(title: String, text: String, buttonText: String, icon: UIImage? = nil) {
        self.title = title
        self.text = text
        self.buttonText = buttonText
        self.icon = icon
    }
}

class ErrorView: UIView {
    private let iconView = UIImageView()
    private let titleLabel = Label(.boldUppercase, textColor: .ns_error, textAlignment: .center)
    private let textLabel = Label(.text, textAlignment: .center)
    private let button = TextButton(text: "", textColor: .ns_text, underlined: true)

    var touchUpCallback: (() -> Void)? {
        get { button.touchUpCallback }
        set { button.touchUpCallback = newValue }
    }

    var errorModel: ErrorViewModel? {
        didSet { update() }
    }

    init(errorModel: ErrorViewModel? = nil) {
        self.errorModel = errorModel

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

        stackView.addArrangedSubview(iconView)
        stackView.addSpacerView(Padding.small)
        stackView.addArrangedSubview(titleLabel)
        stackView.addSpacerView(5)
        stackView.addArrangedSubview(textLabel)
        stackView.addSpacerView(Padding.mediumSmall)
        stackView.addArrangedSubview(button)
    }

    private func update() {
        iconView.image = errorModel?.icon ?? UIImage(named: "icons-ic-error")
        titleLabel.text = errorModel?.title
        textLabel.text = errorModel?.text
        button.title = errorModel?.buttonText
    }
}
