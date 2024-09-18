//
//  ViewController.swift
//  cat-breeds
//
//  Created by Developer on 17/09/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let service = FetchBreedsServiceImpl()

        service.execute()
            .sink { error in
                print("..")
            } receiveValue: { breeds in
                print(breeds)
            }.store(in: &cancellables)
    }


}

