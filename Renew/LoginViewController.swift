//
//  LoginViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 8/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    lazy var textFields: [UITextField] = [emailTextField, passwordTextField]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        styleAllTextFields()
        setUpUI()

    }
    
    /// logic to control the reappearance of the walkthrough screen -> should only display when user displays app for the very first time
    /// check user defaults "hasViewedWalkthrough" key to deternine if we should show again.
    /// FIX: since this is user a servier we also want to save it remote
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        
        let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
        
        if let walkthroughViewController = storyboard.instantiateViewController(identifier: "WalkthroughViewController") as? WalkthroughViewController {
            walkthroughViewController.modalPresentationStyle = .fullScreen
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }
    
    private func setUpUI() {
        // corner radius
        loginButton.layer.cornerRadius = AppRoundedViews.cornerRadius
        // add shadow to text feilds
        emailTextField.addShadowToTextField( cornerRadius: 3)
        passwordTextField.addShadowToTextField( cornerRadius: 3)
    }
    
   
    
//    private func styleAllTextFields() {
//        let _ = textFields.map { $0.styleTextField()}
//    }
    
    private func createDatabaseUser(authDataResult: AuthDataResult) {
        DatabaseService.shared.createDatabaseUser(authDataResult: authDataResult) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Account error", message: error.localizedDescription)
            case .success:
                DispatchQueue.main.async {
                 UIViewController.showViewController(storyBoardName: "MainView", viewControllerId: "MainTabController")
                }
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
            else {
                showAlert(title: "Missing fields", message: "Check email & password input.")
                return
        }
        
        AuthenticationSession.shared.createNewUser(email: email, password: password) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error signing up", message: "\(error.localizedDescription)")
            case .success(let authDataResult):
                // navigate to main app view
                self?.createDatabaseUser(authDataResult: authDataResult)
            }
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
       guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
            else {
                showAlert(title: "Missing fields", message: "Check email & password input.")
                return
        }
        
        AuthenticationSession.shared.signExisitingUser(email: email, password: password) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error loging in", message: "\(error.localizedDescription)")
            case .success:
                UIViewController.showViewController(storyBoardName: "MainView", viewControllerId: "MainTabController")
            }
        }
    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        UIViewController.showViewController(storyBoardName: "MainView", viewControllerId: "MainTabController")
    }
}
