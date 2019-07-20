//
//  RegisterViewController.swift
//  smartclassroom-v2
//
//  Created by Neil Steven Villamil on 16/07/2019.
//  Copyright © 2019 Neil Steven Villamil. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstnametxt: UITextField!
    @IBOutlet weak var lastnametxt: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var usernametxt: UITextField!
    @IBOutlet weak var passwordtxt: UITextField!
    @IBOutlet weak var confirmpasswordtxt: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerbtn(_ sender: Any) {
        if (firstnametxt.text?.isEmpty)! || (lastnametxt.text?.isEmpty)! || (emailtxt.text?.isEmpty)! || (usernametxt.text?.isEmpty)! || (passwordtxt.text?.isEmpty)! || (confirmpasswordtxt.text?.isEmpty)!{
            
                displayMessage(userMessage: "All fields are required!")
            return
            
        }
            
            if ((passwordtxt.text?.elementsEqual(confirmpasswordtxt.text!))! != true){
                displayMessage(userMessage: "Password Missmatch!")
                return
            }
        
        let myActivityIndicator = UIActivityIndicatorView(style: .gray)
        
        
        myActivityIndicator.center = view.center
        
        myActivityIndicator.hidesWhenStopped = false
        
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        
        
        let myurl = URL(string: "http://10.99.226.141:5000/smart-classroom/register")
        var request = URLRequest(url: myurl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = [
            "Fname": firstnametxt.text!,
            "Lname": lastnametxt.text!,
            "email": emailtxt.text!,
            "username": usernametxt.text!,
            "password": passwordtxt.text!
        ] as [String: String]
        
        
        do {
            
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        }catch {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong. Try again!")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request){
            (data: Data?, response: URLResponse?, error: Error?) in
            
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            
            guard let data = data,error == nil else{
                print(error?.localizedDescription ?? "No Data")
                return
            }
            
            
            //let stringjson = String(data: data, encoding: .utf8)
            
            //let this = "\(String(stringjson!))"
            
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let r = json as? [String: Any]{
                if let register = r["registered"] as? Bool {
                    if(register == false){
                        self.displayMessage(userMessage: "Register Failed")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = loginViewController
                    }
                }
            }
            
        }
        
        task.resume()
        
        
        
        
    }
    
    
    @IBAction func loginbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    
    
    func displayMessage(userMessage:String) -> Void{
        DispatchQueue.main.async
            {
        
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
                let OKAction = UIAlertAction(title: "OK", style: .default)
                { (action: UIAlertAction!) in
                    print("Ok button tapped")
                    DispatchQueue.main.async
                        {
                            self.dismiss(animated: true, completion: nil)
                        }
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
    }
    
}
