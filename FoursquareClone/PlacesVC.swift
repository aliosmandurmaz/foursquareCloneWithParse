//
//  PlacesVC.swift
//  FoursquareClone
//
//  Created by Ali Osman DURMAZ on 2.04.2022.
//

import UIKit
import Parse

class PlacesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var placeNameArray = [String]()
    var placeIDArray = [String]()
    var selectedPlaceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logOutClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromParse()
    }
    
    @objc func addButtonClicked() {
        self.performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let detailsVC = segue.destination as! DetailsVC
            detailsVC.choosenPlaceId = selectedPlaceId
        }
    }

    @objc func logOutClicked() {
        
        PFUser.logOutInBackground { error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: "\(error?.localizedDescription)")
            } else {
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
        }
        
    }

    func getDataFromParse() { // PARSE ' dan veri çekme işlemi !!
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { objects, error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: "\(error?.localizedDescription)")
            } else {
                if objects != nil {
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.placeIDArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        if let placeName = object.object(forKey: "name") as? String {
                            if let placeId = object.objectId as? String {
                                self.placeNameArray.append(placeName)
                                self.placeIDArray.append(placeId)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

extension PlacesVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeIDArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIDArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
}
