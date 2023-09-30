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

extension UIViewController {
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

//extension CALayer {
//    func addGradienBorder(colors:[UIColor],width:CGFloat = 1) {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame =  CGRect(origin: CGPointZero, size: self.bounds.size)
//        gradientLayer.startPoint = CGPointMake(0.0, 0.5)
//        gradientLayer.endPoint = CGPointMake(1.0, 0.5)
//        gradientLayer.colors = colors.map({$0.cgColor})
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.lineWidth = width
//        shapeLayer.path = UIBezierPath(rect: self.bounds).cgPath
//        shapeLayer.fillColor = nil
//        shapeLayer.strokeColor = UIColor.black.cgColor
//        gradientLayer.mask = shapeLayer
//
//        self.addSublayer(gradientLayer)
//    }
//
//}

