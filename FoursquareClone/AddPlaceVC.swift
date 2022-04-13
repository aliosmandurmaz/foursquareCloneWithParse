//
//  AddPlaceViewController.swift
//  FoursquareClone
//
//  Created by Ali Osman DURMAZ on 3.04.2022.
//

import UIKit

class AddPlaceVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var commentsText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placeNameText: UITextField!
    @IBOutlet weak var placeTypeText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true // resim tıklanabilir hale geldi
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)

    }
    

    @IBAction func nextButtonClicked(_ sender: Any) {
        if  placeNameText.text != "" && placeTypeText.text != "" && commentsText.text != "" {
            if let choosenImage = imageView.image {
                let placeModel = PlaceModelWithSingleton.sharedInstance
                placeModel.placeName = placeNameText.text!
                placeModel.placeType = placeTypeText.text!
                placeModel.placeComments = commentsText.text!
                placeModel.placeImage = choosenImage
            }
            
            self.performSegue(withIdentifier: "toMapVC", sender: nil)

        } else {
            let alert = UIAlertController(title: "Error", message: "Place/Type/Comment ??", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}
