//
//  RemoteViewController.swift
//  smartclassroom-v2
//
//  Created by Neil Steven Villamil on 18/07/2019.
//  Copyright © 2019 Neil Steven Villamil. All rights reserved.
//

import UIKit

class RemoteViewController: UIViewController {
    @IBOutlet weak var temp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func tempslider(_ sender: UISlider) {
        temp.text = String(describing:  Int(sender.value))
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
