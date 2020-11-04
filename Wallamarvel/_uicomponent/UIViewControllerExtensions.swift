//
//  UIViewControllerExtensions.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import UIKit

extension UIViewController {
    func display(error: Error, autoDismissInterval: TimeInterval = 5) {
        var output = error.localizedDescription
        if let localizedError = error as? LocalizedError,
            let message = localizedError.errorDescription {
            output = message
        }
        showDropDownView(text: output, autoDismissInterval: autoDismissInterval, bgColor: #colorLiteral(red: 0.9803921569, green: 0.5176470588, blue: 0.6, alpha: 1))
    }
    
    func showDropDownView(text: String, autoDismissInterval: TimeInterval? = nil, bgColor: UIColor? = UIColor.black) {
        guard let appWindow = view.window else { return }
        appWindow.windowLevel = .alert

        let dropDownView = DropdownView(autoDismissInterval: autoDismissInterval)
        dropDownView.bodyLabel.text = text
        dropDownView.backgroundColor = bgColor
        
        appWindow.addSubview(dropDownView)
        dropDownView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        dropDownView.slideDown()
        dropDownView.didDismiss = {
            dropDownView.removeFromSuperview()
            appWindow.windowLevel = .normal
        }
    }
}
