//
//  FBLoginButtonHelper.swift
//  NMFBLogin
//
//  Created by Nikunj Munjiyasara on 20/12/18.
//  Copyright © 2018 Codeappz. All rights reserved.
//

import Foundation
import UIKit

let kFacebookLoginButtonBackgroundColor = UIColor(displayP3Red: 59/255, green: 89/255, blue: 153/255, alpha: 1)
let kFacebookLoginButtonTintColor = UIColor.white
let kFacebookLoginButtonCornerRadius: CGFloat = 13.0

class FBLoginBtnHelper: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    private func configureUI() {
        self.backgroundColor = kFacebookLoginButtonBackgroundColor
        self.layer.cornerRadius = kFacebookLoginButtonCornerRadius
        self.tintColor = kFacebookLoginButtonTintColor
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
}
