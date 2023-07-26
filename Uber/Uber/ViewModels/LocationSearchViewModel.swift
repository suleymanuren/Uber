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
    @Published var selectedUberLocation : UberLocation? //seçilen lokasyon
    @Published var pickupTime : String? // alış saati
    @Published var dropOffTime : String? // variş saati
    
    private let searchCompleter = MKLocalSearchCompleter()
    var userLocation : CLLocationCoordinate2D?

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
            self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
            
        }
    }
    
    func locationSearch (forLocalSearchCompletion localSearch : MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
        
    }
    
    func computeRidePrice (forType type : RideType) -> Double { //calculating  ride price 
        guard let destCordinate = selectedUberLocation?.coordinate else { return 0.0 }
        guard let userCoordinate = self.userLocation else { return 0.0 }
        
        let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        
        let destination = CLLocation(latitude: destCordinate.latitude, longitude: destCordinate.longitude)
        
        let tripDistanceInMeters = userLocation.distance(from: destination)
        return type.computePrice(for: tripDistanceInMeters)
        
    }
    
    func getDestinationRoute(
        from userLocation : CLLocationCoordinate2D,
        to destination : CLLocationCoordinate2D,
        completion : @escaping(MKRoute) -> Void) {
            let userPlaceMark = MKPlacemark(coordinate: userLocation) // kullanıcı konumu
            let destPlaceMark = MKPlacemark(coordinate: destination) //hedef
            
            let request = MKDirections.Request() // navigasyon sorgusu oluşturuyoruz
            
            request.source = MKMapItem(placemark: userPlaceMark) //yukarıda başlatılan sorgunun başlangıç noktası
            request.destination = MKMapItem(placemark: MKPlacemark(placemark: destPlaceMark)) //yukarıda başlatılan sorgunun hedef noktası
            
            let directions = MKDirections(request: request) //navigasyon oluşturuyor
            
            directions.calculate { response, error in
                if let error = error {
                    print("error destination route func \(error.localizedDescription)")
                
                    return
                }
                
                guard let route = response?.routes.first else {return} //konuma çizilen ilk rotasyonu alıyoruz ilki genelde en hızlısı oluyor fakat değiştirebilir
                self.configurePickupAndDropoffTime(with: route.expectedTravelTime)
                completion(route)
            }
            
        }
    
    func configurePickupAndDropoffTime(with expecedTravelTime : Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        pickupTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expecedTravelTime)
    }
    
}

extension LocationSearchViewModel : MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
