//
//  extensionHelpers.swift
//  iOS_Test
//
//  Created by Aang on 31/07/24.
//

import Foundation
import UIKit

extension UIView{
    func addBorder(cornerRadius: CGFloat = 0, borderColor : CGColor? = nil, borderWidth: CGFloat = 0){
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
}
