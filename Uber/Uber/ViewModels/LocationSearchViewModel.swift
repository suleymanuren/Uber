//
//  LocationSearchViewModel.swift
//  Uber
//
//  Created by Bulut Sistem on 10.07.2023.
//

import SwiftUI
import MapKit


class LocationSearchViewModel : NSObject, ObservableObject {
    
    @Published var results = [MKLocalSearchCompletion]() //arama sonuçları
    @Published var selectedLocationCoordinate : CLLocationCoordinate2D? //seçilen lokasyon
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    var queryFragment : String = "" {
        didSet { // anlık yazılan harfleri dinliyor
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    override init() {
    
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
        
    }
    
    func selectLocation(_ localSearch : MKLocalSearchCompletion) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                print("location search select location function \(error.localizedDescription)")
                return
            }
            guard let item = response?.mapItems.first else {return}
            
            let coordinate = item.placemark.coordinate
            self.selectedLocationCoordinate = coordinate
            
        }
    }
    
    func locationSearch (forLocalSearchCompletion localSearch : MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
        
    }
}

extension LocationSearchViewModel : MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
