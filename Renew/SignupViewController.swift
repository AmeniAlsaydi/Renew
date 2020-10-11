//
//  SignupViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 10/10/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    lazy var textFields: [UITextField] = [emailTextField, passwordTextField, confirmPasswordTextField]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        
        let _ = textFields.map { $0.addShadowToTextField(cornerRadius: 3)}
        
        signUpButton.layer.cornerRadius = AppRoundedViews.cornerRadius
    }
    
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
            !password.isEmpty,
            let confirmedPassword = confirmPasswordTextField.text,
            !confirmedPassword.isEmpty
            else {
                showAlert(title: "Missing fields", message: "Check email & password input.")
                return
        }
        
        guard password == confirmedPassword else {
            showAlert(title: nil , message: "Passwords don't match.")
            return
        }
        
        AuthenticationSession.shared.createNewUser(email: email, password: password) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error Signing Up", message: "\(error.localizedDescription)")
            case .success(let authDataResult):
                // navigate to main app view
                self?.createDatabaseUser(authDataResult: authDataResult)
            }
        }
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
