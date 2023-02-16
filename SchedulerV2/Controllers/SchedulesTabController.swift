//
//  SchedulesTabController.swift
//  Scheduler
//
//  Created by Brendon Crowe on 2/15/23.
//  Copyright © 2023 Alex Paul. All rights reserved.
//

import UIKit

class SchedulesTabController: UITabBarController {
    
    private let dataPersistence = DataPersistence<Event>(filename: "schedules.plist")
    
    // get instances of the two tab controllers from storyboard
    
    private lazy var schedulesNavController: UINavigationController = {
        guard let navController = storyboard?.instantiateViewController(identifier: "SchedulesNavController") as? UINavigationController, let schedulesListController = navController.viewControllers.first as? ScheduleListController else {
            fatalError("Could not load nav controller")
        }
        // set dataPersistence property
        schedulesListController.dataPersistence = dataPersistence
        return navController
    }()
    
    // 1. get access to the UINavigationController
    // 2. get access to the first view controller down-casted to the desired controller
    private lazy var completedNavController: UINavigationController = {
        guard let navController = storyboard?.instantiateViewController(identifier: "CompletedNavController") as? UINavigationController, let recentlyCompletedController = navController.viewControllers.first as? CompletedScheduleController else {
            fatalError("Could not load nav controller")
        }
        // set dataPersistence property

        return navController
    }() // this closure allows for a custom initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        // viewControllers is a property in UITabBarController which is an array of the root view controllers displayed by the tab bar interface.
        
        viewControllers = [schedulesNavController, completedNavController]
    }


}
