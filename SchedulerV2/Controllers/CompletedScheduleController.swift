//
//  CompletedScheduleController.swift
//  Scheduler
//
//  Created by Alex Paul on 1/18/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class CompletedScheduleController: UIViewController {
    
    private var completedEvents = [Event]() {
        didSet {
            guard let tableView = tableView else { return }
            tableView.reloadData()
        }
    }
    
    private let completedEventsPersistence = DataPersistence<Event>(filename: "completedEvents.plist")
    public var dataPersistence: DataPersistence<Event>! // saves to "schedules.plist"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadCompletedItems()
    }
    
    private func loadCompletedItems() {
        do {
            try completedEvents = completedEventsPersistence.loadItems()
        } catch {
            print("ERROR, could not load items: \(error)")
        }
    }
}

extension CompletedScheduleController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        let event = completedEvents[indexPath.row]
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = event.date.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // remove from data source
            completedEvents.remove(at: indexPath.row)
            
            // TODO: persist change
            do {
                try completedEventsPersistence.deleteItem(at: indexPath.row)
            } catch {
                print("Error deleting: \(error)")
            }
        }
    }
}

extension CompletedScheduleController: DataPersistenceDelegate {
    
    func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        
        // persist deleted item to completed events persistence
        do {
            let event = item as! Event
            try completedEventsPersistence.createItem(event)
        } catch {
            print("error creating item: \(error)")
        }
        
        // reload completed items array
        loadCompletedItems()
    }
}


