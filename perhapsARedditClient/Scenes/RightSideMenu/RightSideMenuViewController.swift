//
//  RightSideMenuViewController.swift
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

protocol RightSideMenuDisplayLogic: AnyObject {
    func backToStart()
    func dismiss()
}

final class RightSideMenuViewController: UIViewController {
    // MARK: - Clean Components
    
    private let interactor: RightSideMenuBusinessLogic
    private let router: RightSideMenuRoutingLogic & RightSideMenuDataPassing
    
    // MARK: - View

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var greetLabel: UILabel!
    @IBOutlet var signInLogOut: UIButton!
    
    // MARK: - Fields
    
    private var username: String? = nil
    
    // MARK: Object lifecycle
    
    init(interactor: RightSideMenuBusinessLogic, router: RightSideMenuRoutingLogic & RightSideMenuDataPassing) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        interactor.getprofpic(request: profile.getpic.Request())
        setup()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        var user = "Guest"
        if username != nil {
            user = username!
            signInLogOut.titleLabel?.text = "Change account"
        }
        greetLabel.text = "Hello \(user)!"

    }
    
    //MARK: - Actions
    
    @IBAction func signInButton(_ sender: Any) {
        backToStart()
    }
    @IBAction func tapOut(_ sender: Any) {
        dismiss()
    }
    @IBAction func swipeOut(_ sender: Any) {
        dismiss()
    }
    
}

// MARK: - CountriesDisplayLogic

extension RightSideMenuViewController: RightSideMenuDisplayLogic {

    func dismiss() {
        router.dismissSelf()
    }
    
    func backToStart() {
        router.backToStart()
    }
}