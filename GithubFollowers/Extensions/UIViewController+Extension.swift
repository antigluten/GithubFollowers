//
//  UIViewController+Extension.swift
//  GithubFollowers
//
//  Created by Vladimir Gusev on 15.05.2022.
//

import UIKit

extension UIViewController {
    
    func presentGFAlertOnMainAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            
            self.present(alertVC, animated: true)
        }
    }
}
