//
//  BreedsCell.swift
//  cat-breeds
//
//  Created by Developer on 18/09/24.
//

import UIKit

final class BreedsCell: UITableViewCell {
    static let reuseIdentifier = "TopSalesTableViewCell"

    private lazy var breedImage: AsyncImageView = {
        let image = AsyncImageView(frame: .init(origin: .zero, size: .init(width: 80, height: 110)))
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
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
        self.layer.cornerRadius = 12

        addSubviewsAndConstraints()
    }

    private func addSubviewsAndConstraints() {
        contentView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            breedImage.widthAnchor.constraint(equalToConstant: 80),
            breedImage.heightAnchor.constraint(equalToConstant: 110)
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
        if let url = URL(string: breed.image) {
            breedImage.load(url: url)
        }
    }
}
