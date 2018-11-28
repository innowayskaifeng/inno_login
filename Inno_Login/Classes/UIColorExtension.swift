//
//  UIColorExtension.swift
//  HEXColor
//
//  Created by R0CKSTAR on 6/13/14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

import UIKit

/**
 MissingHashMarkAsPrefix:   "Invalid RGB string, missing '#' as prefix"
 UnableToScanHexValue:      "Scan hex error"
 MismatchedHexStringLength: "Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8"
 */
public enum UIColorInputError : Error {
    case missingHashMarkAsPrefix,
    unableToScanHexValue,
    mismatchedHexStringLength
}

extension UIColor {
    
    /*#colorLiteral(red: 1, green: 0.7823970318, blue: 0.2735670209, alpha: 1)*/
    static var aColorMain :UIColor{return UIColor(red:1.00, green:0.74, blue:0.22, alpha:1.00)}
    
    /*#colorLiteral(red: 0, green: 0.702847302, blue: 0.7884733081, alpha: 1)*/
    static var aColorPacifia :UIColor{return UIColor(red:0.00, green:0.65, blue:0.74, alpha:1.00)}
    
    /*#colorLiteral(red: 0.3252815008, green: 0.1984128058, blue: 0.9795206189, alpha: 1)*/
    static var aColorBlue :UIColor{return UIColor(red:0.25, green:0.00, blue:0.97, alpha:1.00)}
    
    /*#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)*/
    static var aColorWhite :UIColor{return UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)}
    
    /*#colorLiteral(red: 1, green: 0.303145349, blue: 0.6388897896, alpha: 1)*/
    static var aColorStrawberry :UIColor{return UIColor(red:1.00, green:0.18, blue:0.57, alpha:1.00)}
    
    /*#colorLiteral(red: 1, green: 0.5792174935, blue: 0.5581374764, alpha: 1)*/
    static var aColorFadedRed :UIColor{return UIColor(red:1.00, green:0.49, blue:0.49, alpha:1.00)}
    
    /*#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)*/
    static var aColorWhiteSmoke :UIColor{return UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)}
    
    /*#colorLiteral(red: 0.9499699473, green: 0.9504894614, blue: 0.965736568, alpha: 1)*/
    static var aTableViewColor:UIColor{return UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)}
    
    /*#colorLiteral(red: 0.3147013783, green: 0.314709574, blue: 0.3147051334, alpha: 1)*/
    static var aColorLightBlack:UIColor{return UIColor(red: 63/255.0, green: 63/255.0, blue: 63/255.0, alpha: 1.0)}
    
    /*#colorLiteral(red: 0.8732705712, green: 0.8732910752, blue: 0.8732799888, alpha: 1)*/
    static var aColorLiteGray:UIColor{return UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.00)}
    
    /*#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)*/
    static var aBorderColor:UIColor{return UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)}
    /**
     The shorthand three-digit hexadecimal representation of color.
     #RGB defines to the color #RRGGBB.
     
     - parameter hex3: Three-digit hexadecimal value.
     - parameter alpha: 0.0 - 1.0. The default is 1.0.
     */
    public convenience init(hex3: UInt16, alpha: CGFloat = 1) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex3 & 0xF00) >> 8) / divisor
        let green   = CGFloat((hex3 & 0x0F0) >> 4) / divisor
        let blue    = CGFloat( hex3 & 0x00F      ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     The shorthand four-digit hexadecimal representation of color with alpha.
     #RGBA defines to the color #RRGGBBAA.
     
     - parameter hex4: Four-digit hexadecimal value.
     */
    public convenience init(hex4: UInt16) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex4 & 0xF000) >> 12) / divisor
        let green   = CGFloat((hex4 & 0x0F00) >>  8) / divisor
        let blue    = CGFloat((hex4 & 0x00F0) >>  4) / divisor
        let alpha   = CGFloat( hex4 & 0x000F       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     The six-digit hexadecimal representation of color of the form #RRGGBB.
     
     - parameter hex6: Six-digit hexadecimal value.
     */
    public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     The six-digit hexadecimal representation of color with alpha of the form #RRGGBBAA.
     
     - parameter hex8: Eight-digit hexadecimal value.
     */
    public convenience init(hex8: UInt32) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
        let green   = CGFloat((hex8 & 0x00FF0000) >> 16) / divisor
        let blue    = CGFloat((hex8 & 0x0000FF00) >>  8) / divisor
        let alpha   = CGFloat( hex8 & 0x000000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB, throws error.
     
     - parameter rgba: String value.
     */
    public convenience init(rgba_throws rgba: String) throws {
        guard rgba.hasPrefix("#") else {
            throw UIColorInputError.missingHashMarkAsPrefix
        }
       
        let hexString: String =  String(rgba.suffix(from: rgba.index(rgba.startIndex, offsetBy: 1)))
        var hexValue:  UInt32 = 0
        
        guard Scanner(string: hexString).scanHexInt32(&hexValue) else {
            throw UIColorInputError.unableToScanHexValue
        }
        
        switch (hexString.count) {
        case 3:
            self.init(hex3: UInt16(hexValue))
        case 4:
            self.init(hex4: UInt16(hexValue))
        case 6:
            self.init(hex6: hexValue)
        case 8:
            self.init(hex8: hexValue)
        default:
            throw UIColorInputError.mismatchedHexStringLength
        }
    }
    
    /**
     The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB, fails to default color.
     
     - parameter rgba: String value.
     */
    public convenience init(_ rgba: String, defaultColor: UIColor = UIColor.clear) {
        guard let color = try? UIColor(rgba_throws: rgba) else {
            self.init(cgColor: defaultColor.cgColor)
            return
        }
        self.init(cgColor: color.cgColor)
    }
    
    /**
     Hex string of a UIColor instance.
     
     - parameter includeAlpha: Whether the alpha should be included.
     */
    public func hexString(_ includeAlpha: Bool = true) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        if (includeAlpha) {
            return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
        } else {
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
}

extension String {
    /**
     Convert argb string to rgba string.
     */
    public func argb2rgba() -> String? {
        guard self.hasPrefix("#") else {
            return nil
        }
        
        let hexString: String = String(self.suffix(from: self.index(self.startIndex, offsetBy: 1)))
        switch (hexString.count) {
        case 4:
            return "#"
                +  String(hexString.suffix(from: self.index(self.startIndex, offsetBy: 1)))
                +  String(hexString.suffix(from: self.index(self.startIndex, offsetBy: 1)))
        case 8:
            return "#"
                +  String(hexString.suffix(from: self.index(self.startIndex, offsetBy: 1)))
                +  String(hexString.suffix(from: self.index(self.startIndex, offsetBy: 1)))
        default:
            return nil
        }
    }
}
