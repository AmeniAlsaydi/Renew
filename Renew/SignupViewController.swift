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
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var subheading: UILabel!
    
    @IBOutlet weak var signUpLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var headingTopConstraint: NSLayoutConstraint!
    
    private var keyboardVisible: Bool = false
    private var originialSignUpConstraint: NSLayoutConstraint!
    private var originialHeadingConstraint: NSLayoutConstraint!
    
    lazy var textFields: [UITextField] = [emailTextField, passwordTextField, confirmPasswordTextField]

    override func viewDidLoad() {
        super.viewDidLoad()
        originialHeadingConstraint = headingTopConstraint
        originialSignUpConstraint = signUpLabelTopConstraint
        setUpUI()
        registerForKeyboardNotifcations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifcations()
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
    
    private func registerForKeyboardNotifcations() {
        // singleton:
        // add ourselevs as observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandle(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandle(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    private func unregisterForKeyboardNotifcations() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc
    private func keyboardHandle(_ notification: NSNotification) {
        // this needs to be animated
        keyboardVisible = !keyboardVisible
        
        if keyboardVisible {
            heading.isHidden = true
            subheading.isHidden = true
            headingTopConstraint.constant = 0
            signUpLabelTopConstraint.constant = 0
            
        } else {
            heading.isHidden = false
            subheading.isHidden = false
            headingTopConstraint.constant = originialHeadingConstraint.constant
            signUpLabelTopConstraint.constant = originialSignUpConstraint.constant
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
    
    private func keyboardHandling() {
        heading.isHidden = true
        subheading.isHidden = true
        headingTopConstraint.constant = 0
        signUpLabelTopConstraint.constant = 0
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
