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

class AddCommentControl: UIView {
    private let label = Label(.boldUppercaseSmall, textColor: .ns_text)
    private let textField = UITextField()

    public var commentChangedCallback: ((String) -> Void)?

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        label.text = "edit_mode_addcomment".ub_localized
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - API

    public func setComment(text: String?) {
        textField.text = text
    }

    // MARK: - Setup

    private func setup() {
        let v = UIView()
        v.backgroundColor = UIColor.ns_grayBackground
        v.layer.cornerRadius = 3.0
        addSubview(v)

        let stackView = UIStackView(arrangedSubviews: [label, v])
        stackView.axis = .vertical
        stackView.spacing = 5.0
        stackView.distribution = .fill

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        v.addSubview(textField)
        textField.font = LabelType.text.font
        textField.placeholder = "edit_mode_comment_placeholder".ub_localized

        textField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.bottom.greaterThanOrEqualToSuperview()
            make.left.right.equalToSuperview().inset(Padding.small)
            make.height.equalTo(50.0)
        }

        textField.delegate = self
        textField.returnKeyType = .done
    }
}

extension AddCommentControl: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        commentChangedCallback?(textField.text ?? "")
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentChangedCallback?(textField.text ?? "")
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        commentChangedCallback?(txtAfterUpdate)
        return true
    }
}
