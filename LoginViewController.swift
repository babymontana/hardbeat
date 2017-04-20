//
//  LoginViewController.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 02/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    

    @IBOutlet weak var correo: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(LoginViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
       
      
    }

    @IBAction func next(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func editando(_ sender: Any) {
         animateViewMoving(up: true, moveValue: 100)
    }
    
    @IBAction func finEditando(_ sender: Any) {
        animateViewMoving(up:false, moveValue: 100)
    }
    
    @IBAction func login(_ sender: Any) {
        if self.correo.text == "" || self.password.text == "" {
    
            
            let alertController = UIAlertController(title: "Error", message: "Porfavor ingrese su correo y password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.correo.text!, password: self.password.text!) { (user, error) in
                
                if error == nil {
                    
                    
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    @IBAction func done(_ sender: Any) {
        
        view.endEditing(true)
    }
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    @IBAction func recuperar(_ sender: Any) {
        let alertController = UIAlertController(title: "Recuperar password", message: "Porfavor escribe tu correo:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields![0] as? UITextField {
                
                let correo = field.text
                
                FIRAuth.auth()?.sendPasswordReset(withEmail: correo!, completion: { (error) in
                    
                    var title = ""
                    var message = ""
                    
                    if error != nil {
                        title = "Error!"
                        message = (error?.localizedDescription)!
                    } else {
                        title = "Exito!"
                        message = "La solicitud para restaurar tu contraseña fue enviada."
                                           }
                    
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                })
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    
}
