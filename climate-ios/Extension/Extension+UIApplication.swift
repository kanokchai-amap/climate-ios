//
//  Extension+UIApplication.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 24/8/2566 BE.
//

import Foundation
import UIKit

extension UIApplication {
    
    func getTopView() -> UIViewController? {
        if let topController: UIViewController = UIApplication.shared.keyWindow?.rootViewController {
            return getLastTop(from: topController)
        } else {
            return nil
        }
    }
    
    private func getLastTop(from vc: UIViewController) -> UIViewController? {
        if let tabView: UITabBarController = vc as? UITabBarController,
           let selectedView: UIViewController = tabView.selectedViewController {
            return getLastTop(from: selectedView)
        } else if let nav: UINavigationController = vc as? UINavigationController, let lastView: UIViewController = nav.viewControllers.last {
            return getLastTop(from: lastView)
        } else if let presentedViewController: UIViewController = vc.presentedViewController {
            return getLastTop(from: presentedViewController)
        } else {
            return vc
        }
    }
    
    func getBottomSafeArea() -> CGFloat {
        return unwrapped(keyWindow?.safeAreaInsets.bottom, with: .zero)
    }
}
