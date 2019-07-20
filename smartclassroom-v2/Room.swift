//
//  File.swift
//  smartclassroom-v2
//
//  Created by Neil Steven Villamil on 19/07/2019.
//  Copyright © 2019 Neil Steven Villamil. All rights reserved.
//

import Foundation

import UIKit

class Room {
    
    var name: String
    var airconStatus: String
    var tempStatus: String
    var lightsStatus: String
    
    
    init(name: String, airconStatus: String, tempStatus: String, lightsStatus: String){
        self.name = name
        self.airconStatus = airconStatus
        self.tempStatus = tempStatus
        self.lightsStatus = lightsStatus
    }
}
