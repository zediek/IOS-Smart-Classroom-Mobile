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
    
    
    var usertype: String = ""
    var token: String = ""
    
    var roomName: String = ""
    var airconStatus: Any = (Any).self
    var tempStatus: String = ""
    var lightsStatus: String = ""
    
    
    
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
                            print(JD.room_name)
                            
                            
                            
                            
                            
                            
                            
                            

                            
                            if let Devices = JD.devices as? [[String: Any]]{
                                for Device in Devices{
                                    if let JSONDEVICE = try? DeviceData(jsonDevice: Device){
                                        print(JSONDEVICE.device_name)
                                        
                                        
                                        
                                        switch(JSONDEVICE.device_name){
                                            case "Aircon":
                                                self.airconStatus = JSONDEVICE.device_status
                                            break
                                        case "Aircon temperature":
                                            self.tempStatus = JSONDEVICE.device_status as! String
                                        break
                                        case "Lights":
                                            self.lightsStatus = JSONDEVICE.device_status as! String
                                        break
                                        default:
                                            return
                                        }
                                        
                                        
                                        
                                    }
                                 
                                }
                            }
                            
                            print("------------------------")
                            
                            
                            
                            
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        task.resume()
            
            
            
}
    
    
    
    


}
