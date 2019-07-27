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
    var airconId:Int = 0
    var tempStatus: String = ""
    var tempId: Int = 0
    var lightsStatus: String = ""
    var lightsId: Int = 0
    var doorStatus: String = ""
    var doorId: Int = 0
    
    
    
    
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
                                        print(JSONDEVICE.device_id)
                                        print("seqwerdasdasdasda")
                                        
                                        switch(JSONDEVICE.device_name){
                                            case "Aircon":
                                                self.airconId = JSONDEVICE.device_id
                                                
                                                print(self.airconId)
                                                if let airconBool = try? JSONDEVICE.device_status as? String{
                                                    if airconBool == "true"{
                                                        self.airconStatus = "on"
                                                    }else{
                                                        self.airconStatus = "off"
                                                    }
                                                }
                                            break
                                        case "Aircon temperature":
                                            self.tempId = JSONDEVICE.device_id
                                            
                                            print(self.tempId)
                                            self.tempStatus = JSONDEVICE.device_status as! String
                                        break
                                        case "Lights":
                                            self.lightsId = JSONDEVICE.device_id
                                            print(self.lightsId)
                                            if let lightsBool = try? JSONDEVICE.device_status as? String{
                                                if lightsBool == "true"{
                                                    self.lightsStatus = "on"
                                                }else{
                                                    self.lightsStatus = "off"
                                                }
                                                
                                            }
                                        break
                                        case "Door":
                                            self.doorId = JSONDEVICE.device_id
                                            
                                            print(self.doorId)
                                            if let doorBool = try? JSONDEVICE.device_status as? String{
                                                if doorBool == "true"{
                                                    self.doorStatus = "on"
                                                }else{
                                                    self.doorStatus = "off"
                                                }
                                            }
                                        default:
                                            let temp = "Wala ra"
                                        }
                                    }
                                 
                                }
                                print(JD)
                                print("#############################")
                            }
                            
                            DispatchQueue.main.async {
                                
                              //  print(JD.room_name)
                                let RoomButton = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: 190, height: 100))
                                RoomButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                                var Roomtext = NSAttributedString(string: "\(JD.room_name)\nAircon           \(self.airconStatus)\nTemp           \(self.tempStatus)°C\nLights           \(self.lightsStatus)")
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
                                    buttonX += 200
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
        
        let text = sender.titleLabel?.text as! String
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let modText = regex.stringByReplacingMatches(in: text, options: [], range: NSRange(location: 0, length: text.count), withTemplate: "") as NSString
        
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
}
