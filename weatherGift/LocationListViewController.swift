//
//  ViewController.swift
//  weatherGift
//
//  Created by Matthew  Sustaita on 11/19/22.
//

import UIKit
import GooglePlaces

class LocationListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    var weatherLocations: [WeatherLocation] = []
    var selectedLocationIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }//OVRRIDECURLY
    
    func saveLocations(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(weatherLocations){
            UserDefaults.standard.set(encoded, forKey: "weatherLocations")
        }else {
            print("ERROR: Saving Encoding did not work")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selectedLocationIndex = tableView.indexPathForSelectedRow!.row
       saveLocations()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
          autocompleteController.delegate = self

          // Display the autocomplete view controller.
          present(autocompleteController, animated: true, completion: nil)

    }
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = true
        }
    }
    
    

}//LASTCLASSCURLY :o

extension LocationListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = weatherLocations[indexPath.row].name
        cell.detailTextLabel?.text = "lat:\(weatherLocations[indexPath.row].lattitude), long: \(weatherLocations[indexPath.row].longitude)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherLocations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = weatherLocations [sourceIndexPath.row]
        weatherLocations.remove(at: sourceIndexPath.row)
        weatherLocations.insert(itemToMove, at: destinationIndexPath.row)
       
    }
    
}
extension LocationListViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      let newlocation = WeatherLocation(name: place.name ?? "unknown place", lattitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
      weatherLocations.append(newlocation)
      tableView.reloadData()
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  

}
