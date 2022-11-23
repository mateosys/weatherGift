//
//  WeatherLocation.swift
//  weatherGift
//
//  Created by Matthew  Sustaita on 11/19/22.
//

import Foundation
//structure
class WeatherLocation: Codable {
    var name: String
    var lattitude: Double
    var longitude: Double
    
    
    
    init (name:String, lattitude: Double, longitude: Double){
        self.name = name
        self.lattitude = lattitude
        self.longitude = longitude
    }
    
   
    
}
