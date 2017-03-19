//
//  LoadVC.swift
//  Hubble
//
//  Created by Matt Monaco on 3/18/17.
//  Copyright © 2017 MonApp. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoadVC: UIViewController {

    @IBOutlet weak var hubbleImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        self.hubbleImage.startRotating()
        self.isUserSignedIn()
        
    }
    
    /**
       Function checks if user is signed in the keychain
         - if signed in, downloads user info
         - if not signed in, segues to sign in page
     */
    func isUserSignedIn(){
        
        if let userID = KeychainWrapper.standard.string(forKey: KEY_UID) { //checks if the user is in keychain
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute:{ //user is not signed in, waits 2 seconds
                // Put your code which should be executed with a delay here
                print("MATT: user is signed in: \(userID)\n")
                self.performSegue(withIdentifier: userSignedSegue, sender: nil)
            })
            
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute:{ //user is not signed in, waits 2 seconds
                // Put your code which should be executed with a delay here
                print("MATT: user needs to sign in\n")
                self.performSegue(withIdentifier: userNeedsToSignInSegue, sender: nil)
            })
            
        }
    }

}
