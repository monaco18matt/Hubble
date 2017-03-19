//
//  LoginVC.swift
//  Hubble
//
//  Created by Matt Monaco on 3/18/17.
//  Copyright © 2017 MonApp. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: fieldShadow!
    @IBOutlet weak var passwordField: fieldShadow!
    @IBOutlet weak var loginImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loginImage.alpha = 0.5
    }
    
    /**
     Fucntion dismisses the keyboard when user taps the screen and changes login button alpha if fields have data
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if self.emailField.text != "" && self.passwordField.text != "" {
            self.loginImage.alpha = 0.9
        }
    }
    
    /**
     Helper function for touchesBegan
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func loginTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        if let email = self.emailField.text, let pwd = self.passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if (error != nil) {
                    // an error occurred while attempting login
                    if let errCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                        print("MATT: Firebase error: \(error!)")
                        switch errCode {
                        case .errorCodeEmailAlreadyInUse:
                            self.sendAlert(title: "Email in use", message: "This email is in use. Please try a different email.")
                            break
                        case .errorCodeInvalidEmail:
                            self.sendAlert(title: "Invalid Email", message: "The email entered in not valid. Please try again.")
                            break
                        case .errorCodeWrongPassword:
                            self.sendAlert(title: "Wrong Password", message: "The password entered does not match the email address provided")
                            break
                        case .errorCodeUserNotFound:
                            self.sendAlert(title: "User does not exist", message: "The information provided does not match any user information on our servers.")
                            break
                        default:
                            self.sendAlert(title: "Something went wrong", message: "Please try again later")
                        }
                    }
                }else {
                    // no error occurred (ie: user exists)
                    print("MATT: User email authenticated with Firebase, signing in...\n")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        UserDefaults.standard.set(email, forKey: "email")
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                }
            })
        }
    }
    
    /**
      Fucntion completes the sign in process
        - if user already exisits in Firebase, download their info and sign them in
        - else, create user data and redirect them to the usernameVC
     
        @param id = id of the user
        @param userData = data of the user
        @param id = id of the user
     
     */
    func completeSignIn(id: String, userData: Dictionary<String, String>){
        //create/update user in Firebase and store uid in keychain
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
        performSegue(withIdentifier: userLoginSegue, sender: nil)
    }
    
    
    /**
     * Sends an alert to the user when an error occurs
     * Displays alert with title and message
     */
    func sendAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
