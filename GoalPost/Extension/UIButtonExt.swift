//
//  UIButtonExt.swift
//  GoalPost
//
//  Created by eferreira on 11/29/20.
//

import UIKit

extension UIButton {
    
    func setSelectedColor() {
        self.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.7490196078, blue: 0.4509803922, alpha: 1)
    }
    
    func setDeselectedColor() {
        self.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.7490196078, blue: 0.4509803922, alpha: 0.5)
    }
}
