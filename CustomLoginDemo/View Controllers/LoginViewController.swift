//
//  LoginViewController.swift
//  CustomLoginDemo
//
//  Created by Yuta Okuma on 2020/12/14.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    // Check the fields and validates that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message.（入力欄のチェックと入力されたデータが正しいかどうかを検証する。すべて正しければ、このメソッドはnilを返す。そうでない場合、エラーメッセージを返す。）
    func validateFields() -> String? {
        
        // Check that all fields are filled in（すべての入力欄が埋められているかどうかをチェックする）
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
        }
        
        // Check if the password is secure（パスワードが安全かどうかをチェックする）
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            // Password isn't secure enough（パスワードが安全でない場合）
            return "Please maek sure your password is at least 8 characters, contains a special character and a number"
        }
        
        return nil
    }

    @IBAction func loginTapped(_ sender: Any) {
        
        // Validate Text Fields（入力欄を検証する）
        let error = validateFields()
        
        if error != nil {
            // There's something wrong with the fields, show error message（入力欄に何か間違いがあった場合、エラ〜メッセージを表示する。）
            showError(error!)
        } else {
            
            // Create cleaned versions of data（正常なデータを作成する）
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Sigining in the user（ユーザーのサインイン）
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    
                    // Couldn't sign in（サインインできない場合）
                    self.errorLabel.text = err!.localizedDescription
                    self.errorLabel.alpha = 1
                }
                else {
                    
                    let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                    
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
                    
                }
            }
        }
    }
    
    func showError(_ message: String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}
