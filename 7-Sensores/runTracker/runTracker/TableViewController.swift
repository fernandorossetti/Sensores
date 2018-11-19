//
//  TableViewController.swift
//  runTracker
//
//  Created by fernando rossetti on 01/21/17.
//  Copyright © 2016 NextUniversity. All rights reserved.
//

import UIKit

protocol ConfigurationProtocol {
    func didEndConfiguration(configuration: Configurations)
    func beginRoute()
    func cancelRoute()
}

class TableViewController: UITableViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var drawRouteSwitch: UISwitch!
    @IBOutlet weak var playMusicSwitch: UISwitch!
    @IBOutlet weak var userTrackSwitch: UISwitch!
    @IBOutlet weak var cancelOrBeginButton: UIButton!
    @IBOutlet weak var onRouteLabel: UILabel!
    
    // MARK: Properties
    
    var delegate: ConfigurationProtocol?
    var onRote: Bool = false
    var configuration: Configurations!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawRouteSwitch.on = configuration.drawRoute
        self.playMusicSwitch.on = configuration.playMusic
        self.userTrackSwitch.on = configuration.userTrack
        let imageName = self.onRote == true ? "x" : "inicio"
        self.cancelOrBeginButton.setImage(UIImage(named: imageName), forState: .Normal)
        self.onRouteLabel.text = self.onRote == true ? "Cancelar recorrido" : "Iniciar recorrido"
        
        self.drawRouteSwitch.enabled = !onRote
        self.playMusicSwitch.enabled = !onRote
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func endConfiguration(sender: UIBarButtonItem) {
        let configuration = Configurations(playMusic: playMusicSwitch.on, drawRoute: drawRouteSwitch.on, userTrack: userTrackSwitch.on)
        self.delegate?.didEndConfiguration(configuration)
        self.performSegueWithIdentifier("backToMapSegue", sender: self)
    }
    @IBAction func beginOrCancel(sender: UIButton) {
        if self.onRote {
            self.delegate?.cancelRoute()
        } else {
            self.delegate?.beginRoute()
        }
        self.performSegueWithIdentifier("backToMapSegue", sender: self)
    }

}
