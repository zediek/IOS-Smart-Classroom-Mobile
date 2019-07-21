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


class HomeViewController: UIViewController {
    
    
    var roomcount: Int = 0
    
    
    var usertype: String = ""
    var token: String = ""
    
    var roomName: String = ""
    var airconStatus: Any = (Any).self
    var tempStatus: String = ""
    var lightsStatus: String = ""
    
    
    var DeviceData = [
    
        "class_name": "",
        "device_name": "",
        "remote_design": "",
        "device_status": (Any).self,
        "remote_design_id": 0,
        "device_id": 0,
        "room_status_id": 0
        ] as [String : Any]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRoomArray()
        //createRoomButton()

        // Do any additional setup after loading the view.
    }
    
    

    
    func createRoomArray(){
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
                    
                    for datas in room_status{
                        
                        if let JD = try? JSONData(json: datas){
                           // print(JD.room_name)
                            
                            
                            
                            
                            
                            
                           self.roomcount = self.roomcount + 1
                            
                            if let Devices = JD.devices as? [[String: Any]]{
                                for Device in Devices{
                                    self.DeviceData["class_name"] = Device["class_name"] as? String
                                    self.DeviceData["device_name"] = Device["device_name"] as? String
                                    self.DeviceData["remote_design"] = Device["remote_design"] as? String
                                    self.DeviceData["device_status"] = Device["device_status"] as? Any
                                    self.DeviceData["remote_design_id"] = Device["remote_design_id"] as? Int
                                    self.DeviceData["device_id"] = Device["device_id"] as? Int
                                    self.DeviceData["room_status_id"] = Device["room_status_id"] as? Int
                                    
                                    switch self.DeviceData["device_name"]!{
                                        case "Aircon" as String:
                                            print("Aircon")
                                            self.airconStatus = self.DeviceData["device_status"]!
                                            print(self.airconStatus)
                                        break
                                        case "Aircon temperature" as String:
                                            print("Temperature")
                                            self.tempStatus = self.DeviceData["device_status"] as? Any as! String
                                            print(self.tempStatus)
                                        break
                                        case "Lights" as String:
                                            print("Lights")
                                            self.lightsStatus = self.DeviceData["device_status"] as! String
                                            print(self.lightsStatus)
                                        break
                                    default:
                                        let temp = ""
                                    }
                                 
                                }
                            }
                            
                            
                            
                            
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        task.resume()
            
            
            
}
    
    
    
    


}
