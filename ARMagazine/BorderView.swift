//
//  BorderView.swift
//  ARMagazine
//
//  Created by Jake Sijing Lin on 8/31/18.
//  Copyright © 2018 code & co. All rights reserved.
//

import UIKit

@IBDesignable class BorderView : UIView {
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
