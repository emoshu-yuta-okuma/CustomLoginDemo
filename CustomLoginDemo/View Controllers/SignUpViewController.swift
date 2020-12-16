//
//  SignUpViewController.swift
//  CustomLoginDemo
//
//  Created by Yuta Okuma on 2020/12/14.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
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
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    // Check the fields and validates that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message.（入力欄のチェックと入力されたデータが正しいかどうかを検証する。すべて正しければ、このメソッドはnilを返す。そうでない場合、エラーメッセージを返す。）
    func validateFields() -> String? {
        
        // Check that all fields are filled in（すべての入力欄が埋められているかどうかをチェックする）
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check if the password is secure（パスワードが安全かどうかをチェックする）
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            // Password isn't secure enough（パスワードが安全でない場合）
            return "Please make sure your password is at least 8 characters, contains a special character and a number"
        }
        
        return nil
    }

    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields（入力欄を検証）
        let error = validateFields()
        
        if error != nil {
            // There's something wrong with the fields, show error message（入力欄に何か間違いがあった場合、エラ〜メッセージを表示する。）
            showError(error!)
        } else {
            
            // Create cleaned versions of data（正常なデータを作成する）
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user（ユーザーを作成）
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors（エラーをチェックする）
                if err != nil {
                    // There was an error creating the user（ユーザー作成時にエラーが発生した場合）
                    self.showError("Error creating user")
                } else {
                    // User was created successfully, now store the first name and last name（ユーザー作成が成功し、ファーストネームとラストネームが保存される。）
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname": firstName, "lastname": lastName, "uid": result!.user.uid]) { (error) in
                        
                        if error != nil {
                            
                            // Show error message（エラ〜メッセージを表示する）
                            self.showError("Error saving user data")
                        }
                    }
                    
                    // Transition to the home screen（ホーム画面へと遷移する）
                    self.transitionToHome()
                }
            }
        }
    }
    
    func showError(_ message: String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
