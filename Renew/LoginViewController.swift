//
//  LoginViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 8/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var logInTextField: FloatingLabelInput!
    @IBOutlet weak var passwordTextField: FloatingLabelInput!
    lazy var textFields: [FloatingLabelInput] = [logInTextField, passwordTextField]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleAllTextFields()

    }
    
    private func styleAllTextFields() {
        let _ = textFields.map { $0.styleTextField()}
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
    }
    
}
