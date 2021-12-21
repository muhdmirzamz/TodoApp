//
//  InputViewController.swift
//  TodoApp
//
//  Created by Muhd Mirza on 13/7/20.
//  Copyright © 2020 Muhd Mirza. All rights reserved.
//

import UIKit

import FirebaseDatabase
import FirebaseAuth


class InputListViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(InputListViewController.hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        self.textfield.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }

    
    @IBAction func addItem() {
        if let text = self.textfield.text {
            
            let ref = Database.database().reference()
            
            guard let userID = Auth.auth().currentUser?.uid else {
                return
            }
            
            guard let key = ref.child("/lists/\(userID)").childByAutoId().key else {
                return
            }
            
            let dateString = self.getStringForDateToday()
            
            let listDict: [String : Any] = [
                "listName": text,
                "timestamp": dateString
            ]
            
            ref.child("/lists/\(userID)/\(key)").setValue(listDict)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getStringForDateToday() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sss'Z'"

        return dateFormatter.string(from: Date())
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
