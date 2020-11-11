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

@objc protocol ScrollViewContentOffsetUpdateDelegate {
    func didUpdateContentOffset(s: CGPoint)
}

class BaseViewController: UIViewController {
    // MARK: - Init

    weak var scrollViewContentOffsetDelegate: ScrollViewContentOffsetUpdateDelegate?

    public static var instanceCount = 0

    deinit {
        NotificationCenter.default.removeObserver(self)
        BaseViewController.instanceCount -= 1
        dprint("'\(self.classForCoder)' has been removed, there are now \(BaseViewController.instanceCount).")
    }

    // MARK: - Initialization

    init() {
        super.init(nibName: nil, bundle: nil)

        BaseViewController.instanceCount += 1
        dprint("'\(classForCoder)' has been added, there are now \(BaseViewController.instanceCount).")
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // we don't hide the navigation completely, in that way
        // left swipe is still there
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Title

    public var titleChangeCallback: ((String?) -> Void)? {
        didSet {
            self.titleChangeCallback?(self.title)
        }
    }

    override var title: String? {
        get { super.title }
        set {
            super.title = newValue
            titleChangeCallback?(title)
        }
    }

    // MARK: - Fancy oval

    public func addOval() {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.92, alpha: 1.0)
        self.view.insertSubview(view, at: 0)

        let size: CGFloat = 1188.0

        view.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.bottom).offset(-390)
            make.left.equalToSuperview().offset(-114)
            make.height.width.equalTo(size)
        }

        view.layer.cornerRadius = size * 0.5
    }

    // MARK: - add subviewcontroller

    public func addSubviewController(vc: BaseSubViewController) {
        addChild(vc)
        view.addSubview(vc.view)

        vc.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        vc.didMove(toParent: self)
        vc.baseViewController = self
    }
}
