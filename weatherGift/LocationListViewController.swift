//
//  ViewController.swift
//  weatherGift
//
//  Created by Matthew  Sustaita on 11/19/22.
//

import UIKit

class LocationListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    var weatherLocations: [WeatherLocation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var weatherLocation = WeatherLocation(name: "Boyga, MA", lattitude: 0, longtitue: 0)
        weatherLocations.append(weatherLocation)
        weatherLocation = WeatherLocation(name: "Cooltown, CA", lattitude: 0, longtitue: 0)
        weatherLocations.append(weatherLocation)
        weatherLocation = WeatherLocation(name: "Horseville, TX", lattitude: 0, longtitue: 0)
        weatherLocations.append(weatherLocation)
        
    }//OVRRIDECURLY

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
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
