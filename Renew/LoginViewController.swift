//
//  LoginViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 8/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: FloatingLabelInput!
    @IBOutlet weak var passwordTextField: FloatingLabelInput!
    lazy var textFields: [FloatingLabelInput] = [emailTextField, passwordTextField]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleAllTextFields()

    }
    
    private func styleAllTextFields() {
        let _ = textFields.map { $0.styleTextField()}
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
            else {
                print("invalid input for email or password")
                return
        }
        
        AuthenticationSession.shared.createNewUser(email: email, password: password) { (result) in
            switch result {
            case .failure(let error):
                print("failure to create new user -  \(error)")
            case .success:
                // navigate to main app view
                UIViewController.showViewController(storyBoardName: "MainView", viewControllerId: "MainTabController")
            }
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
    }
    
}
