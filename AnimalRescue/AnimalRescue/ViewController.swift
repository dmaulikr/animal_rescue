//
//  ViewController.swift
//  AnimalRescue
//
//  Created by Christian S. on 07/05/15.
//  Copyright (c) 2015 Christian S. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Parse

class ViewController: UIViewController {

    
    @IBOutlet weak var logInNameTextField: UITextField!
    
    @IBOutlet weak var logInPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpNameTextField: UITextField!
    
    @IBOutlet weak var signUpEmailTextField: UITextField!
    
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Object has been saved.")
        }

//        var loginButton: FBSDKLoginButton = FBSDKLoginButton()
//        loginButton.center = self.view.center
//        self.view.addSubview(loginButton)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if (PFUser.currentUser() != nil) {
            self.performSegueWithIdentifier("goToMapViewController", sender: self)
        }
    }
    
    
    
    
    @IBAction func signUpButtonOfSignUpView(sender: AnyObject) {
        
        if signUpNameTextField.text == ""{
            let alert = UIAlertView()
            alert.title = "ERRO"
            alert.message = "Preencha o campo 'nome'"
            alert.addButtonWithTitle("Ok")
            alert.show()
        
        } else if signUpPasswordTextField.text == ""{
            let alert = UIAlertView()
            alert.title = "ERRO"
            alert.message = "Preencha o campo 'Senha'"
            alert.addButtonWithTitle("Ok")
            alert.show()
            
        }   else if signUpEmailTextField.text == ""{
            
            let alert = UIAlertView()
            alert.title = "ERRO"
            alert.message = "Preencha o campo 'E-mail'"
            alert.addButtonWithTitle("Ok")
            alert.show()
            
        } else{
            var user = PFUser()
            user.username = signUpNameTextField.text
            user.password = signUpPasswordTextField.text
            user.email = signUpEmailTextField.text
            user["keys"] = 10
            
            user.signUpInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    println(error) // there is an error, print it
                    let alert = UIAlertView()
                    alert.title = "Error"
                    alert.message = error.description
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                } else {
                    
                    if succeeded == true {
                        println("success")
                        
                        let alert = UIAlertView()
                        alert.title = "Sucesso"
                        alert.message = "Usuário criado com sucesso"
                        alert.addButtonWithTitle("\\o/")
                        alert.show()
                        
                        
                        
                        self.signUpNameTextField.text = ""
                        self.signUpPasswordTextField.text = ""
                        self.signUpEmailTextField.text = ""
                        
                        self.logInNameTextField.text = user.username
                        
                        self.signUpView.hidden = true
                    } else {
                        println("failed")
                        let alert = UIAlertView()
                        alert.title = "ERRO"
                        alert.message = "Ouve um erro na criação do usuário. Tente novamente.'"
                        alert.addButtonWithTitle("Ok")
                        alert.show()
                    }
                }
            }
            
        }
        

        
    }
    

    @IBAction func loginButton(sender: AnyObject) {
//        PFUser.logOut()
        
//        PFUser.logInWithUsernameInBackground(logInNameTextField.text, password: logInPasswordTextField.text) {
//            (void) -> Void in
//            
//            println(PFUser.currentUser())
//            if((PFUser.currentUser()) != nil){
//                self.performSegueWithIdentifier("goToNavController", sender: nil)
//                self.logInNameTextField.text = ""
//                self.logInPasswordTextField.text = " "
//                
//            } else {
//                let alert = UIAlertView()
//                alert.title = "Error"
//                alert.addButtonWithTitle("Ok")
//                alert.show()
//            }
//        }
        
        PFUser.logInWithUsernameInBackground(logInNameTextField.text, password:logInPasswordTextField.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                println(PFUser.currentUser())
                self.logInNameTextField.text = ""
                self.logInPasswordTextField.text = ""
                self.performSegueWithIdentifier("goToMapViewController", sender: self)
                
            } else {
                let alert = UIAlertView()
                alert.title = "ERRO"
                alert.message = error?.description
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
        }
    }

    @IBAction func signUpButton(sender: AnyObject) {
        signUpView.hidden = false
    
    }
    
    @IBAction func logInButtonOfSignUpView(sender: AnyObject) {
        signUpView.hidden = true
    }
    

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    

}

