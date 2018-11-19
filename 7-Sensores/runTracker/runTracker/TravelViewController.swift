//
//  TravelViewController.swift
//  runTracker
//
//  Created by fernando rossetti on 01/21/17.
//  Copyright © 2016 NextUniversity. All rights reserved.
//

import UIKit
import MobileCoreServices

class TravelViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var metersLabel: UILabel!
    
    // MARK: Properties
    
    var information: Information!
    var time: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        time = String(information.endDate.timeIntervalSinceDate(information.startDate) / 60)
        timeLabel.text = time
        metersLabel.text = String(information.meters)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Picture actions
    
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            imagePicker.setEditing(true, animated: true)
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType == kUTTypeImage as String {
            let image = info[UIImagePickerControllerEditedImage] as! UIImage
            let editedImage = PhotoSaveView.exportPhotoSaveViewToUIImage(image, metersMessage: "\(information.meters)", timeMessage: time, startCoordinates: information.startPosition, endCoordinates: information.endPosition)
            
            UIImageWriteToSavedPhotosAlbum(editedImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func makeNotification(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        let title = "Foto guardada"
        let message = "La foto se ha guardado en el carrete"
        makeNotification(title, message: message)
    }
}
