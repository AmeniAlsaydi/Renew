//
//  GuestPromptViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 10/13/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class GuestPromptViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

    }
    
    private func updateUI() {
        signUpButton.layer.cornerRadius = AppRoundedViews.cornerRadius
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "LoginView", bundle: nil)
        
        guard let signUpVC = storyboard.instantiateViewController(identifier: "SignupViewController") as? SignupViewController else {
            fatalError("Cant get sign up VC")
        }
        
        present(signUpVC, animated: true)
        
    }

    @IBAction func logInPressed(_ sender: UIButton) {
        
    }
    

}
