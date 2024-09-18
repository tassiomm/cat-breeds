//
//  AppDelegate.swift
//  cat-breeds
//
//  Created by Developer on 17/09/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)
        /*
         MARK: Um incremento dessa função poderia ser criar um coordinator
         para gerenciar a rotas/direção de cada view.
         */
        let viewController = BreedsListingViewController(viewModel: BreedsListingViewModelImpl())
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}

