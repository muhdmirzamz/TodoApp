//
//  SigninViewController.swift
//  TodoApp
//
//  Created by Muhd Mirza on 7/2/21.
//  Copyright © 2021 Muhd Mirza. All rights reserved.
//

import UIKit

import FirebaseAuth

class SigninViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapToHideKeyboard = UITapGestureRecognizer.init(target: self, action: #selector(SigninViewController.hideKeyboard))
        self.view.addGestureRecognizer(tapToHideKeyboard)
        
        self.emailTextfield.delegate = self
        self.passwordTextfield.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    // @objc tag when we use #selector
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }

    @IBAction func signin() {
        
        guard let email = self.emailTextfield.text else {
            return
        }
        
        guard let password = self.passwordTextfield.text else {
            return
        }
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let result = result {
                print(result.user.uid)
                print(result.user.email!)
                
                DispatchQueue.main.async {
                    let navController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "NavigationController") as? UINavigationController
                    navController?.modalPresentationStyle = .fullScreen
                    
                    self.present(navController!, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
