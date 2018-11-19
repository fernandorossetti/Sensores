//
//  Configurations.swift
//  runTracker
//
//  Created by fernando rossetti on 01/21/17.
//  Copyright © 2016 NextUniversity. All rights reserved.
//

import Foundation


struct Configurations
{
    let playMusic: Bool
    let drawRoute: Bool
    let userTrack: Bool
    
    init(playMusic: Bool, drawRoute: Bool, userTrack: Bool) {
        self.playMusic = playMusic
        self.drawRoute = drawRoute
        self.userTrack = userTrack
    }
}