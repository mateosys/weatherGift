//
//  LocationDetailViewController.swift
//  weatherGift
//
//  Created by Matthew  Sustaita on 11/21/22.
//

import UIKit

class LocationDetailViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var weatherLocation: WeatherLocation!
    var weatherLocations: [WeatherLocation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if weatherLocation == nil {
            weatherLocation = WeatherLocation(name: "current location", lattitude: 0.0, longitude: 0.0)
        }
        loadLocations()
        updateUserInterface()
        
    }
    
    func loadLocations(){
        guard let locationsEncoded = UserDefaults.standard.value(forKey: "weatherLocations")
                as? Data else{
            print("could not load weatherlocations, if this is this first time opening app, ignore this. ")
            return
        }
        let decoder = JSONDecoder()
        if let weatherLocations = try? decoder.decode(Array.self, from: locationsEncoded) as [WeatherLocation] {
            self.weatherLocations = weatherLocations
        } else {
            print("error couldnt' decode data read from userdefaults")
        }
    }
    
    func updateUserInterface() {
        dateLabel.text = ""
        placeLabel.text = weatherLocation.name
        tempLabel.text = "--°"
        summaryLabel.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LocationListViewController
        destination.weatherLocations = weatherLocations
    }
    @IBAction func unwindFromLocationListViewController (segue: UIStoryboardSegue){
        let source = segue.source as! LocationListViewController
        weatherLocations = source.weatherLocations
        weatherLocation = weatherLocations[source.selectedLocationIndex]
        updateUserInterface()
        
    }
}
