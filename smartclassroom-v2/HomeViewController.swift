//
//  HomeViewController.swift
//  smartclassroom-v2
//
//  Created by Neil Steven Villamil on 19/07/2019.
//  Copyright © 2019 Neil Steven Villamil. All rights reserved.
//

import UIKit

struct JSONData {
    let room_id: Int
    let add_device: Bool
    let room_name: String
    let devices: Array<Any>
    
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }

    init(json:[String: Any])throws {
        guard let room_id = json["room_id"] as? Int else { throw SerializationError.missing("room_id is missing") }
        guard let add_device = json["add_device"] as? Bool else {throw SerializationError.missing("add_device is missing")}
        guard let room_name = json["room_name"] as? String else {throw SerializationError.missing("room_name is missing")}
        guard let devices = json["devices"] as? Array<Any> else {throw SerializationError.missing("devices is missing")}
        
        self.room_id = room_id
        self.add_device = add_device
        self.room_name = room_name
        self.devices = devices
    }
    
    
    
}


struct DeviceData {
    let class_name: String
    let device_name: String
    let remote_design: String
    let device_status: Any
    let remote_design_id: Int
    let device_id: Int
    let room_status_id: Int
    
    enum DeviceError:Error {
        case deviceMissing(String)
        case deviceInvalid(String, Any)
    }
    
    init(jsonDevice:[String: Any])throws {
        guard let class_name = jsonDevice["class_name"] as? String else { throw DeviceError.deviceMissing("class_name is missing") }
        guard let device_name = jsonDevice["device_name"] as? String else { throw DeviceError.deviceMissing("device_name is missing") }
        guard let remote_design = jsonDevice["remote_design"] as? String else { throw DeviceError.deviceMissing("remote_design is missong") }
        guard let device_status = jsonDevice["device_status"] as? Any else { throw DeviceError.deviceMissing("device_status is missing") }
        guard let remote_design_id = jsonDevice["remote_design_id"] as? Int else { throw DeviceError.deviceMissing("remote_design_id is missing") }
        guard let device_id = jsonDevice["device_id"] as? Int else { throw DeviceError.deviceMissing("device_id is missong") }
        guard let room_status_id = jsonDevice["room_status_id"] as? Int else { throw DeviceError.deviceMissing("room_status_id is missong") }
    
        self.class_name = class_name
        self.device_name = device_name
        self.remote_design = remote_design
        self.device_status = device_status
        self.remote_design_id = remote_design_id
        self.device_id = device_id
        self.room_status_id = room_status_id
    }
}


class HomeViewController: UIViewController {
    
    @IBOutlet weak var roomSearch: UISearchBar!
    @IBOutlet weak var roomScrollView: UIScrollView!
    
    var buttons = [UIButton]()
    
    var roomArray = [String]()
    
    
    var usertype: String = ""
    var token: String = ""
    
    var roomName: String = ""
    var airconStatus:String = ""
    var tempStatus: String = ""
    var lightsStatus: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGray
        createRoomArray()
        //createRoomButton()

        // Do any additional setup after loading the view.
    }
    
    

    
    func createRoomArray(){
        
        self.roomScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.roomScrollView.topAnchor.constraint(equalTo: self.roomScrollView.topAnchor, constant: 1000).isActive = true
        self.roomScrollView.bottomAnchor.constraint(equalTo: self.roomScrollView.bottomAnchor, constant: -16).isActive = true
        
        
        let myurl = URL(string: "https://smart-classroom.foundationu.com/api/RoomStatus")
        var request = URLRequest(url: myurl!)
        request.httpMethod = "GET"
        //request.addValue("application/json", forHTTPHeaderField: "utf-8")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(self.token, forHTTPHeaderField: "x-access-token")
        
        let task = URLSession.shared.dataTask(with: request){
            (data: Data?, response: URLResponse?, error: Error?) in
            
            
            guard let data = data,error == nil else{
                print(error?.localizedDescription ?? "No Data")
                return
            }

            //let stringjson = String(data: data, encoding: .utf8)
            
            //let this = "\(String(describing: stringjson!))"
            
            //print(this)
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
              //  print("\(json["room_status"])")
                if let room_status = json["room_status"] as? [[String: Any]]{
                    var i = 300
                    var buttonX = 0
                    var buttonY = 0
                    var isMod = 1
                    for datas in room_status{
                        
                        if let JD = try? JSONData(json: datas){
                          //  print(JD.room_name)
                            
                            
                            
                            
                            
                            
                            
                            

                            
                            if let Devices = JD.devices as? [[String: Any]]{
                                for Device in Devices{
                                    if let JSONDEVICE = try? DeviceData(jsonDevice: Device){
                                      //  print(JSONDEVICE.device_name)
                                        
                                        switch(JSONDEVICE.device_name){
                                            case "Aircon":
                                                if let airconBool = try? JSONDEVICE.device_status as? String{
                                                    if airconBool == "true"{
                                                        self.airconStatus = "on"
                                                    }else{
                                                        self.airconStatus = "off"
                                                    }
                                                }
                                                
                                            break
                                        case "Aircon temperature":
                                            self.tempStatus = JSONDEVICE.device_status as! String
                                        break
                                        case "Lights":
                                            if let lightsBool = try? JSONDEVICE.device_status as? String{
                                                if lightsBool == "true"{
                                                    self.lightsStatus = "on"
                                                }else{
                                                    self.lightsStatus = "off"
                                                }
                                            }
                                        break
                                        default:
                                            let temp = "Wala ra"
                                        }
                                        
 
                                    }
                                 
                                }
                            }
                            
                            

                            
                            
                            DispatchQueue.main.async {
                                self.roomArray.append({"\(JD.room_name):\(JD.room_id)"}())
                              //  print(JD.room_name)
                                let RoomButton = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: 190, height: 100))
                                RoomButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                                var Roomtext = NSAttributedString(string: "\(JD.room_name)\nAircon  \(self.airconStatus)\nTemp  \(self.tempStatus)°C\nLights  \(self.lightsStatus)")
                                RoomButton.setAttributedTitle(Roomtext, for: UIControl.State.normal)
                                RoomButton.tintColor = UIColor.black
                                RoomButton.backgroundColor = UIColor.white
                                RoomButton.tag = i
                                i += 1
                                RoomButton.addTarget(self, action: #selector(self.RoomButtonPressed), for: UIControl.Event.touchUpInside)
                               // self.roomScrollView.addSubview(RoomButton)
                                self.buttons.append(RoomButton)
                               
                              //  RoomButton.translatesAutoresizingMaskIntoConstraints = true
                               // RoomButton.topAnchor.constraint(equalTo: self.roomScrollView.topAnchor, constant: 10000).isActive =  true
                              //  RoomButton.bottomAnchor.constraint(equalTo: self.roomScrollView.bottomAnchor, constant: -16).isActive = true
                                
                                if isMod % 2 != 0{
                                    buttonX += 200
                                }else{
                                    buttonY += 110
                                    buttonX = 0
                                }
                                isMod += 1
                               
                            }
                            
                            
                            
                            
                            
                        }
                    
                    }
                    
                                        DispatchQueue.main.async {
                    
                    for button in self.buttons{
                        
                       // button.addTarget(self, action: #selector(self.RoomButtonPressed), for: UIControl.Event.touchUpInside)
                       // button.frame.origin.y += 100
                       // button.translatesAutoresizingMaskIntoConstraints = false
                        self.roomScrollView.addSubview(button)
                        button.topAnchor.constraint(equalTo: self.roomScrollView.topAnchor, constant: 1000).isActive = true
                        button.bottomAnchor.constraint(equalTo: self.roomScrollView.bottomAnchor, constant: -1000).isActive = true
                        
                        
                    }
                    }
                    
                
                    
                    
                    
                }
                
            }
            
        }
        task.resume()
            
            
            
}
    
    
    
    
    @objc func RoomButtonPressed(sender:UIButton!){
        var weGotData = ""
       let pattern = "\n.*"
        let text = sender.titleLabel?.text as! String
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let modText = regex.stringByReplacingMatches(in: text, options: [], range: NSRange(location: 0, length: text.count), withTemplate: "") as NSString
        
        let attString = NSMutableAttributedString(string: modText as String)
        let roomname = attString.string
        
        let thisroomArray: Array = self.roomArray
        for r in thisroomArray{
            let thisPattern = "\(roomname).*[0-9]"
            let thisRegex = try! NSRegularExpression(pattern: thisPattern, options: [])
            let thisMatches = thisRegex.matches(in: r, options: [], range: NSRange(location: 0, length: r.count))
            if thisMatches != []{
                weGotData = r
            }
        }
        
        let patternAgain = "\(roomname):"
        let regexAgain = try! NSRegularExpression(pattern: patternAgain, options: [])
        let modTextAgain = regexAgain.stringByReplacingMatches(in: weGotData, options: [], range: NSRange(location: 0, length: weGotData.count), withTemplate: "") as NSString
        let attStringAgain = NSMutableAttributedString(string: modTextAgain as String)
        let roomid = attStringAgain.string

        DispatchQueue.main.async {
            let remoteViewController = self.storyboard?.instantiateViewController(withIdentifier: "RemoteViewController") as! RemoteViewController
            remoteViewController.roomName = roomname
            remoteViewController.roomId = roomid
            remoteViewController.token = self.token
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = remoteViewController
        }
        
        
    }
    
    
    
    


}
