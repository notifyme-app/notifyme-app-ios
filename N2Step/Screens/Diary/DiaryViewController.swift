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
import LocalAuthentication

class DiaryViewController : BaseViewController
{
    private let flowLayout : DiaryCollectionViewFlowLayout
    private let collectionView : UICollectionView

    // MARK: - Init

    override init()
    {
        self.flowLayout = DiaryCollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)

        super.init()
        self.title = "diary_title".ub_localized
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        authenticate()
    }

    // MARK: - Collection View

    private func setup()
    {
        self.view.addSubview(self.collectionView)

        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.setupCollectionView()
    }

    private func setupCollectionView()
    {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.contentInset = UIEdgeInsets(top: 0.0, left: Padding.small, bottom: 0.0, right: Padding.small)
        self.collectionView.alpha = 0.0

        self.collectionView.register(DairyEntryCollectionViewCell.self)
        self.collectionView.register(DairyDateSectionHeaderSupplementaryView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)

        if let flowLayout = self.collectionView.collectionViewLayout as? DiaryCollectionViewFlowLayout {
            let collectionViewContentWidth = self.view.bounds.width

            flowLayout.estimatedItemSize = CGSize(width: collectionViewContentWidth - 2.0 * Padding.small, height: 80)
            flowLayout.minimumInteritemSpacing = 0
        }
    }


    // MARK: - Authentication

    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "face_id_reason_text".ub_localized) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.showDiary()
                    } else {
                        if let err = authenticationError
                        {
                            self.handleError(err)
                        }
                        else
                        {
                            self.showDiary()
                        }
                    }
                }
            }
        }
        else
        {
            // no biometrics
            self.showDiary()
        }
    }

    private func showDiary()
    {
        // TODO: show diary
        self.collectionView.alpha = 1.0
    }

    private func handleError(_ error : Error)
    {
        // TODO: handle error
        let alert = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}

extension DiaryViewController : UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 40.0)
    }
}

extension DiaryViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as DairyEntryCollectionViewCell

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Supplementary views other than section headers are not supported.")
        }

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as DairyDateSectionHeaderSupplementaryView

        return headerView
    }
}
