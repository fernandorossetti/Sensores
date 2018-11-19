//
//  Information.swift
//  runTracker
//
//  Created by fernando rossetti on 01/21/17.
//  Copyright © 2016 NextUniversity. All rights reserved.
//

import Foundation
import MapKit

struct Information
{
    var startPosition: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var endPosition: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var startDate: NSDate = NSDate()
    var endDate: NSDate = NSDate()
    var meters: Double = 0.0
}