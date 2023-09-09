//
//  Extention.swift
//  Tracker
//
//  Created by Александр Пичугин on 05.09.2023.
//

import UIKit

extension UITextField {
    func indent(_ size:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}
