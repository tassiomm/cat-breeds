//
//  ViewController.swift
//  cat-breeds
//
//  Created by Developer on 17/09/24.
//

import UIKit
import Combine

class BreedsListingViewController: UIViewController {
    private let viewModel: BreedsListingViewModel

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BreedsCell.self, forCellReuseIdentifier: BreedsCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(refreshControl)
        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        return refresh
    }()

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: some BreedsListingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        tableView.dataSource = self
        tableView.delegate = self

        addSubviewsAndSetConstraints()
        registerObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.beginRefreshing()
        viewModel.refreshData()
    }

    private func addSubviewsAndSetConstraints() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func registerObservers() {
        viewModel.reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }.store(in: &cancellables)
    }

    @objc func refresh(_ sender: AnyObject) {
        self.viewModel.refreshData()
    }
}

// MARK: - DATA SOURCE AND DELEGATES

extension BreedsListingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.breeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BreedsCell.reuseIdentifier,
                                                       for: indexPath) as? BreedsCell else {
            return UITableViewCell()
        }
        let model = viewModel.breeds[indexPath.section]
        cell.populate(with: model)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let clearView = UIView()
        clearView.backgroundColor = .clear
        return clearView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
