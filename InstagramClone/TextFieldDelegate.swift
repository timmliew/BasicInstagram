//
//  TextFieldDelegate.swift
//  InstagramClone
//
//  Created by Timothy Liew on 3/15/18.
//  Copyright © 2018 Tim Liew. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}
