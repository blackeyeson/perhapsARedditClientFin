//
//  LoginRouter.swift
//  perhapsARedditClient
//
//  Created by a on 03.09.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LoginRoutingLogic {
    func loginSuccessNavigateToMain(username: String?)
    func dismissSelf()
}

protocol LoginDataPassing { }

final class LoginRouter: LoginRoutingLogic, LoginDataPassing {
    // MARK: - Clean Components
    
    weak var viewController: LoginViewController?
    
    // MARK: - Routing
    
    func loginSuccessNavigateToMain(username: String?) {
        let destinationVC = MainScreenConfigurator.configure(username: username ?? "Guest")
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    func dismissSelf() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}