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

class CheckinEditViewController: BaseViewController {
    private let checkOutButton = BigButton(style: .normal, text: "checkout_button_title".ub_localized)

    public let dismissButton = TextButton(text: "done_button".ub_localized)
    public let contentView = StackScrollView()

    private let checkinLabel = Label(.boldUppercaseSmall, textColor: .ns_text, textAlignment: .center)
    private let venueView = VenueView(icon: false)
    private let startDateLabel = Label(.textBold, textAlignment: .center)

    private let fromTimePickerControl = TimePickerControl(text: "datepicker_from".ub_localized)
    private let toTimePickerControl = TimePickerControl(text: "datepicker_to".ub_localized)
    private let addCommentControl = AddCommentControl()

    private let diarySwitch = UISwitch()
    private let diarySubtextLabel = Label(.text)

    private let isCurrentCheckin: Bool

    private var checkIn: CheckIn? {
        didSet { self.update() }
    }

    // MARK: - Init

    override init() {
        isCurrentCheckin = true
        super.init()
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        UIStateManager.shared.addObserver(self) { [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.update(state)
        }

        setupCheckout()
        setupTimeInteraction()
        setupComment()
        setupSwitch()
    }

    // MARK: - Update

    private func update(_ state: UIStateModel) {
        if isCurrentCheckin {
            switch state.checkInState {
            case .noCheckIn:
                break
            case let .checkIn(checkIn):
                self.checkIn = checkIn
            }
        }
    }

    private func update() {
        venueView.venue = checkIn?.venue

        if let date = checkIn?.checkInTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d"
            startDateLabel.text = formatter.string(from: date)

            fromTimePickerControl.setDate(currentStart: date, currentEnd: Date(), isStart: true)
            toTimePickerControl.setDate(currentStart: date, currentEnd: Date(), isStart: false)
        }

        if let hidden = checkIn?.hideFromDiary {
            diarySwitch.isOn = hidden

            UIView.animate(withDuration: 0.2) {
                self.diarySubtextLabel.alpha = hidden ? 1.0 : 0.0
            }
        }
    }

    // MARK: - Setup

    private func setupCheckout() {
        dismissButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }

            if strongSelf.isCurrentCheckin {
                CurrentCheckinManager.shared.checkOut()

                let presentingVC = strongSelf.presentingViewController
                strongSelf.dismiss(animated: true) {
                    if let nvc = presentingVC as? UINavigationController {
                        nvc.popToRootViewController(animated: true)
                    } else {
                        presentingVC?.navigationController?.popToRootViewController(animated: true)
                    }
                }
            } else {
                strongSelf.dismiss(animated: true, completion: nil)
            }
        }
    }

    private func setupTimeInteraction() {
        fromTimePickerControl.timeChangedCallback = { [weak self] date in
            guard let strongSelf = self else { return }
            strongSelf.checkIn?.checkInTime = date

            if strongSelf.isCurrentCheckin {
                CurrentCheckinManager.shared.currentCheckin = strongSelf.checkIn
            }
        }

        toTimePickerControl.timeChangedCallback = { [weak self] date in
            guard let strongSelf = self else { return }
            strongSelf.checkIn?.checkOutTime = date

            if strongSelf.isCurrentCheckin {
                CurrentCheckinManager.shared.currentCheckin = strongSelf.checkIn
            }
        }
    }

    private func setupComment() {
        addCommentControl.commentChangedCallback = { [weak self] comment in
            guard let strongSelf = self else { return }

            strongSelf.checkIn?.comment = comment

            if strongSelf.isCurrentCheckin {
                CurrentCheckinManager.shared.currentCheckin = strongSelf.checkIn
            }
        }
    }

    private func setupSwitch() {
        diarySwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }

    @objc private func switchChanged() {
        checkIn?.hideFromDiary = diarySwitch.isOn

        if isCurrentCheckin {
            CurrentCheckinManager.shared.currentCheckin = checkIn
        }
    }

    // MARK: - Setup

    private func setup() {
        contentView.scrollView.ub_enableDefaultKeyboardObserver()

        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Padding.large + Padding.small)
            make.left.right.equalToSuperview().inset(Padding.large)
        }

        view.addSubview(dismissButton)

        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Padding.small)
            make.right.equalToSuperview().inset(Padding.mediumSmall)
        }

        contentView.addArrangedView(checkinLabel)
        checkinLabel.text = "edit_controller_your_checkin".ub_localized

        contentView.addSpacerView(Padding.mediumSmall)

        contentView.addArrangedView(venueView)

        contentView.addSpacerView(Padding.mediumSmall)

        contentView.addArrangedView(startDateLabel)

        contentView.addSpacerView(Padding.mediumSmall)

        let stackView = UIStackView(arrangedSubviews: [fromTimePickerControl, toTimePickerControl])
        stackView.axis = .horizontal
        stackView.spacing = Padding.small
        stackView.distribution = .fillEqually

        contentView.addArrangedView(stackView)

        contentView.addSpacerView(Padding.mediumSmall)
        contentView.addArrangedView(addCommentControl)

        let diaryLabel = Label(.boldUppercaseSmall, textColor: .ns_text)
        diaryLabel.text = "diary_option_title".ub_localized

        // diarySwitch.setContentHuggingPriority(.required, for: .horizontal)

//        let diaryStackView = UIStackView(arrangedSubviews: [diaryLabel, diarySwitch])
//        diaryStackView.axis = .horizontal
//        diaryStackView.alignment = .center
//        diaryStackView.spacing = Padding.small

        let v = UIView()
        v.addSubview(diaryLabel)
        v.addSubview(diarySwitch)
        diarySwitch.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(5.0)
        }

        diaryLabel.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.right.equalTo(diarySwitch.snp.left).offset(-Padding.small)
        }

        contentView.addSpacerView(Padding.mediumSmall)
        contentView.addArrangedView(v)

        contentView.addSpacerView(Padding.mediumSmall)

        contentView.addArrangedView(diarySubtextLabel)
        diarySubtextLabel.text = "diary_option_subtext".ub_localized
        diarySubtextLabel.alpha = 0
    }
}
