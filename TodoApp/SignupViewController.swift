//
//  SignupViewController.swift
//  TodoApp
//
//  Created by Muhd Mirza on 17/4/21.
//  Copyright © 2021 Muhd Mirza. All rights reserved.
//

import UIKit

import FirebaseAuth

class SignupViewController: UIViewController {

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signup() {
        
        guard let email = self.emailTextfield.text else {
            return
        }
        
        guard let password = self.passwordTextfield.text else {
            return
        }
        

        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let result = result {
                print(result.user.uid)
                print(result.user.email!)
                
                let alert = UIAlertController.init(title: "Great!", message: "Sign up successful", preferredStyle: .alert)
                let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
                    DispatchQueue.main.async {
                        let navController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "NavigationController") as? UINavigationController
                        navController?.modalPresentationStyle = .fullScreen
                        
                        // set the signup welcome message trigger
                        let listTableViewController = navController?.children[0] as? ListTableViewController
                        listTableViewController?.uponSuccessfulSignup = true
                        
                        self.present(navController!, animated: true, completion: nil)
                    }
                }
                
                alert.addAction(okAction)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
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
