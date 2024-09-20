//
//  AsyncImageView.swift
//  cat-breeds
//
//  Created by Developer on 18/09/24.
//

import UIKit

class AsyncImageView: UIImageView {
    private lazy var imageLoadingView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.style = .medium
        loadingView.layer.zPosition = .infinity
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    // Initialize with storyboard or XIB
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImageView()
    }

    private func setupImageView() {
        addSubview(imageLoadingView)
        NSLayoutConstraint.activate([
            imageLoadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageLoadingView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - HANDLE LOADING OF IMAGE IN BACKGROUND
    func load(url: URL) {
        image = nil
        imageLoadingView.startAnimating()
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        self?.imageLoadingView.stopAnimating()
                    }
                }
            }
        }
    }
}
