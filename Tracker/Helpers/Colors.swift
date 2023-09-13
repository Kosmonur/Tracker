//
//  Colors.swift
//  Tracker
//
//  Created by Александр Пичугин on 17.08.2023.
//

import UIKit

enum Color {
    
    static let colorsArray: [UIColor] = (1...18).map { UIColor(named:"Color selection \($0)") ?? UIColor.clear }
    
    static let ypBackground = UIColor(named: "YP_Background")
    static let ypBlack = UIColor(named: "YP_Black")
    static let ypBlue = UIColor(named: "YP_Blue")
    static let ypCellBorderColor = UIColor(named: "YP_CellBorderColor")
    static let ypEmojiBgColor = UIColor(named: "YP_EmojiBgColor")
    static let ypGray = UIColor(named: "YP_Gray")
    static let ypLightGray = UIColor(named: "YP_LightGray")
    static let ypRed = UIColor(named: "YP_Red")
    static let ypWhite = UIColor(named: "YP_White")
    static let ypBlackConst = UIColor(named: "YP_Black_const")
    static let ypBlackConstAlpha = ypBlackConst?.withAlphaComponent(0.3)
    static let ypWhiteConst = UIColor(named: "YP_White_const")
    
}
