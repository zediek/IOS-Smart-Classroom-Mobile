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
    let device_status: String
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
        guard let device_status = jsonDevice["device_status"] as? String else { throw DeviceError.deviceMissing("device_status is missing") }
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

struct justAnotherStruct{
    let room_name:String
    let aircon:Bool
    let aircon_id: Int
    let aircon_status_id: Int
    let temperature: Int
    let temperature_id: Int
    let temperature_status_id: Int
    let door: Bool
    let door_id: Int
    let door_status_id: Int
    let lights: Bool
    let lights_id: Int
    let lights_status_id: Int
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var roomScrollView: UIScrollView!
    
    var refresher: UIRefreshControl!
    
    var buttons = [UIButton]()
    
    var roomArray = [String]()
    
    var justAnotherArray = [justAnotherStruct]()
    
    
    var usertype: String = ""
    var token: String = ""
    
    var roomName: String = ""
    var airconStatus:String = ""
    var airconId:Int = 0
    var tempStatus: Int = 0
    var tempId: Int = 0
    var lightsStatus: String = ""
    var lightsId: Int = 0
    var doorStatus: String = ""
    var doorId: Int = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGray
        self.searchView.frame = CGRect(x: 20, y: 100, width: (Int(UIScreen.main.bounds.width) - 40), height: 60)
        self.stackView.frame = CGRect(x: 10, y: 5, width: (Int(UIScreen.main.bounds.width) - 58), height: 50)
        self.stackView.backgroundColor = UIColor.white
        createRoomArray()
        //createRoomButton()
        
        self.roomScrollView.addSubview(refresher)

        // Do any additional setup after loading the view.
    }
    
    
    
    @objc func populate(){
        refresher.endRefreshing()
        DispatchQueue.main.async {
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            homeViewController.usertype = self.usertype
            homeViewController.token = self.token
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = homeViewController
        }
    }
    

    @IBAction func searchIsSearch(_ sender: UITextField) {
        buttons.removeAll()
        justAnotherArray.removeAll()
        let subViews = self.roomScrollView.subviews
        for subView in subViews{
            subView.removeFromSuperview()
        }
        if sender.text == ""{
            DispatchQueue.main.async {
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                homeViewController.usertype = self.usertype
                homeViewController.token = self.token
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = homeViewController
            }
        }else{
            buttons.removeAll()
            justAnotherArray.removeAll()
            
            refresher = UIRefreshControl()
            refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refresher.addTarget(self, action: #selector(self.populate), for:  UIControl.Event.valueChanged)
            self.roomScrollView.addSubview(refresher)
            
            
            self.roomScrollView.translatesAutoresizingMaskIntoConstraints = false
            
            self.roomScrollView.topAnchor.constraint(equalTo: self.roomScrollView.topAnchor, constant: 1000).isActive = true
            self.roomScrollView.bottomAnchor.constraint(equalTo: self.roomScrollView.bottomAnchor, constant: -16).isActive = true
            
           
            
            var repeat_name: String = ""
            
            var weGotData: String = ""
            
            for get_array in self.roomArray{
                let thisPattern = ".*\(sender.text!).*,"
                let thisRegex = try! NSRegularExpression(pattern: thisPattern, options: [])
                let thisMatches = thisRegex.matches(in: get_array, options: [], range: NSRange(location: 0, length: get_array.count))
                if thisMatches != []{
                    weGotData = get_array
                    //print(weGotData)
                    
                    
                    let pattern = ",.*[{]\n.*"
                    
                    let text = weGotData
                    let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
                    let modText = regex.stringByReplacingMatches(in: text, options: [], range: NSRange(location: 0, length: text.count), withTemplate: "") as NSString
                    
                    let attString = NSMutableAttributedString(string: modText as String)
                    let x = attString.string
                    
                    let pattern0 = ".*=.*;\n.*\n"
                    
                    let text0 = x
                    let regex0 = try! NSRegularExpression(pattern: pattern0, options: .caseInsensitive)
                    let modText0 = regex0.stringByReplacingMatches(in: text0, options: [], range: NSRange(location: 0, length: text0.count), withTemplate: "") as NSString
                    
                    let attString0 = NSMutableAttributedString(string: modText0 as String)
                    let x0 = attString0.string
                    //print(x0)
                    
                    
                    let pattern01 = "\n.*[}].*"
                    
                    let text01 = x0
                    let regex01 = try! NSRegularExpression(pattern: pattern01, options: .caseInsensitive)
                    let modText01 = regex01.stringByReplacingMatches(in: text01, options: [], range: NSRange(location: 0, length: text01.count), withTemplate: "") as NSString
                    
                    let attString01 = NSMutableAttributedString(string: modText01 as String)
                    let x01 = attString01.string
                    print(x01)
                    
                    let room_name = x01
                    
                    
                    let pattern1 = ".*\(sender.text!).*,"
                    let text1 = String(weGotData)
                    let regex1 = try! NSRegularExpression(pattern: pattern1, options: .caseInsensitive)
                    let modText1 = regex1.stringByReplacingMatches(in: text1, options: [], range: NSRange(location: 0, length: text1.count), withTemplate: "") as NSString
                    
                    let attString1 = NSMutableAttributedString(string: modText1 as String)
                    
                    let thisisit = attString1.string
                    //print(thisisit)
                    //print("############################")
                    
                    
                    let pattern2 = ".*class_name.*;"
                    
                    let text2 = thisisit
                    let regex2 = try! NSRegularExpression(pattern: pattern2, options: .caseInsensitive)
                    let modText2 = regex2.stringByReplacingMatches(in: text2, options: [], range: NSRange(location: 0, length: text2.count), withTemplate: "") as NSString
                    
                    let attString2 = NSMutableAttributedString(string: modText2 as String)
                    let s = attString2.string
                    // print(s)
                    // print("dddddddddsddddddddddddddfg3###########")
                    
                    
                    let pattern3 = ".*,.*\n" as String
                    
                    let text3 = s
                    let regex3 = try! NSRegularExpression(pattern: pattern3, options: .caseInsensitive)
                    let modText3 = regex3.stringByReplacingMatches(in: text3, options: [], range: NSRange(location: 0, length: text3.count), withTemplate: "") as NSString
                    
                    let attString3 = NSMutableAttributedString(string: modText3 as String)
                    let s2 = attString3.string
                    //print(s2)
                    
                    
                    let pattern4 = ".*[}].*" as String
                    
                    let text4 = s2
                    let regex4 = try! NSRegularExpression(pattern: pattern4, options: .caseInsensitive)
                    let modText4 = regex4.stringByReplacingMatches(in: text4, options: [], range: NSRange(location: 0, length: text4.count), withTemplate: "") as NSString
                    
                    let attString4 = NSMutableAttributedString(string: modText4 as String)
                    let s3 = attString4.string
                    //print(s3)
                    
                    let pattern5 = "\n" as String
                    
                    let text5 = s3
                    let regex5 = try! NSRegularExpression(pattern: pattern5, options: .caseInsensitive)
                    let modText5 = regex5.stringByReplacingMatches(in: text5, options: [], range: NSRange(location: 0, length: text5.count), withTemplate: "") as NSString
                    
                    let attString5 = NSMutableAttributedString(string: modText5 as String)
                    let s4 = attString5.string
                    //print(s4)
                    
                    let pattern6 = "    " as String
                    
                    let text6 = s4
                    let regex6 = try! NSRegularExpression(pattern: pattern6, options: .caseInsensitive)
                    let modText6 = regex6.stringByReplacingMatches(in: text6, options: [], range: NSRange(location: 0, length: text6.count), withTemplate: "") as NSString
                    
                    let attString6 = NSMutableAttributedString(string: modText6 as String)
                    let s5 = attString6.string
                    //print(s5)
                    
                    
                    
                    
                    let pattern7 = "=" as String
                    
                    let text7 = s5
                    let regex7 = try! NSRegularExpression(pattern: pattern7, options: .caseInsensitive)
                    let modText7 = regex7.stringByReplacingMatches(in: text7, options: [], range: NSRange(location: 0, length: text7.count), withTemplate: ":") as NSString
                    
                    let attString7 = NSMutableAttributedString(string: modText7 as String)
                    let s6 = attString7.string
                    //print(s6)
                    
                    let thisData = s6.split(separator: ";")
                    
                    var device_id = [String]()
                    var device_status = [String]()
                    var room_status_id = [String]()
                    
                    for thisArrayData in thisData{
                        
                        let thisPattern1 = ".*device_id.*"
                        let thisRegex1 = try! NSRegularExpression(pattern: thisPattern1, options: [])
                        let thisMatches1 = thisRegex1.matches(in: String(thisArrayData), options: [], range: NSRange(location: 0, length: thisArrayData.count))
                        if thisMatches1 != []{
                            device_id.append(String(thisArrayData))
                        }
                        
                        
                        let thisPattern2 = ".*device_status.*"
                        let thisRegex2 = try! NSRegularExpression(pattern: thisPattern2, options: [])
                        let thisMatches2 = thisRegex2.matches(in: String(thisArrayData), options: [], range: NSRange(location: 0, length: thisArrayData.count))
                        if thisMatches2 != []{
                            device_status.append(String(thisArrayData))
                        }
                        
                        
                        let thisPattern3 = ".*room_status_id.*"
                        let thisRegex3 = try! NSRegularExpression(pattern: thisPattern3, options: [])
                        let thisMatches3 = thisRegex3.matches(in: String(thisArrayData), options: [], range: NSRange(location: 0, length: thisArrayData.count))
                        if thisMatches3 != []{
                            room_status_id.append(String(thisArrayData))
                        }
                       // print(device_status)
                    }
                    print(device_status[0])
                    print(device_id[0])
                    
                    let device_status_paturn = ".*device_status.*: "
                    
                    let device_status_text = device_status[0]
                    let device_status_regex = try! NSRegularExpression(pattern: device_status_paturn, options: .caseInsensitive)
                    let device_status_modText = device_status_regex.stringByReplacingMatches(in: device_status_text, options: [], range: NSRange(location: 0, length: device_status_text.count), withTemplate: "") as NSString
                    
                    let device_status_attString = NSMutableAttributedString(string: device_status_modText as String)
                    let device_status_s = device_status_attString.string
                    //print(device_status_s)
                    
                    
                    let device_status_paturn1 = ".*device_status.*: "
                    
                    let device_status_text1 = device_status[1]
                    let device_status_regex1 = try! NSRegularExpression(pattern: device_status_paturn1, options: .caseInsensitive)
                    let device_status_modText1 = device_status_regex1.stringByReplacingMatches(in: device_status_text1, options: [], range: NSRange(location: 0, length: device_status_text1.count), withTemplate: "") as NSString
                    
                    let device_status_attString1 = NSMutableAttributedString(string: device_status_modText1 as String)
                    let device_status_s1 = device_status_attString1.string
                    //print(device_status_s1)
                    
                    
                    let device_status_paturn2 = ".*device_status.*: "
                    
                    let device_status_text2 = device_status[2]
                    let device_status_regex2 = try! NSRegularExpression(pattern: device_status_paturn2, options: .caseInsensitive)
                    let device_status_modText2 = device_status_regex2.stringByReplacingMatches(in: device_status_text2, options: [], range: NSRange(location: 0, length: device_status_text2.count), withTemplate: "") as NSString
                    
                    let device_status_attString2 = NSMutableAttributedString(string: device_status_modText2 as String)
                    let device_status_s2 = device_status_attString2.string
                   // print(device_status_s2)
                    
                    let device_status_paturn3 = ".*device_status.*: "
                    
                    let device_status_text3 = device_status[3]
                    let device_status_regex3 = try! NSRegularExpression(pattern: device_status_paturn3, options: .caseInsensitive)
                    let device_status_modText3 = device_status_regex3.stringByReplacingMatches(in: device_status_text3, options: [], range: NSRange(location: 0, length: device_status_text3.count), withTemplate: "") as NSString
                    
                    let device_status_attString3 = NSMutableAttributedString(string: device_status_modText3 as String)
                    let device_status_s3 = device_status_attString3.string
                    // print(device_status_s3)
                    
                    
                    let device_id_paturn = ".*device_id.*: "
                    
                    let device_id_text = device_id[0]
                    let device_id_regex = try! NSRegularExpression(pattern: device_id_paturn, options: .caseInsensitive)
                    let device_id_modText = device_id_regex.stringByReplacingMatches(in: device_id_text, options: [], range: NSRange(location: 0, length: device_id_text.count), withTemplate: "") as NSString
                    
                    let device_id_attString = NSMutableAttributedString(string: device_id_modText as String)
                    let device_id_s = device_id_attString.string
                    //print(device_id_s)
                    
                    
                    let device_id_paturn1 = ".*device_id.*: "
                    
                    let device_id_text1 = device_id[1]
                    let device_id_regex1 = try! NSRegularExpression(pattern: device_id_paturn1, options: .caseInsensitive)
                    let device_id_modText1 = device_id_regex1.stringByReplacingMatches(in: device_id_text1, options: [], range: NSRange(location: 0, length: device_id_text1.count), withTemplate: "") as NSString
                    
                    let device_id_attString1 = NSMutableAttributedString(string: device_id_modText1 as String)
                    let device_id_s1 = device_id_attString1.string
                    //print(device_id_s1)
                    
                    let device_id_paturn2 = ".*device_id.*: "
                    
                    let device_id_text2 = device_id[2]
                    let device_id_regex2 = try! NSRegularExpression(pattern: device_id_paturn2, options: .caseInsensitive)
                    let device_id_modText2 = device_id_regex2.stringByReplacingMatches(in: device_id_text2, options: [], range: NSRange(location: 0, length: device_id_text2.count), withTemplate: "") as NSString
                    
                    let device_id_attString2 = NSMutableAttributedString(string: device_id_modText2 as String)
                    let device_id_s2 = device_id_attString2.string
                    //print(device_id_s2)
                    
                    let device_id_paturn3 = ".*device_id.*: "
                    
                    let device_id_text3 = device_id[3]
                    let device_id_regex3 = try! NSRegularExpression(pattern: device_id_paturn3, options: .caseInsensitive)
                    let device_id_modText3 = device_id_regex3.stringByReplacingMatches(in: device_id_text3, options: [], range: NSRange(location: 0, length: device_id_text3.count), withTemplate: "") as NSString
                    
                    let device_id_attString3 = NSMutableAttributedString(string: device_id_modText3 as String)
                    let device_id_s3 = device_id_attString3.string
                    //print(device_id_s3)
                    
                    
                    let room_status_id_paturn = ".*room_status_id.*: "
                    
                    let room_status_id_text = room_status_id[0]
                    let room_status_id_regex = try! NSRegularExpression(pattern: room_status_id_paturn, options: .caseInsensitive)
                    let room_status_id_modText = room_status_id_regex.stringByReplacingMatches(in: room_status_id_text, options: [], range: NSRange(location: 0, length: room_status_id_text.count), withTemplate: "") as NSString
                    
                    let room_status_id_attString = NSMutableAttributedString(string: room_status_id_modText as String)
                    let room_status_id_s = room_status_id_attString.string
                    //print(room_status_id_s)
                    
                    
                    let room_status_id_paturn1 = ".*room_status_id.*: "
                    
                    let room_status_id_text1 = room_status_id[1]
                    let room_status_id_regex1 = try! NSRegularExpression(pattern: room_status_id_paturn1, options: .caseInsensitive)
                    let room_status_id_modText1 = room_status_id_regex1.stringByReplacingMatches(in: room_status_id_text1, options: [], range: NSRange(location: 0, length: room_status_id_text1.count), withTemplate: "") as NSString
                    
                    let room_status_id_attString1 = NSMutableAttributedString(string: room_status_id_modText1 as String)
                    let room_status_id_s1 = room_status_id_attString1.string
                    //print(room_status_id_s1)
                    
                    
                    let room_status_id_paturn2 = ".*room_status_id.*: "
                    
                    let room_status_id_text2 = room_status_id[2]
                    let room_status_id_regex2 = try! NSRegularExpression(pattern: room_status_id_paturn2, options: .caseInsensitive)
                    let room_status_id_modText2 = room_status_id_regex2.stringByReplacingMatches(in: room_status_id_text2, options: [], range: NSRange(location: 0, length: room_status_id_text2.count), withTemplate: "") as NSString
                    
                    let room_status_id_attString2 = NSMutableAttributedString(string: room_status_id_modText2 as String)
                    let room_status_id_s2 = room_status_id_attString2.string
                    //print(room_status_id_s2)
                    
                    
                    
                    
                    let room_status_id_paturn3 = ".*room_status_id.*: "
                    
                    let room_status_id_text3 = room_status_id[3]
                    let room_status_id_regex3 = try! NSRegularExpression(pattern: room_status_id_paturn3, options: .caseInsensitive)
                    let room_status_id_modText3 = room_status_id_regex3.stringByReplacingMatches(in: room_status_id_text3, options: [], range: NSRange(location: 0, length: room_status_id_text3.count), withTemplate: "") as NSString
                    
                    let room_status_id_attString3 = NSMutableAttributedString(string: room_status_id_modText3 as String)
                    let room_status_id_s3 = room_status_id_attString3.string
                    //print(room_status_id_s3)
                    
                    
                    
                    
                    let aircon = Bool(device_status_s)
                    let aircon_id = Int(device_id_s)
                    let aircon_status_id = Int(room_status_id_s)
                    
                    let temperature = Int(device_status_s1)
                    let temperature_id = Int(device_id_s1)
                    let temperature_status_id = Int(room_status_id_s1)
                    
                    let door = Bool(device_status_s2)
                    let door_id = Int(device_id_s2)
                    let door_status_id = Int(room_status_id_s2)
                    
                    let lights = Bool(device_status_s3)
                    let lights_id = Int(device_id_s3)
                    let light_status_id = Int(room_status_id_s3)
                    print(aircon as Any)
                    print(temperature as Any)
                    print(door as Any)
                    print(lights as Any)
                    if aircon == true{
                        self.airconStatus = "on"
                    }else{
                        self.airconStatus = "off"
                    }
                    self.tempStatus = temperature!
                    if door == true {
                        self.doorStatus = "on"
                    }else{
                        self.doorStatus = "off"
                    }
                    if lights == true {
                        self.lightsStatus = "on"
                    }else{
                        self.lightsStatus = "off"
                    }
                    
                    if repeat_name != room_name{
                        repeat_name = room_name
                        self.justAnotherArray.append(justAnotherStruct(room_name: room_name, aircon: aircon!, aircon_id: aircon_id!, aircon_status_id: aircon_status_id!, temperature: temperature!, temperature_id: temperature_id!, temperature_status_id: temperature_status_id!, door: door!, door_id: door_id!, door_status_id: door_status_id!, lights: lights!, lights_id: lights_id!, lights_status_id: light_status_id!))
                    }
                }
                
                }
       
            var i = 300
            var buttonX = 0
            var buttonY = 0
            var isMod = 1
            
            for data in justAnotherArray{
                DispatchQueue.main.async {
                    let screemSize: CGRect = UIScreen.main.bounds
                    //  print("Screen width size: \(screemSize.width)")
                    let halfScreenSize = (screemSize.width / 2) - 17
                    //  print("Half screen width size: \(halfScreenSize)")
                    //  print(JD.room_name)
                    let RoomButton = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: Int(halfScreenSize), height: 100))
                    RoomButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                    if data.aircon == false{
                        self.airconStatus = "on"
                    }else{
                        self.airconStatus = "off"
                    }
                    self.tempStatus = data.temperature
                    if data.lights == false{
                        self.lightsStatus = "on"
                    }else{
                        self.lightsStatus = "off"
                    }
                    let Roomtext = NSAttributedString(string: "\(data.room_name)\nAircon           \(self.airconStatus)\nTemp           \(self.tempStatus)°C\nLights           \(self.lightsStatus)")
                    RoomButton.setAttributedTitle(Roomtext, for: UIControl.State.normal)
                    RoomButton.tintColor = UIColor.black
                    RoomButton.titleLabel?.font = UIFont(name: "Arial", size: 14)
                    RoomButton.backgroundColor = UIColor.white
                    RoomButton.tag = i
                    i += 1
                    
                    RoomButton.addTarget(self, action: #selector(self.RoomButtonPressed1), for: UIControl.Event.touchUpInside)
                    // self.roomScrollView.addSubview(RoomButton)
                    self.buttons.append(RoomButton)
                    
                    //  RoomButton.translatesAutoresizingMaskIntoConstraints = true
                    // RoomButton.topAnchor.constraint(equalTo: self.roomScrollView.topAnchor, constant: 10000).isActive =  true
                    //  RoomButton.bottomAnchor.constraint(equalTo: self.roomScrollView.bottomAnchor, constant: -16).isActive = true
                    
                    if isMod % 2 != 0{
                        buttonX += Int(halfScreenSize) + 10
                    }else{
                        buttonY += 110
                        buttonX = 0
                    }
                    isMod += 1
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
        
        justAnotherArray.removeAll()
        buttons.removeAll()
       
        
    }
    
    @objc func RoomButtonPressed1(sender: UIButton){
        //print(self.justAnotherArray[0])
        
        let pattern = "\n.*"
        
        let text = sender.titleLabel?.text
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let modText = regex.stringByReplacingMatches(in: text!, options: [], range: NSRange(location: 0, length: text!.count), withTemplate: "") as NSString
        
        let attString = NSMutableAttributedString(string: modText as String)
        let roomname = attString.string
        
        for data in self.justAnotherArray{
            if roomname == data.room_name{
                DispatchQueue.main.async {
                    let remoteViewController = self.storyboard?.instantiateViewController(withIdentifier: "RemoteViewController") as! RemoteViewController
                    remoteViewController.roomName = data.room_name
                    remoteViewController.token = self.token
                    remoteViewController.usertype = self.usertype
                    remoteViewController.airconStatus = data.aircon
                    remoteViewController.airconId = data.aircon_id
                    remoteViewController.airconStatusId = data.aircon_status_id
                    remoteViewController.tempStatus = data.temperature
                    remoteViewController.tempId = data.temperature_id
                    remoteViewController.tempStatusId = data.temperature_status_id
                    remoteViewController.doorStatus = data.door
                    remoteViewController.doorId = data.door_id
                    remoteViewController.doorStatusId = data.door_status_id
                    remoteViewController.lightsStatus = data.lights
                    remoteViewController.lightsId = data.lights_id
                    remoteViewController.lightsStatusId = data.lights_status_id
                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = remoteViewController
                }
            }
        }
    }
    

    
    func createRoomArray(){
        
        buttons.removeAll()
        let subViews = self.roomScrollView.subviews
        for subView in subViews{
            subView.removeFromSuperview()
        }
        
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(self.populate), for:  UIControl.Event.valueChanged)
        self.roomScrollView.addSubview(refresher)
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
                                        print(JSONDEVICE.device_id)
                                        print("seqwerdasdasdasda")
                                        
                                        switch(JSONDEVICE.device_name){
                                            case "Aircon":
                                                self.airconId = JSONDEVICE.device_id
                                                
                                                print(self.airconId)
                                                let airconBool = Bool(JSONDEVICE.device_status)
                                                    if airconBool == true{
                                                        self.airconStatus = "on"
                                                    }else{
                                                        self.airconStatus = "off"
                                                    }
                                            break
                                        case "Aircon temperature":
                                            self.tempId = JSONDEVICE.device_id
                                            
                                            print(self.tempId)
                                                self.tempStatus = Int(JSONDEVICE.device_status)!
                                        break
                                        case "Lights":
                                            self.lightsId = JSONDEVICE.device_id
                                            print(self.lightsId)
                                            let lightsBool = Bool(JSONDEVICE.device_status)
                                                if lightsBool == true{
                                                    self.lightsStatus = "on"
                                                }else{
                                                    self.lightsStatus = "off"
                                                }
                                        break
                                        case "Door":
                                            self.doorId = JSONDEVICE.device_id
                                            
                                            print(self.doorId)
                                            let doorBool = Bool(JSONDEVICE.device_status)
                                                if doorBool == true{
                                                    self.doorStatus = "on"
                                                }else{
                                                    self.doorStatus = "off"
                                                }
                                        default:
                                            print("Wala ra")
                                        }
                                    }
                                 
                                }
                                print(JD)
                                print("#############################")
                            }
                            
                            DispatchQueue.main.async {
                                let screemSize: CGRect = UIScreen.main.bounds
                                print("Screen width size: \(screemSize.width)")
                                let halfScreenSize = (screemSize.width / 2) - 17
                                print("Half screen width size: \(halfScreenSize)")
                                
                              //  print(JD.room_name)
                                let RoomButton = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: Int(halfScreenSize), height: 100))
                                RoomButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                                let Roomtext = NSAttributedString(string: "\(JD.room_name)\nAircon           \(self.airconStatus)\nTemp           \(self.tempStatus)°C\nLights           \(self.lightsStatus)")
                                RoomButton.setAttributedTitle(Roomtext, for: UIControl.State.normal)
                                RoomButton.tintColor = UIColor.black
                                RoomButton.titleLabel?.font = UIFont(name: "Arial", size: 14)
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
                                    buttonX += Int(halfScreenSize) + 10
                                }else{
                                    buttonY += 110
                                    buttonX = 0
                                }
                                isMod += 1
                                
                                self.roomArray.append({"\(JD.room_name),\(JD.devices)"}())
                               
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
        
        let pattern = "\n.*"
        
        let text = sender.titleLabel?.text
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let modText = regex.stringByReplacingMatches(in: text!, options: [], range: NSRange(location: 0, length: text!.count), withTemplate: "") as NSString
        
        let attString = NSMutableAttributedString(string: modText as String)
        let roomname = attString.string
        //print(roomname)
        
        var weGotData: String = ""
        for get_array in self.roomArray{
            let thisPattern = "\(roomname),.*"
            let thisRegex = try! NSRegularExpression(pattern: thisPattern, options: [])
            let thisMatches = thisRegex.matches(in: get_array, options: [], range: NSRange(location: 0, length: get_array.count))
            if thisMatches != []{
                weGotData = get_array
            }
        }
        
       // print(weGotData)
        let pattern1 = "\(roomname).*"
        let text1 = String(weGotData)
        let regex1 = try! NSRegularExpression(pattern: pattern1, options: .caseInsensitive)
        let modText1 = regex1.stringByReplacingMatches(in: text1, options: [], range: NSRange(location: 0, length: text1.count), withTemplate: "") as NSString
        
        let attString1 = NSMutableAttributedString(string: modText1 as String)
        
        let thisisit = attString1.string
        //print(thisisit)
        //print("############################")
        
        
        let pattern2 = ".*class_name.*;"
        
        let text2 = thisisit
        let regex2 = try! NSRegularExpression(pattern: pattern2, options: .caseInsensitive)
        let modText2 = regex2.stringByReplacingMatches(in: text2, options: [], range: NSRange(location: 0, length: text2.count), withTemplate: "") as NSString
        
        let attString2 = NSMutableAttributedString(string: modText2 as String)
        let s = attString2.string
       // print(s)
       // print("dddddddddsddddddddddddddfg3###########")
        
        
        let pattern3 = ".*,.*\n" as String
        
        let text3 = s
        let regex3 = try! NSRegularExpression(pattern: pattern3, options: .caseInsensitive)
        let modText3 = regex3.stringByReplacingMatches(in: text3, options: [], range: NSRange(location: 0, length: text3.count), withTemplate: "") as NSString
        
        let attString3 = NSMutableAttributedString(string: modText3 as String)
        let s2 = attString3.string
        //print(s2)
       
        
        let pattern4 = ".*[}].*" as String
        
        let text4 = s2
        let regex4 = try! NSRegularExpression(pattern: pattern4, options: .caseInsensitive)
        let modText4 = regex4.stringByReplacingMatches(in: text4, options: [], range: NSRange(location: 0, length: text4.count), withTemplate: "") as NSString
        
        let attString4 = NSMutableAttributedString(string: modText4 as String)
        let s3 = attString4.string
        //print(s3)
        
        let pattern5 = "\n" as String
        
        let text5 = s3
        let regex5 = try! NSRegularExpression(pattern: pattern5, options: .caseInsensitive)
        let modText5 = regex5.stringByReplacingMatches(in: text5, options: [], range: NSRange(location: 0, length: text5.count), withTemplate: "") as NSString
        
        let attString5 = NSMutableAttributedString(string: modText5 as String)
        let s4 = attString5.string
        //print(s4)
        
        let pattern6 = "    " as String
        
        let text6 = s4
        let regex6 = try! NSRegularExpression(pattern: pattern6, options: .caseInsensitive)
        let modText6 = regex6.stringByReplacingMatches(in: text6, options: [], range: NSRange(location: 0, length: text6.count), withTemplate: "") as NSString
        
        let attString6 = NSMutableAttributedString(string: modText6 as String)
        let s5 = attString6.string
        //print(s5)
        
        
        
        
        let pattern7 = "=" as String
        
        let text7 = s5
        let regex7 = try! NSRegularExpression(pattern: pattern7, options: .caseInsensitive)
        let modText7 = regex7.stringByReplacingMatches(in: text7, options: [], range: NSRange(location: 0, length: text7.count), withTemplate: ":") as NSString
        
        let attString7 = NSMutableAttributedString(string: modText7 as String)
        let s6 = attString7.string
        //print(s6)
        
        let thisData = s6.split(separator: ";")
        
        var device_id = [String]()
        var device_status = [String]()
        var room_status_id = [String]()
        
        for thisArrayData in thisData{
            
            let thisPattern1 = ".*device_id.*"
            let thisRegex1 = try! NSRegularExpression(pattern: thisPattern1, options: [])
            let thisMatches1 = thisRegex1.matches(in: String(thisArrayData), options: [], range: NSRange(location: 0, length: thisArrayData.count))
            if thisMatches1 != []{
                device_id.append(String(thisArrayData))
            }
            
            
            let thisPattern2 = ".*device_status.*"
            let thisRegex2 = try! NSRegularExpression(pattern: thisPattern2, options: [])
            let thisMatches2 = thisRegex2.matches(in: String(thisArrayData), options: [], range: NSRange(location: 0, length: thisArrayData.count))
            if thisMatches2 != []{
                device_status.append(String(thisArrayData))
            }
            
            
            let thisPattern3 = ".*room_status_id.*"
            let thisRegex3 = try! NSRegularExpression(pattern: thisPattern3, options: [])
            let thisMatches3 = thisRegex3.matches(in: String(thisArrayData), options: [], range: NSRange(location: 0, length: thisArrayData.count))
            if thisMatches3 != []{
                room_status_id.append(String(thisArrayData))
            }
            
            
        }
        //print(roomname)
        //print(device_name[0])
        //print(device_id[0])
        //print(device_status[0])
        //print(room_status_id[0])
        
        
        var device_id1 = [String]()
        var device_status1 = [String]()
        var room_status_id1 = [String]()
        
        
        for device_id_array in device_id{
            let pattern = "\"device_id\" : " as String
            
            let text = device_id_array
            let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let modText = regex.stringByReplacingMatches(in: text, options: [], range: NSRange(location: 0, length: text.count), withTemplate: "") as NSString
            
            let attString = NSMutableAttributedString(string: modText as String)
            device_id1.append(attString.string)
        }
        
        
        for device_status_array in device_status{
            let pattern = "\"device_status\" : " as String
            
            let text = device_status_array
            let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let modText = regex.stringByReplacingMatches(in: text, options: [], range: NSRange(location: 0, length: text.count), withTemplate: "") as NSString
            
            let attString = NSMutableAttributedString(string: modText as String)
            device_status1.append(attString.string)
        }
        
        for room_status_id_array in room_status_id{
            let pattern = "\"room_status_id\" : " as String
            
            let text = room_status_id_array
            let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let modText = regex.stringByReplacingMatches(in: text, options: [], range: NSRange(location: 0, length: text.count), withTemplate: "") as NSString
            
            let attString = NSMutableAttributedString(string: modText as String)
           room_status_id1.append(attString.string)
        }
        
        
        
        
        /*
         
         let patternAgain = "DORM 306"
         let regexAgain = try! NSRegularExpression(pattern: patternAgain, options: [])
         let modTextAgain = regexAgain.stringByReplacingMatches(in: get_array, options: [], range: NSRange(location: 0, length: get_array.count), withTemplate: "") as NSString
         let attStringAgain = NSMutableAttributedString(string: modTextAgain as String)
         
         let asSplitArray = attStringAgain.string.components(separatedBy: ",")
         print(asSplitArray)
         
         */
        
        
        //   var weGotData = ""
        //  let pattern = "\n.*"
        
        /*
        
        print(roomname)
        
        let thisroomArray: Array = self.roomArray
        for r in thisroomArray{
         
        }
 */
         
        let aircon = Bool(device_status1[0])
        let aircon_id = Int(device_id1[0])
        let aircon_status_id = Int(room_status_id1[0])
        
        let temperature = Int(device_status1[1])
        let temperature_id = Int(device_id1[1])
        let temperature_status_id = Int(room_status_id1[1])
        
        let door = Bool(device_status1[2])
        let door_id = Int(device_id1[2])
        let door_status_id = Int(room_status_id1[2])
        
        let lights = Bool(device_status1[3])
        let lights_id = Int(device_id1[3])
        let light_status_id = Int(room_status_id1[3])
        
        
        
        
        
        //print(roomid)
        
        DispatchQueue.main.async {
            let remoteViewController = self.storyboard?.instantiateViewController(withIdentifier: "RemoteViewController") as! RemoteViewController
            remoteViewController.roomName = roomname
            remoteViewController.token = self.token
            remoteViewController.usertype = self.usertype
            remoteViewController.airconStatus = aircon!
            remoteViewController.airconId = aircon_id!
            remoteViewController.airconStatusId = aircon_status_id! 
            remoteViewController.tempStatus = temperature!
            remoteViewController.tempId = temperature_id!
            remoteViewController.tempStatusId = temperature_status_id!
            remoteViewController.lightsStatus = lights!
            remoteViewController.lightsId = lights_id!
            remoteViewController.lightsStatusId = light_status_id!
            remoteViewController.doorStatus = door!
            remoteViewController.doorId = door_id!
            remoteViewController.doorStatusId = door_status_id!
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = remoteViewController
        }


    }
    
    
    
    
    
    

    @IBAction func logout(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = loginViewController
        }
    }
    

    
}
