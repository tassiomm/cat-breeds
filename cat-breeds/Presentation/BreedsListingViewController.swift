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

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BreedsCell.self, forCellReuseIdentifier: BreedsCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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

        addSubviewAndSetConstraints()
        registerObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    private func addSubviewAndSetConstraints() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
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
            }.store(in: &cancellables)
    }
}

// MARK: - DELEGATES

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


// MARK: - CELL

class BreedsCell: UITableViewCell {
    static let reuseIdentifier = "TopSalesTableViewCell"

    private lazy var breedImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var title: UILabel = {
        var title = UILabel()
        title.numberOfLines = 2
        return title
    }()

    private lazy var contentStackView: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [breedImage, title])
        stack.spacing = 20
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.lightGray
        addSubviewsAndConstraints()
    }

    private func addSubviewsAndConstraints() {
        contentView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            breedImage.widthAnchor.constraint(equalToConstant: 50),
            breedImage.heightAnchor.constraint(equalToConstant: 100)
        ])

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ])
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func populate(with breed: BreedModel) {
        title.text = breed.name
    }
}
