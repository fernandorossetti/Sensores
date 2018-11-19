//
//  PhotoSaveView.swift
//  runTracker
//
//  Created by Ihonahan Buitrago on 2/18/16.
//  Copyright © 2016 NextUniversity. All rights reserved.
//

import UIKit
import MapKit

class PhotoSaveView: UIView {
    
    @IBOutlet weak var photo : UIImageView!
    @IBOutlet weak var metersLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var coordinatesLabel : UILabel!
    
    
    class func loadFromNib() -> PhotoSaveView {
        var nibs = NSBundle.mainBundle().loadNibNamed("PhotoSaveView", owner: self, options: nil)
        let photoVw = nibs[0] as! PhotoSaveView
        
        return photoVw
    }
    
    class func exportPhotoSaveViewToUIImage(photoImage: UIImage,
        metersMessage: String,
        timeMessage: String,
        startCoordinates: CLLocationCoordinate2D,
        endCoordinates: CLLocationCoordinate2D) -> UIImage {
            let photoView = PhotoSaveView.loadFromNib()
            photoView.setupView(photoImage, meters: metersMessage, time: timeMessage, startCoordinates: startCoordinates, endCoordinates: endCoordinates)
            let result = photoView.exportToUIImage()
            
            return result
    }

    
    func setupView(image: UIImage, meters: String, time: String, startCoordinates: CLLocationCoordinate2D, endCoordinates: CLLocationCoordinate2D) {
        self.photo.image = image
        
        self.metersLabel.text = meters
        self.timeLabel.text = time
        
        let startLatitude = self.translateDegreesToDMS(startCoordinates.latitude)
        let startLongitude = self.translateDegreesToDMS(startCoordinates.longitude)
        let endLatitude = self.translateDegreesToDMS(startCoordinates.latitude)
        let endLongitude = self.translateDegreesToDMS(startCoordinates.longitude)
        
        let startNorthSouth = startCoordinates.latitude >= 0 ? "N" : "S"
        let startEastWest = startCoordinates.longitude >= 0 ? "E" : "W"
        let endNorthSouth = endCoordinates.latitude >= 0 ? "N" : "S"
        let endEastWest = endCoordinates.longitude >= 0 ? "E" : "W"
        self.coordinatesLabel.text = String(format: "Desde %dº %d' %d\" %@,  %dº %d' %d\" %@\rHasta %dº %d' %d\" %@, %dº %d' %d\" %@",
            startLatitude[0], startLatitude[1], startLatitude[2], startNorthSouth,
            startLongitude[0], startLongitude[1], startLongitude[2], startEastWest,
            endLatitude[0], endLatitude[1], endLatitude[2], endNorthSouth,
            endLongitude[0], endLongitude[1], endLongitude[2], endEastWest)
    }
    
    func exportToUIImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 1.0)

        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
    
    
    func translateDegreesToDMS(coordinate: CLLocationDegrees) -> [Int] {
        var result = [Int]()
        
        result.append(Int(coordinate))
        let min : Double = coordinate - Double(result[0])
        let sec : Double = coordinate - Double(result[0]) - min

        result.append(Int(min * 60))
        result.append(Int(sec * 3600))

        return result
    }
}
