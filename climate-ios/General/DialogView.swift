//
//  DialogView.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//

import Foundation
import UIKit

class DialogView {
    class func showDialog(error: CustomError, okTitle: String? = nil, okBlock: completeBlock? = nil, vc: UIViewController? = nil) {
        let title: String = unwrapped(error.title, with: "")
        let message: String = unwrapped(error.message, with: "")
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var buttonTitle: String
        if let okt: String = okTitle {
            buttonTitle = okt
        } else {
            switch error.type {
            case .forceUpdate:
                buttonTitle = "general_005".localize()
            default:
                buttonTitle = "general_002".localize()
            }
        }
        let action: UIAlertAction = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
            switch error.type {
            case .forceUpdate:
                if let url: URL = URL(string: unwrapped(error.storeLink, with: "")) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            case .unsupportedOS:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    DialogView.showDialog(error: error)
                })
            default:
                if let block: completeBlock = okBlock {
                    block()
                }
            }
        })
        alert.addAction(action)
        alert.preferredAction = action
        if let showVc: UIViewController = vc {
            showVc.present(alert, animated: true)
        } else if let topView: UIViewController = UIApplication.shared.getTopView() {
            if topView is UIAlertController {
                return
            }
            topView.present(alert, animated: true)
        }
    }
}
