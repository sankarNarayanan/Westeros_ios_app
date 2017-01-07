//
//  UtilitiesController.swift
//  WesterosAtWar
//
//  Created by Sankar Narayanan on 08/01/17.
//  Copyright © 2017 Sankar Narayanan. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    @objc class func colorWithHexValue(hexValue:NSString) -> UIColor {
        var c:UInt32 = 0xffffff
        if hexValue.hasPrefix("#") {
            NSScanner(string: hexValue.substringFromIndex(1)).scanHexInt(&c)
        }else{
            NSScanner(string: hexValue as String).scanHexInt(&c)
        }
        if hexValue.length > 7 {
            return UIColor(red: CGFloat((c & 0xff000000) >> 24)/255.0, green: CGFloat((c & 0xff0000) >> 16)/255.0, blue: CGFloat((c & 0xff00) >> 8)/255.0, alpha: CGFloat(c & 0xff)/255.0)
        }else{
            return UIColor(red: CGFloat((c & 0xff0000) >> 16)/255.0, green: CGFloat((c & 0xff00) >> 8)/255.0, blue: CGFloat(c & 0xff)/255.0, alpha: 1.0)
        }
    }
}