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

class HomescreenViewController : BaseViewController
{
    private let stackScrollView = StackScrollView(axis: .vertical)

    private let reportViewController = HomescreenReportViewController()

    private let checkInButton = BigButton(text: "checkin_button_title".ub_localized)
    private let diaryButton = BigButton(icon: nil)

    // MARK: - Init

    override init()
    {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        self.addOval()
        self.setupLayout()
        self.setupButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Setup

    private func setupLayout()
    {
        self.view.addSubview(self.stackScrollView)
        self.stackScrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.stackScrollView.addArrangedViewController(self.reportViewController, parent: self)

        // Bottom buttons
        let stackView = UIStackView(arrangedSubviews: [self.checkInButton, self.diaryButton])
        stackView.spacing = Padding.small
        self.view.addSubview(stackView)

        stackView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp_bottomMargin).inset(Padding.medium)
            make.left.right.equalToSuperview().inset(Padding.medium)
        }
    }

    private func setupButtons()
    {
        self.diaryButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.pushViewController(DiaryViewController(), animated: true)
        }

        self.checkInButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.pushViewController(CheckInViewController(), animated: true)
        }

        self.reportViewController.reportsTouchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.pushViewController(ReportsViewController(), animated: true)
        }
    }
}
