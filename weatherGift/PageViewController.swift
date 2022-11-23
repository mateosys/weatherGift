//
//  PageViewController.swift
//  weatherGift
//
//  Created by Matthew  Sustaita on 11/22/22.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var weatherLocations: [WeatherLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        loadLocations()
        setViewControllers([createLocationDetailViewController(forPage: 0)], direction: .forward, animated: false)
    }
    
    func loadLocations(){
        guard let locationsEncoded = UserDefaults.standard.value(forKey: "weatherLocations")
                as? Data else{
            print("could not load weatherlocations, if this is this first time opening app, ignore this. ")
            weatherLocations.append(WeatherLocation(name: "CL", lattitude: 20.22, longitude: 20.22))
            return
        }
        let decoder = JSONDecoder()
        if let weatherLocations = try? decoder.decode(Array.self, from: locationsEncoded) as [WeatherLocation] {
            self.weatherLocations = weatherLocations
        } else {
            print("error couldnt' decode data read from userdefaults")
        }
        if weatherLocations.isEmpty {
            weatherLocations.append(WeatherLocation(name: "CL", lattitude: 20.22, longitude: 20.22))
        }
    }
        
        func createLocationDetailViewController(forPage page: Int) -> LocationDetailViewController{
            
            let detailViewController = storyboard!.instantiateViewController(withIdentifier: "LocationDetailViewController")
            as! LocationDetailViewController
            detailViewController.locationIndex = page
            return detailViewController
        }
        
        
    }
    extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            if let currentViewController = viewController as? LocationDetailViewController {
                if currentViewController.locationIndex > 0 {
                    return createLocationDetailViewController(forPage: currentViewController.locationIndex - 1)
                }
            }
            return nil
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            if let currentViewController = viewController as? LocationDetailViewController {
                if currentViewController.locationIndex < weatherLocations.count - 1 {
                    return createLocationDetailViewController(forPage: currentViewController.locationIndex + 1)
                }
            }
            return nil
        }
    }

