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
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var aspectImage: NSLayoutConstraint!
    
    lazy var textFields: [UITextField] = [emailTextField, passwordTextField]
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(didTap(_:)))
        return gesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(tapGesture)
        setUpUI()
        registerForKeyboardNotifcations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifcations()
    } /// this can also be done in deinit

    
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
        loginButton.layer.cornerRadius = AppRoundedViews.cornerRadius
        
        let _ = textFields.map { $0.addShadowToTextField(cornerRadius: 3)}
    }
    
    @objc private func didTap(_ gesture: UITapGestureRecognizer ) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    private func registerForKeyboardNotifcations() {
        // singleton:
        // add ourselevs as observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterForKeyboardNotifcations() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        imageViewWidthConstraint.constant = -100
        
        UIView.animate(withDuration: 5.0) { // FIX: no matter what duration i add it doesnt change how it happens? 
            self.view.layoutIfNeeded()
        }
    }

    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        
        imageViewWidthConstraint.constant = 0
        
        UIView.animate(withDuration: 5.0) {
            self.view.layoutIfNeeded()
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
