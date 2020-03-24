//
//  EventsViewController.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 24.03.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import UIKit
import Bond

final class EventsViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: EventsListViewModelProtocol = EventsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()

        
        searchBar.reactive.text.bind(to: viewModel.searchString)
        viewModel.events.bind(to: tableView, cellType: SearchResultTableViewCell.self) { (cell, viewModel) in
            cell.configure(with: viewModel)
        }
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: SearchResultTableViewCell.reuseIdentifier, bundle: nil),
                                forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = SearchResultTableViewCell.rowHeight
        tableView.accessibilityIdentifier = "EventsTableView"
    }

}
