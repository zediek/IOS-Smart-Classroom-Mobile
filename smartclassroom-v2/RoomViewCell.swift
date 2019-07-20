//
//  RoomViewCell.swift
//  smartclassroom-v2
//
//  Created by Neil Steven Villamil on 19/07/2019.
//  Copyright © 2019 Neil Steven Villamil. All rights reserved.
//

import UIKit

protocol RoomCellDelegate {
    func didTapRoom(group: Int, name: String, description: String, id: Int)
}

class RoomViewCell: UICollectionViewCell {
    
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var airconStatus: UILabel!
    @IBOutlet weak var tempStatus: UILabel!
    @IBOutlet weak var lightsStratus: UILabel!
    
    var roomItem: Room!
    var delegate: RoomCellDelegate?
    
    func setRoom(room: Room){
        roomItem = room
        roomName.text = room.name
        airconStatus.text = room.airconStatus
        tempStatus.text = room.tempStatus
        lightsStratus.text = room.lightsStatus
    }
    
    
    @IBAction func roomButton(_ sender: UIButton) {
        
    }
}
