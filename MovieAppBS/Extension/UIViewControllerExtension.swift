//
//  UIViewControllerExtension.swift
//  MovieAppBS
//
//  Created by Sohanur Rahman on 19/4/23..
//

import UIKit

extension UIViewController {
    
    func getStatusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
