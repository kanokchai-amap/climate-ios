//
//  BaseRouter.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//

import Foundation
import UIKit
enum Storyboard: String {
    case Welcome = "Welcome"
    
    var viewcontrollerId: String {
        return rawValue
    }
    var name: String {
        return String(describing: self)
    }
}

class BaseRouter {
    
    internal weak var viewController: UIViewController?
    
    init() {}
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func present(viewController: UIViewController) {
        let navigationControll: UINavigationController = UINavigationController(rootViewController: viewController)
        self.viewController?.present(navigationControll, animated: true, completion: nil)
    }
    
    func presentFullScreen(_ viewController: UIViewController) {
        let navigationControll: UINavigationController = UINavigationController(rootViewController: viewController)
        navigationControll.modalPresentationStyle = .fullScreen
        self.viewController?.present(navigationControll, animated: true, completion: nil)
    }
    
    func presentFullScreenNoNavbar(_ viewController: UIViewController) {
        let navigationControll: UINavigationController = UINavigationController(rootViewController: viewController)
        navigationControll.modalPresentationStyle = .fullScreen
        navigationControll.navigationBar.isHidden = true
        self.viewController?.present(navigationControll, animated: true, completion: nil)
    }
    
    func presenPoPup(viewController: UIViewController) {
        let navigationControll: UINavigationController = UINavigationController(rootViewController: viewController)
        navigationControll.modalPresentationStyle = .overCurrentContext
        navigationControll.modalTransitionStyle = .crossDissolve
        self.viewController?.present(navigationControll, animated: true, completion: nil)
    }
    
    func presenPoPupBottom(viewController: UIViewController) {
        let navigationControll: UINavigationController = UINavigationController(rootViewController: viewController)
        navigationControll.modalPresentationStyle = .overCurrentContext
        navigationControll.modalTransitionStyle = .coverVertical
        self.viewController?.present(navigationControll, animated: true, completion: nil)
    }
    
    func presenPoPupDrage(viewController: UIViewController) {
        let navigationControll: UINavigationController = UINavigationController(rootViewController: viewController)
        navigationControll.modalPresentationStyle = .custom
        self.viewController?.present(navigationControll, animated: true, completion: nil)
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        guard let navigationController = self.viewController?.navigationController else {
            self.viewController?.present(viewController, animated: animated, completion: nil)
            return
        }
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func presentWithoutNavbar(_ viewController: UIViewController) {
        let navigationControll: UINavigationController = UINavigationController(rootViewController: viewController)
        navigationControll.modalPresentationStyle = .overCurrentContext
        navigationControll.modalTransitionStyle = .crossDissolve
        navigationControll.navigationBar.isHidden = true
        self.viewController?.present(navigationControll, animated: false, completion: nil)
    }
    
    func getViewController<VC: UIViewController>(storyboard: Storyboard, expectedVC: VC.Type) -> VC {
        return unwrapped(UIStoryboard(name: storyboard.name, bundle: nil).instantiateViewController(withIdentifier: storyboard.viewcontrollerId) as? VC, with: VC())
    }

    func getViewControllerWithoutID<VC: UIViewController>(storyboard: Storyboard) -> VC {
        return unwrapped(UIStoryboard(name: storyboard.name, bundle: nil).instantiateInitialViewController() as? VC, with: VC())
    }
    
    func getViewController(storyboard: Storyboard) -> UIViewController {
        return UIStoryboard(name: storyboard.name, bundle: nil)
            .instantiateViewController(withIdentifier: storyboard.viewcontrollerId)
    }
    
    func redirectModallyTo(viewController: UIViewController) {
        self.viewController?.present(viewController, animated: true, completion: nil)
    }
    
    func returnTo(viewController: Swift.AnyClass) {
        
        guard let navigationController = self.viewController?.navigationController else {
            self.viewController?.dismiss(animated: false)
            return
        }
        
        for element in navigationController.viewControllers where element.isKind(of: viewController) {
            navigationController.popToViewController(element, animated: true)
            break
        }
    }
    
    func pushToHome(viewController: UIViewController) {
        let navigationControll: UINavigationController = UINavigationController(rootViewController: viewController)
        navigationControll.modalPresentationStyle = .overFullScreen
        self.viewController?.present(navigationControll, animated: true, completion: nil)
    }
    
    func openWithRoot(viewController: UIViewController) {
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func popViewController() {
        if let nav: UINavigationController = viewController?.navigationController {
            nav.popViewController(animated: true)
        }
    }
}
