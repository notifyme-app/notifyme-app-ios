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

protocol HitTestDelegate {
    func overrideHitTest(_ point: CGPoint, with event: UIEvent?) -> Bool
}

class StackScrollView: UIView {
    private let stackViewContainer = UIView()
    let stackView = UIStackView()
    let scrollView = UIScrollView()

    public var hitTestDelegate: HitTestDelegate?

    init(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0, stackViewHorizontalInset: CGFloat = 0) {
        super.init(frame: .zero)

        switch axis {
        case .vertical:
            scrollView.alwaysBounceVertical = true
            scrollView.showsVerticalScrollIndicator = false
        case .horizontal:
            scrollView.alwaysBounceHorizontal = true
            scrollView.showsHorizontalScrollIndicator = false
        @unknown default:
            break
        }

        // Add scrollView
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.ub_enableDefaultKeyboardObserver()

        // Add stackViewContainer and stackView
        scrollView.addSubview(stackViewContainer)
        stackViewContainer.snp.makeConstraints { make in
            make.edges.equalTo(self.scrollView)

            switch axis {
            case .vertical:
                make.width.equalTo(self.scrollView)
            case .horizontal:
                make.height.equalTo(self.scrollView)
            @unknown default:
                break
            }
        }

        stackView.axis = axis
        stackView.spacing = spacing
        stackViewContainer.addSubview(stackView)

        stackView.ub_setContentPriorityRequired()

        stackView.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(stackViewHorizontalInset)
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addArrangedView(_ view: UIView, height: CGFloat? = nil, index: Int? = nil) {
        if let h = height {
            view.snp.makeConstraints { make in
                make.height.equalTo(h)
            }
        }
        if let i = index {
            stackView.insertArrangedSubview(view, at: i)
        } else {
            stackView.addArrangedSubview(view)
        }
    }

    func addArrangedViewController(_ viewController: UIViewController, parent: UIViewController?, height: CGFloat? = nil, index: Int? = nil) {
        parent?.addChild(viewController)
        addArrangedView(viewController.view, height: height, index: index)
        viewController.didMove(toParent: parent)
    }

    func addSpacerView(_ height: CGFloat, color: UIColor? = nil) {
        let extraSpacer = UIView()
        extraSpacer.backgroundColor = color
        addArrangedView(extraSpacer, height: height)
    }

    func removeView(_ view: UIView) {
        stackView.removeArrangedSubview(view)
        view.removeFromSuperview()
    }

    func removeAllViews() {
        for v in stackView.arrangedSubviews {
            removeView(v)
        }
    }

    func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
        scrollView.scrollRectToVisible(rect, animated: animated)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if hitTestDelegate?.overrideHitTest(point, with: event) ?? false {
            return nil
        }

        return super.hitTest(point, with: event)
    }
}
