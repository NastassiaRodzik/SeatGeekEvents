//
//  EventsListViewController.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/25/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Bond
import ReactiveKit

final class EventsListViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: EventsListViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: EventsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()

        searchBar.delegate = self
        searchBar.reactive.text
            .bind(to: viewModel.searchString)
            .dispose(in: disposeBag)
        viewModel.events
            .bind(to: tableView, cellType: SearchResultTableViewCell.self) { (cell, viewModel) in
            cell.configure(with: viewModel)
        }
        .dispose(in: disposeBag)
        
        tableView.reactive.selectedRowIndexPath
            .bind(to: viewModel.selectedIndexPath)
            .dispose(in: disposeBag)
        
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: SearchResultTableViewCell.reuseIdentifier, bundle: nil),
                                forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier)
        tableView.rowHeight = SearchResultTableViewCell.rowHeight
        tableView.accessibilityIdentifier = "EventsTableView"
        tableView.delegate = self
    }

}

// MARK - UITableViewDelegate
extension EventsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalEventsNumber = viewModel.events.count
        let prefetchRowsNumber = 3
        if indexPath.row > totalEventsNumber - prefetchRowsNumber {
            viewModel.loadNewPage()
        }
    }
    
}

// MARK: - UISearchBarDelegate
extension EventsListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        viewModel.searchString.value = nil
        searchBar.resignFirstResponder()
    }
}