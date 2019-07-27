//
//  RemoteViewController.swift
//  smartclassroom-v2
//
//  Created by Neil Steven Villamil on 18/07/2019.
//  Copyright © 2019 Neil Steven Villamil. All rights reserved.
//

import UIKit

class RemoteViewController: UIViewController {
    let AirconLabel = UILabel()
    let AirconSwitch = UISwitch()
    let TempLabel = UILabel()
    let RoomSlider = UISlider()
    let LightsLabel = UILabel()
    let LightsSwitch = UISwitch()
    let DoorLabel = UILabel()
    let DoorSwitch = UISwitch()
    
    var roomName: String = ""
    
    var token: String = ""
    var usertype: String = ""
    
    var airconStatus: Bool = false
    var airconId: Int = 0
    var airconStatusId:Int = 0
    
    var tempStatus: Int = 0
    var tempId: Int = 0
    var tempStatusId:Int = 0
    
    var doorStatus: Bool = false
    var doorId: Int = 0
    var doorStatusId:Int = 0
    
    var lightsStatus: Bool = false
    var lightsId: Int = 0
    var lightsStatusId:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGray
        
        createRoomControl()

        // Do any additional setup after loading the view.
    }
    
    
    func createRoomControl(){
        print("aircon room status id:  \(airconStatusId)")
        print("lights room status id:  \(lightsStatusId)")
        print("temperature room status id: \(tempStatusId)")
        print("D")
        
        
        
        createBackButton()
        createRoomNameLabel()
        createAirconLabel()
        createAirconSwitch()
        createTempLabel()
        createTempSlider()
        createLightsLabel()
        createLightsSwitch()
        createDoorLabel()
        createDoorSwitch()
    }
    
    
    func createBackButton(){
        let backbutton = UIButton()
        backbutton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        backbutton.tintColor = UIColor.white
        backbutton.backgroundColor = UIColor.black
        backbutton.titleLabel?.font = backbutton.titleLabel?.font.withSize(24)
        backbutton.setTitle("Back", for: UIControl.State.normal)
        backbutton.addTarget(self, action: #selector(self.backButtonOnClick), for: UIControl.Event.touchUpInside)
        self.view.addSubview(backbutton)
    }
    
    func createRoomNameLabel(){
        let RoomName = UILabel()
        RoomName.frame = CGRect(x: 0, y: 100, width: 400, height: 100)
        RoomName.text = self.roomName
        RoomName.textAlignment = .center
        RoomName.font = RoomName.font.withSize(34)
        self.view.addSubview(RoomName)
    }
    
    func createAirconLabel(){
        AirconLabel.frame = CGRect(x: 10, y: 200, width: 100, height: 100)
        AirconLabel.text = "Aircon"
        AirconLabel.font = AirconLabel.font.withSize(24)
        self.view.addSubview(AirconLabel)
    }
    
    func createAirconSwitch(){
        AirconSwitch.frame = CGRect(x: 350, y: 230, width: 50, height: 10)
        if self.airconStatus == true{
            AirconSwitch.isOn = true
            RoomSlider.isEnabled = true
        }else{
            AirconSwitch.isOn = false
            RoomSlider.isEnabled = false
        }
        AirconSwitch.addTarget(self, action: #selector(self.airconSwitchIsSwitch), for: UIControl.Event.valueChanged)
        self.view.addSubview(AirconSwitch)
    }
    
    func createTempLabel(){
        TempLabel.frame = CGRect(x: 10, y: 350, width: 1000, height: 100)
        TempLabel.text = "Temp \(self.tempStatus)°C"
        TempLabel.font = TempLabel.font.withSize(24)
        self.view.addSubview(TempLabel)
    }
    
    
    
    func createTempSlider(){
        RoomSlider.frame = CGRect(x: 10, y: 400, width: 390, height: 100)
        RoomSlider.minimumValue = 16
        RoomSlider.maximumValue = 26
        print(Int(self.tempStatus))
        RoomSlider.value = Float(Int(self.tempStatus))
        RoomSlider.addTarget(self, action: #selector(self.tempSliderIsSlide), for: .touchUpInside)
        self.view.addSubview(RoomSlider)
    }
    
    
    func createLightsLabel(){
        LightsLabel.frame = CGRect(x: 10, y: 500, width: 100, height: 100)
        LightsLabel.text = "Lights"
        LightsLabel.font = LightsLabel.font.withSize(24)
        self.view.addSubview(LightsLabel)
    }
    
    func createLightsSwitch(){
        LightsSwitch.frame = CGRect(x: 350, y: 530, width: 50, height: 10)
        if self.lightsStatus == true{
            LightsSwitch.isOn = true
        }else{
            LightsSwitch.isOn = false
        }
        LightsSwitch.addTarget(self, action: #selector(self.LightsSwitchisSwitch), for: UIControl.Event.valueChanged)
        self.view.addSubview(LightsSwitch)
    }
    
    func createDoorLabel(){
        DoorLabel.frame = CGRect(x: 10, y: 600, width: 100, height: 100)
        DoorLabel.text = "Door"
        DoorLabel.font = DoorLabel.font.withSize(24)
        self.view.addSubview(DoorLabel)
    }
    
    func createDoorSwitch(){
        DoorSwitch.frame = CGRect(x: 350, y: 630, width: 50, height: 10)
        if self.doorStatus == true{
            DoorSwitch.isOn = true
        }else{
            DoorSwitch.isOn = false
        }
        DoorSwitch.addTarget(self, action: #selector(self.doorSwitchisSwitch), for: UIControl.Event.valueChanged)
        self.view.addSubview(DoorSwitch)
    }
    
    
    @objc func backButtonOnClick(sender: UIButton){
        DispatchQueue.main.async {
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            homeViewController.usertype = self.usertype
            homeViewController.token = self.token
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = homeViewController
        }
    }
    
    
    @objc func airconSwitchIsSwitch(sender: UISwitch){
        print(sender.isOn)
        if sender.isOn == true{
            RoomSlider.isEnabled = true
        }else{
            RoomSlider.isEnabled = false
        }
        
        
        let myurl = URL(string: "https://smart-classroom.foundationu.com/api/roomStatusByID/\(self.airconStatusId)")
        var request = URLRequest(url: myurl!)
        request.httpMethod = "PUT"
        //request.addValue("application/json", forHTTPHeaderField: "utf-8")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(self.token, forHTTPHeaderField: "x-access-token")
        
        let json_data = [
            "value": sender.isOn
        ] as [String: Bool]

        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: json_data, options: .prettyPrinted)
        }catch{
            print(error.localizedDescription)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request,completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            
            print("Error:")
            print(error as Any)
            print("Response:")
            print(response as Any)
            print("Data:")
            print(data as Any)
            print(String(data: data!, encoding: String.Encoding.utf8)!)
        }).resume()
        
    }
    
    
    
    @objc func tempSliderIsSlide(sender: UISlider){
        TempLabel.text = "Temp                                                     \(String(Int(sender.value)))°C"
        print(Int(sender.value))
        
        
        let myurl = URL(string: "https://smart-classroom.foundationu.com/api/roomStatusByID/\(self.tempStatusId)")
        var request = URLRequest(url: myurl!)
        request.httpMethod = "PUT"
        //request.addValue("application/json", forHTTPHeaderField: "utf-8")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(self.token, forHTTPHeaderField: "x-access-token")
        
        let json_data = [
            "value": Int(sender.value)
            ] as [String: Int]
        
        
        
        
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: json_data, options: .prettyPrinted)
        }catch{
            print(error.localizedDescription)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request,completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            
            print("Error:")
            print(error as Any)
            print("Response:")
            print(response as Any)
            print("Data:")
            print(data as Any)
            print(String(data: data!, encoding: String.Encoding.utf8)!)
        }).resume()
        
        
        
    }
    
    
    @objc func LightsSwitchisSwitch(sender: UISwitch){
        let myurl = URL(string: "https://smart-classroom.foundationu.com/api/roomStatusByID/\(self.lightsStatusId)")
        var request = URLRequest(url: myurl!)
        request.httpMethod = "PUT"
        //request.addValue("application/json", forHTTPHeaderField: "utf-8")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(self.token, forHTTPHeaderField: "x-access-token")
        
        let json_data = [
            "value": sender.isOn
            ] as [String: Bool]
        
        
        
        
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: json_data, options: .prettyPrinted)
        }catch{
            print(error.localizedDescription)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request,completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            
            print("Error:")
            print(error as Any)
            print("Response:")
            print(response as Any)
            print("Data:")
            print(data as Any)
            print(String(data: data!, encoding: String.Encoding.utf8)!)
        }).resume()
    }
    
    @objc func doorSwitchisSwitch(sender: UISwitch){
        
        let myurl = URL(string: "https://smart-classroom.foundationu.com/api/roomStatusByID/\(self.doorStatusId)")
        var request = URLRequest(url: myurl!)
        request.httpMethod = "PUT"
        //request.addValue("application/json", forHTTPHeaderField: "utf-8")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(self.token, forHTTPHeaderField: "x-access-token")
        
        let json_data = [
            "value": sender.isOn
            ] as [String: Bool]
        
        
        
        
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: json_data, options: .prettyPrinted)
        }catch{
            print(error.localizedDescription)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request,completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            
            print("Error:")
            print(error as Any)
            print("Response:")
            print(response as Any)
            print("Data:")
            print(data as Any)
            print(String(data: data!, encoding: String.Encoding.utf8)!)
        }).resume()
        
        
    }
    
    
}
