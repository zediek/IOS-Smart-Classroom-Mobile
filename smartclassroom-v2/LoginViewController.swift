//
//  LoginViewController.swift
//  smartclassroom-v2
//
//  Created by Neil Steven Villamil on 16/07/2019.
//  Copyright © 2019 Neil Steven Villamil. All rights reserved.
//

import UIKit



class LoginViewController: UIViewController {

    @IBOutlet weak var usernametxt: UITextField!
    @IBOutlet weak var passwordtxt: UITextField!
    
    
    var userType:String = ""
    var Token:String = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginbtn(_ sender: Any) {
        
        let username = usernametxt.text
        let password = passwordtxt.text
        
        if (username?.isEmpty)! || (password?.isEmpty)! {
            displayMessage(userMessage: "Required")
            return
        }
        
        let myActivityIndicator = UIActivityIndicatorView(style: .gray)
        
        
        myActivityIndicator.center = view.center
        
        myActivityIndicator.hidesWhenStopped = false
        
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        
        let myurl = URL(string: "https://smart-classroom.foundationu.com/api/login")
        var request = URLRequest(url: myurl!)
        request.httpMethod = "POST"
        //request.addValue("application/json", forHTTPHeaderField: "utf-8")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = [
            "username": username!,
            "password": password!
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
            
           //let this = "\(String(describing: stringjson!))"
            
            //print(this)
            
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            
            
            
            
            if let val = json as? [String: Any]{
                if let usertype = val["userType"] as? String {
                    if let token = val["token"] as? String{
                    
                    self.userType = usertype
                    self.Token = token
                        
                   
                    DispatchQueue.main.async {
                        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        homeViewController.usertype = self.userType
                        homeViewController.token = self.Token
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = homeViewController
                    }
                    
                    
                    
                    }
                }
                
                if let message = val["message"] as? String {
                
                    
                    self.displayMessage(userMessage: message)
                    
                }
                
                
                
            }
            
            
            }
        task.resume()
        
        
    }


    
    
    
    @IBAction func registerbtn(_ sender: Any) {
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        
        self.present(registerViewController, animated: true)
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
