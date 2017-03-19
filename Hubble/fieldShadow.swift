//
//  fieldShadow.swift
//  Hubble
//
//  Created by Matt Monaco on 3/18/17.
//  Copyright © 2017 MonApp. All rights reserved.
//

import UIKit

class fieldShadow: UITextField {
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(displayP3Red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
        
    }
        
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
        
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }

}
