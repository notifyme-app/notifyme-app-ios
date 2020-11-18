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

class HomescreenViewController: BaseViewController {
    private let stackScrollView = StackScrollView(axis: .vertical)

    private let reportViewController = HomescreenReportViewController()

    private let checkInButton = CheckInButton()
    private let diaryButton = BigButton(icon: UIImage(named: "icons-ic-diary"))
    private let nonProductiveLabel = Label(.boldUppercaseSmall, textColor: .ns_red)

    private let personImageView = UIImageView()

    private let refreshControl = UIRefreshControl()

    // MARK: - Init

    override init() {
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupButtons()
        setupPersonView()
        addOval()

        UIStateManager.shared.addObserver(self) { [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.update(state)
        }

        startRefresh()
    }

    // MARK: - Update

    private func update(_ state: UIStateModel) {
        personImageView.isHidden = state.exposureState != .noExposure
    }

    // MARK: - Setup

    @objc private func startRefresh() {
        ProblematicEventsManager.shared.sync { [weak self] _, _ in
            guard let strongSelf = self else { return }
            strongSelf.refreshControl.endRefreshing()
        }
    }

    private func setupLayout() {
        view.addSubview(stackScrollView)
        stackScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackScrollView.scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(startRefresh), for: .valueChanged)

        stackScrollView.addSpacerView(Padding.small)

        stackScrollView.addArrangedViewController(reportViewController, parent: self)

        // Bottom buttons
        let stackView = UIStackView(arrangedSubviews: [checkInButton, diaryButton])
        stackView.spacing = Padding.small
        stackView.alignment = .bottom
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.snp_bottomMargin).inset(Padding.medium)
            make.left.right.equalToSuperview().inset(Padding.medium)
        }

        view.addSubview(nonProductiveLabel)
        nonProductiveLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Padding.mediumSmall + Padding.medium)
            make.bottom.equalTo(stackView.snp.top).offset(-1.5 * Padding.small)
        }

        nonProductiveLabel.text = "non_productive_warning".ub_localized
    }

    private func setupButtons() {
        diaryButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            let vc = LargeTitleNavigationController(contentViewController: DiaryViewController())
            strongSelf.navigationController?.pushViewController(vc, animated: true)
        }

        checkInButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            let vc = LargeTitleNavigationController(contentViewController: CheckInViewController())
            strongSelf.navigationController?.pushViewController(vc, animated: true)
        }

        reportViewController.reportsTouchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            let vc = LargeTitleNavigationController(contentViewController: ReportsViewController())
            strongSelf.navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func setupPersonView() {
        let small = view.bounds.size.width <= 375

        if view.bounds.size.width > 320 {
            personImageView.image = UIImage(named: "person")?.ub_image(byScaling: small ? 0.65 : 0.95)
        }

        view.insertSubview(personImageView, at: 0)

        let padding = small ? Padding.medium : 2.0 * Padding.medium

        personImageView.snp.makeConstraints { make in
            make.bottom.greaterThanOrEqualTo(nonProductiveLabel.snp.top).offset(-padding).priority(.medium)
            make.right.equalToSuperview().inset(Padding.medium + 8.0)
        }
    }
}
