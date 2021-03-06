//
//  AuthenticationViewController.swift
//  LifeSound
//
//  Created by Stephan Korner on 19.02.17.
//  Copyright © 2017 Stephan Korner. All rights reserved.
//

import UIKit

class MVVMCAuthenticationViewController: UIViewController
{
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
  
    var viewModel: AuthenticateViewModel? {
        willSet {
            viewModel?.viewDelegate = nil
        }
        didSet {
            viewModel?.viewDelegate = self
            refreshDisplay()
        }
    }
    
    fileprivate var isLoaded: Bool = false
    
    override func viewDidLoad()
    {
        title = "Login"
        isLoaded = true;
        
        emailField.addTarget(self, action: #selector(emailFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        passwordField.addTarget(self, action: #selector(passwordFieldDidChange(_:)), for: UIControlEvents.editingChanged)

        refreshDisplay()
    }
    
    fileprivate func refreshDisplay()
    {
        guard isLoaded else { return }
        
        if let viewModel = viewModel {
            emailField.text = viewModel.email
            passwordField.text = viewModel.password
            errorMessageLabel.text = viewModel.errorMessage
            loginButton.isEnabled = viewModel.canSubmit
        } else {
            emailField.text = ""
            passwordField.text = ""
            errorMessageLabel.text = ""
            loginButton.isEnabled = false
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: AnyObject)
    {
        viewModel?.submit()
    }
    
    func emailFieldDidChange(_ textField: UITextField)
    {
        if let text = textField.text {
            viewModel?.email = text
        }
    }
    
    func passwordFieldDidChange(_ textField: UITextField)
    {
        if let text = textField.text {
            viewModel?.password = text
        }
    }
}


/// AuthenticateViewModelViewDelegate Implementation
extension MVVMCAuthenticationViewController: AuthenticateViewModelViewDelegate
{
    func canSubmitStatusDidChange(_ viewModel: AuthenticateViewModel, status: Bool)
    {
        loginButton.isEnabled = status
    }
    
    
    func errorMessageDidChange(_ viewModel: AuthenticateViewModel, message: String)
    {
        errorMessageLabel.text = message
    }
}
