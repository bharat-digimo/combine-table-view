//
//  ViewController.swift
//  CombineTableView
//
//  Created by Bharat Lal on 26/03/23.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!
    
    private let viewModel = RepositoryViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getRepositories()
        bindTableView()
    }
    
    func bindTableView() {
        viewModel.$repositories
            .sink(receiveValue: tableView.items{ (tableView, indexPath, model) in
                let cell = tableView.dequeueCell(with: RepoCell.self, for: indexPath)
                cell.configure(with: model)
                return cell
            }).store(in: &cancellables)
    }
}

