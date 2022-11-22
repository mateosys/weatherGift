//
//  WeatherLocation.swift
//  weatherGift
//
//  Created by Matthew  Sustaita on 11/19/22.
//

import Foundation

class WeatherLocation: Codable {
    var name: String
    var lattitude: Double
    var longtitue: Double
    
    init (name:String, lattitude: Double, longitude: Double){
        self.name = name
        self.lattitude = lattitude
        self.longtitue = longitude
    }
}
