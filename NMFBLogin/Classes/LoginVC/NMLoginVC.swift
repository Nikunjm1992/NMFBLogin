//
//  NMLoginVC.swift
//  NMFBLogin
//
//  Created by Nikunj Munjiyasara on 20/12/18.
//  Copyright © 2018 Codeappz. All rights reserved.
//

import UIKit

import FacebookCore
import FacebookLogin


class NMLoginVC: UIViewController {
    
    // Facebook login permissions
    // Add extra permissions you need
    // Remove permissions you don't need
    private let readPermissions: [ReadPermission] = [ .publicProfile, .email, .userFriends, .custom("user_posts") ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickBtn_FaceboolLogin(_ sender: FBLoginBtnHelper) {
        // Facebook login attempt
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: readPermissions, viewController: self, completion: didReceiveFacebookLoginResult)
    }
    private func didReceiveFacebookLoginResult(loginResult: LoginResult) {
        switch loginResult {
        case .success:
            didLoginWithFacebook()
        case .failed(_): break
        default: break
        }
    }
    
    private func didLoginWithFacebook() {
        // Successful log in with Facebook
        if let accessToken = AccessToken.current {
            let facebookAPIManager = FBHelper(accessToken: accessToken)
            facebookAPIManager.requestFacebookUser(completion: { (facebookUser) in
                if let _ = facebookUser.email {
                    let info = "First name: \(facebookUser.firstName!) \n Last name: \(facebookUser.lastName!) \n Email: \(facebookUser.email!)"
                    self.didLogin(method: "Facebook", info: info)
                }
            })
        }
    }
    
    private func didLogin(method: String, info: String) {
        let message = "Successfully logged in with \(method). " + info
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
