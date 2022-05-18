//
//  SearchViewController.swift
//  GithubFollowers
//
//  Created by Vladimir Gusev on 13.05.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    let logoImageView = UIImageView()
    let usernameTextField = GFTextField()
    let submitButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    
    var isUsernameEntered: Bool {
        // force unwraping can crash the app
        return !(usernameTextField.text?.isEmpty ?? true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setup() {
        configureLogoImageView()
        configureUsernameTextField()
        configureSubmitButton()
        
        // Tap Gesture to dismissKeybord
        createDismissKeyboardTapGestureRecognizer()
    }
    
    func createDismissKeyboardTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func pushFollowerViewController() {
//        guard isUsernameEntered else {
//            print("No user name")
//            presentGFAlertOnMainAlert(title: "Empty username", message: "Please enter a username.", buttonTitle: "Ok")
//            return
//        }
        
        guard let userName = usernameTextField.text, !userName.isEmpty else {
            presentGFAlertOnMainAlert(title: "Empty username", message: "Please enter a username.", buttonTitle: "Ok")
            return
        }
        
        let followerVC = FollowerListViewController()
        followerVC.username = usernameTextField.text
        followerVC.title = usernameTextField.text
        navigationController?.pushViewController(followerVC, animated: true)
    }
    
    // MARK: - Constraints
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureUsernameTextField() {
        view.addSubview(usernameTextField)
        
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureSubmitButton() {
        view.addSubview(submitButton)
        submitButton.addTarget(self, action: #selector(pushFollowerViewController), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerViewController()
        return true
    }
}
