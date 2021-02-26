//
/*
 * Copyright (c) 2021 Ubique Innovation AG <https://www.ubique.ch>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * SPDX-License-Identifier: MPL-2.0
 */

import BackgroundTasks
import Foundation

@available(iOS 13.0, *)
class BackgroundTaskManager {
    static let refreshTaskIdentifier: String = "ch.notify-me.bgtask.refresh"
    static let processTaskIdentifier: String = "ch.notify-me.bgtask.process"

    static let shared = BackgroundTaskManager()

    private init() {}

    func setup() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Self.refreshTaskIdentifier, using: .main) { task in
            self.handleRefreshTask(task)
        }

        BGTaskScheduler.shared.register(forTaskWithIdentifier: Self.processTaskIdentifier, using: .main) { task in
            self.handleRefreshTask(task)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @objc private func appDidEnterBackground() {
        scheduleBackgroundTasks()
    }

    private func handleRefreshTask(_ task: BGTask) {
        #if DEBUG || RELEASE_DEV
            NotificationManager.shared.showDebugNotification(title: "[iOS >= 13 BGTask] Background fetch started", body: "Time: \(Date())")
        #endif
        scheduleBackgroundTasks()
        ProblematicEventsManager.shared.sync(isBackgroundFetch: true) { newData, needsNotification in
            #if DEBUG || RELEASE_DEV
                NotificationManager.shared.showDebugNotification(title: "[iOS >= 13 BGTask] Sync completed", body: "Time: \(Date()), newData: \(newData), needsNotification: \(needsNotification)")
            #endif
            if newData {
                if needsNotification {
                    NotificationManager.shared.showExposureNotification()
                }

                // data are updated -> reschedule background task warning triggers
                NotificationManager.shared.resetBackgroundTaskWarningTriggers()
            }

            task.setTaskCompleted(success: true)
        }
    }

    private func scheduleBackgroundTasks() {
        // Schedule next app refresh task 3h in the future
        let refreshRequest = BGAppRefreshTaskRequest(identifier: Self.refreshTaskIdentifier)
        refreshRequest.earliestBeginDate = Date(timeIntervalSinceNow: .hour * 3)

        do {
            try BGTaskScheduler.shared.submit(refreshRequest)
        } catch {
            print("Scheduling refresh task failed with error: \(error.localizedDescription)")
        }

        let taskRequest = BGProcessingTaskRequest(identifier: Self.processTaskIdentifier)
        taskRequest.requiresNetworkConnectivity = true
        do {
            try BGTaskScheduler.shared.submit(taskRequest)
        } catch {
            print("Scheduling process task failed with error: \(error.localizedDescription)")
        }
    }
}
