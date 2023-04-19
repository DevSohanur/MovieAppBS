//
//  UIStringExtension.swift
//  MovieAppBS
//
//  Created by Sohanur Rahman on 19/4/23..
//

import Foundation
import UIKit

extension String{
    func getEstimatedTextHeight(_ size: CGSize, _ fontSize: CGFloat , _ isBold: Bool) -> CGFloat {
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: self).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)], context: nil)
        return estimatedFrame.height
    }
    
    func getHeight(maxWidth: CGFloat, labelFont: UIFont) -> CGFloat {
        let stringLabel =  UILabel(frame: CGRect(x: 0, y: 0, width: maxWidth, height: .greatestFiniteMagnitude))
        stringLabel.numberOfLines = 0
        stringLabel.text = self
        stringLabel.font = labelFont
        stringLabel.sizeToFit()
        return stringLabel.frame.height
     }
    
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
           let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
       
           return ceil(boundingBox.height)
       }
}
