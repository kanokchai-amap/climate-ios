//
//  BaseViewController.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    var baseScreenHeight: CGFloat = 0
    
    var loadView: UIView?
    let loadingIndicator: ProgressView = {
        let progress: ProgressView = ProgressView(colors: [.black, .darkGray], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.isUserInteractionEnabled = false
        return progress
    }()
    var viewPositionLoading: UIView?
    var nLoadViewAlpha: CGFloat = 0.5
    var nLoadViewBgColor: UIColor = .black
    var needUpdateViewKeyboardAgain: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setTabBar()
        calScreenHeight()
    }
    
    private func setTabBar() {
        tabBarController?.tabBar.barTintColor = .black
        tabBarController?.tabBar.unselectedItemTintColor = .darkGray
        tabBarController?.tabBar.tintColor = .darkGray
        tabBarController?.tabBar.isTranslucent = false
        let appearance: UITabBarItem = UITabBarItem.appearance()
        let attributes: [NSAttributedString.Key: UIFont] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key: Any], for: .normal)
        
        if #available(iOS 15.0, *) {
            let appearance: UITabBarAppearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .blue
            self.tabBarController?.tabBar.standardAppearance = appearance
            self.tabBarController?.tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func calScreenHeight() {
        if baseScreenHeight == 0 {
            baseScreenHeight = self.view.frame.height
        }
    }
    
    func subscribeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func enterFromBackground(notification: NSNotification) {
        needUpdateViewKeyboardAgain = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if needUpdateViewKeyboardAgain {
            needUpdateViewKeyboardAgain = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.keyboardWillShow(notification: notification)
            }
        } else {
            if let keyboardSize: CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.height == baseScreenHeight {
                    UIView.animate(withDuration: 0.1, animations: { () -> Void in
                        self.view.frame.size.height -= keyboardSize.height
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.height < baseScreenHeight {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.size.height = self.baseScreenHeight
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        if self.view.frame.height != baseScreenHeight {
            if let keyboardSize: CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.size.height = self.baseScreenHeight - keyboardSize.height
            }
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupLoading() {
        if loadView == nil {
            loadView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height))
            
            guard let nLoadView: UIView = loadView else { return }
            nLoadView.backgroundColor = nLoadViewBgColor
            nLoadView.alpha = nLoadViewAlpha
            if let viewPosition: UIView = viewPositionLoading {
                viewPosition.addSubview(nLoadView)
                viewPosition.addSubview(loadingIndicator)
                NSLayoutConstraint.activate([
                    loadingIndicator.centerXAnchor
                        .constraint(equalTo: viewPosition.centerXAnchor),
                    loadingIndicator.centerYAnchor
                        .constraint(equalTo: viewPosition.centerYAnchor),
                    loadingIndicator.widthAnchor
                        .constraint(equalToConstant: 50),
                    loadingIndicator.heightAnchor
                        .constraint(equalTo: self.loadingIndicator.widthAnchor)
                ])
            } else {
                self.view.addSubview(nLoadView)
                self.view.addSubview(loadingIndicator)
                NSLayoutConstraint.activate([
                    loadingIndicator.centerXAnchor
                        .constraint(equalTo: self.view.centerXAnchor),
                    loadingIndicator.centerYAnchor
                        .constraint(equalTo: self.view.centerYAnchor),
                    loadingIndicator.widthAnchor
                        .constraint(equalToConstant: 50),
                    loadingIndicator.heightAnchor
                        .constraint(equalTo: self.loadingIndicator.widthAnchor)
                ])
            }
            nLoadView.isHidden = true
        }
    }
    
    func startLoading() {
        setupLoading()
        if let nLoadView: UIView = loadView, nLoadView.isHidden {
            loadingIndicator.isAnimating = true
            nLoadView.isHidden = false
        }
    }
    
    func stopLoading() {
        if let nLoadView: UIView = loadView {
            DispatchQueue.main.async {
                self.loadingIndicator.isAnimating = false
                nLoadView.isHidden = true
            }
        }
    }
    
    func addViewController(_ child: UIViewController, _ addView: UIView) {
        addChild(child)
        addView.addSubview(child.view)
        child.view.frame = addView.bounds
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.didMove(toParent: self)
    }
    
    func removeViewController(_ child: UIViewController) {
        guard child.parent != nil else { return }
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}

