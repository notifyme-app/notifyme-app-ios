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

import CrowdNotifierSDK
import Foundation

class HomescreenViewController: BaseViewController {
    private let backgroundView = UIView()
    private let contentBackgroundView = UIView()
    private let terminationView = HomescreenTerminationView()

    private let stackScrollView = StackScrollView(axis: .vertical)

    private let reportViewController = HomescreenReportViewController()
    private let headerView = HomescreenHeaderView()

    private let checkInButton = CheckInButton()
    private let diaryButton = BigButton(icon: UIImage(named: "icons-ic-diary"))
    private let nonProductiveLabel = Label(.boldUppercaseSmall, textColor: .ns_red)

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
        addOval()
        setupTerminationView()
        startRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showCheckInIfNeeded()
    }

    // MARK: - Setup

    @objc private func startRefresh() {
        ProblematicEventsManager.shared.sync { [weak self] _, _ in
            guard let strongSelf = self else { return }
            strongSelf.refreshControl.endRefreshing()
        }
    }

    private func setupLayout() {
        backgroundView.backgroundColor = .ns_red
        contentBackgroundView.backgroundColor = .white
        contentBackgroundView.ub_roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 36.0)

        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(contentBackgroundView)
        contentBackgroundView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
        }

        view.addSubview(stackScrollView)
        stackScrollView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.edges.equalToSuperview()
            } else {
                make.top.equalToSuperview().inset(Padding.medium)
                make.bottom.left.right.equalToSuperview()
            }
        }

        stackScrollView.scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(startRefresh), for: .valueChanged)

        stackScrollView.addArrangedView(terminationView)
        stackScrollView.addArrangedView(headerView)

        contentBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.top)
        }

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

        #if DEBUG || RELEASE_DEV
            nonProductiveLabel.text = "non_productive_warning".ub_localized
        #endif
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

        headerView.infoButtonPressed = { [weak self] in
            guard let strongSelf = self else { return }
            let vc = WebViewController(mode: .local("impressum"))
            strongSelf.present(vc, animated: true, completion: nil)
        }
    }

    private func setupTerminationView() {
        terminationView.buttonTouchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.presentTerminationPopup()
        }
    }

    private func presentTerminationPopup() {
        let vc = TerminationPopupViewController()
        vc.moreInfoCallback = {
            guard let url = URL(string: "app_termination_detail_url".ub_localized) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        present(vc, animated: true, completion: nil)
    }

    // MARK: - Check-In via AppClip

    private func showCheckInIfNeeded() {
        let bi = (Bundle.main.bundleIdentifier ?? "")
        let defaults = UserDefaults(suiteName: "group." + bi)

        // url from appclip must be set and onboarding completed
        guard let urlString = defaults?.value(forKey: Environment.shareURLKey) as? String,
              UserStorage.shared.hasCompletedOnboarding else {
            return
        }

        switch UIStateManager.shared.uiState.checkInState {
        case .checkIn:
            break
        case .noCheckIn:
            // Try checkin
            let result = CrowdNotifier.getVenueInfo(qrCode: urlString, baseUrl: Environment.current.qrGenBaseUrl)

            switch result {
            case let .success(info):
                let vc = CheckInConfirmViewController(qrCode: urlString, venueInfo: info)
                present(vc, animated: true, completion: nil)
            case let .failure(failure):
                let vc = ErrorViewController(errorModel: failure.errorViewModel)
                present(vc, animated: true, completion: nil)
            }
        }

        defaults?.removeObject(forKey: Environment.shareURLKey)
    }
}
