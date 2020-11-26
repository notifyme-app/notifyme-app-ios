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

class OnboardingViewController: BaseViewController {
    private let offset: CGFloat = 160.0
    private let animationDuration: TimeInterval = 0.3

    private let titleViewController = OnboardingTitleViewController()
    private let usageNotesViewController = OnboardingUsageNotesViewController()

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
        view.backgroundColor = .white
        setup()
    }

    // MARK: - Setup

    private func setup() {
        // add
        addStep(titleViewController)
        addStep(usageNotesViewController)

        moveSubviews(from: usageNotesViewController, offset: offset, alpha: 0.0, animated: false)
        moveSubviews(from: titleViewController, offset: 0.0, alpha: 1.0, animated: false)

        usageNotesViewController.view.isUserInteractionEnabled = false

        titleViewController.buttonTouchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            let o = strongSelf.offset
            strongSelf.usageNotesViewController.view.isUserInteractionEnabled = true

            strongSelf.moveSubviews(from: strongSelf.titleViewController, offset: -o, alpha: 0.0, animated: true)
            strongSelf.moveSubviews(from: strongSelf.usageNotesViewController, offset: 0, alpha: 1.0, animated: true)
        }

        usageNotesViewController.buttonTouchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            let o = strongSelf.offset
            strongSelf.moveSubviews(from: strongSelf.usageNotesViewController, offset: -o, alpha: 0.0, animated: true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2 * strongSelf.animationDuration) {
                strongSelf.dismiss(animated: true, completion: nil)
                UserStorage.shared.hasCompletedOnboarding = true
            }
        }
    }

    private func addStep(_ stepViewController: OnboardingStepViewController) {
        addChild(stepViewController)
        view.addSubview(stepViewController.view)

        stepViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stepViewController.didMove(toParent: self)

        for v in stepViewController.viewsInTopOrder {
            v.alpha = 0.0
        }
    }

    private func moveSubviews(from stepViewController: OnboardingStepViewController, offset: CGFloat, alpha: CGFloat, animated: Bool) {
        for (i, v) in stepViewController.viewsInTopOrder.enumerated() {
            if animated {
                UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut, .beginFromCurrentState]) {
                    v.alpha = alpha
                } completion: { _ in }

                UIView.animate(withDuration: 2.0 * animationDuration, delay: Double(i) * 0.05, usingSpringWithDamping: 0.75, initialSpringVelocity: 1.1, options: [.curveEaseInOut, .beginFromCurrentState]) {
                    v.transform = CGAffineTransform(translationX: offset, y: 0.0)
                } completion: { _ in }
            } else {
                v.alpha = alpha
                v.transform = CGAffineTransform(translationX: offset, y: 0.0)
            }
        }
    }
}
