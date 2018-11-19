//
//  ViewController.swift
//  runTracker
//
//  Created by Ihonahan Buitrago on 2/22/16.
//  Copyright © 2016 NextUniversity. All rights reserved.
//

import UIKit
import MapKit
import MediaPlayer

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, ConfigurationProtocol {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var beginOrStopButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties
    
    var player = MPMusicPlayerController.systemMusicPlayer()
    var query = MPMediaQuery.songsQuery()
    var currentMediaItem = MPMediaItem()
    
    var onRoute: Bool = false
    var registerRoute: Bool = true
    var music: Bool = true
    var pause: Bool = true
    var userTrack: Bool = true
    
    let spanDistance: Double = 500.0
    
    var information: Information!
    
    var locationManager: CLLocationManager!
    var beginUserLocation: CLLocationCoordinate2D!
    var locations: [CLLocation] = [CLLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Map Config
    
    func configMap() {
        self.mapView.delegate = self
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 10.0
        mapView.userTrackingMode = .Follow
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let howRecent = location.timestamp.timeIntervalSinceNow
            
            if abs(howRecent) < 10 && location.horizontalAccuracy < 20 {
                
                if self.locations.count > 0 && self.registerRoute {
                    var coords = [CLLocationCoordinate2D]()
                    coords.append(self.locations.last!.coordinate)
                    coords.append(location.coordinate)
                    
                    mapView.addOverlay(MKPolyline(coordinates: &coords, count: coords.count))
                }
                
                self.locations.append(location)
            }
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.init(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        renderer.lineWidth = 4.5
        return renderer
    }
    
    // MARK: Actions
    
    @IBAction func beginOrStop(sender: UIButton) {
        if onRoute {
            beginOrStopButton.setImage(UIImage(named: "inicio"), forState: .Normal)
            stopDrawRoute()
            self.performSegueWithIdentifier("presentSummary", sender: self)
        } else {
            beginOrStopButton.setImage(UIImage(named: "stop"), forState: .Normal)
            playMusic()
            getCurrentData()
        }
        onRoute = !onRoute
    }
    
    @IBAction func putUserLocation(sender: UIButton) {
        
        let location = mapView.userLocation.coordinate
        let region = MKCoordinateRegionMakeWithDistance(location, spanDistance, spanDistance)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func playOrStopMusic(sender: UIButton) {
        guard query.items?.first != nil else {
            return
        }
        
        if pause {
            player.play()
            sender.setImage(UIImage(named: "musica1"), forState: .Normal)
        } else {
            player.pause()
            sender.setImage(UIImage(named: "musica"), forState: .Normal)
        }
        self.pause = !self.pause
    }
    
    // MARK: Functions
    
    func playMusic() {
        guard self.music == true else {
            return
        }
        
        guard let song = query.items?.first else {
            return
        }
        
        if (player.nowPlayingItem == nil) {
            currentMediaItem = song
            player.nowPlayingItem = currentMediaItem
            player.play()
            musicButton.setImage(UIImage(named: "musica1"), forState: .Normal)
        }
    }
    
    func distance(distances: [CLLocation], currentDistance: Int = 0) -> Double {
        if currentDistance == distances.count - 1 || distances.isEmpty {
            return 0.0
        }
        return distances[currentDistance].distanceFromLocation(distances[currentDistance + 1]) +
            distance(distances, currentDistance: currentDistance + 1)
    }
    
    func getCurrentData() {
        locationManager.startUpdatingLocation()
        var newInformation = Information()
        newInformation.startDate = NSDate()
        newInformation.startPosition = mapView.userLocation.coordinate
        information = newInformation
    }
    
    func stopDrawRoute() {
        if (player.nowPlayingItem != nil) {
            player.stop()
            musicButton.setImage(UIImage(named: "musica"), forState: .Normal)
        }
        
        locationManager.stopUpdatingLocation()
        information.endPosition = mapView.userLocation.coordinate
        information.endDate = NSDate()
        information.meters = distance(self.locations)
        
        mapView.removeOverlays(mapView.overlays)
        locations.removeAll()
    }
    
    // MARK: Delegate
    
    func didEndConfiguration(configuration: Configurations) {
        self.music = configuration.playMusic
        self.registerRoute = configuration.drawRoute
        self.userTrack = configuration.userTrack
        self.mapView.userTrackingMode = userTrack == true ? .Follow : .None
    }
    
    func cancelRoute() {
        beginOrStopButton.setImage(UIImage(named: "inicio"), forState: .Normal)
        stopDrawRoute()
        onRoute = false
    }
    
    func beginRoute() {
        beginOrStopButton.setImage(UIImage(named: "stop"), forState: .Normal)
        playMusic()
        getCurrentData()
        onRoute = true
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "configurationSegue" {
            let view = segue.destinationViewController as! TableViewController
            view.delegate = self
            view.configuration = Configurations(playMusic: self.music, drawRoute: self.registerRoute, userTrack: self.userTrack)
            view.onRote = self.onRoute
        } else if segue.identifier == "presentSummary" {
            let view = segue.destinationViewController as!TravelViewController
            view.information = self.information
        }
    }
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
    }
}

