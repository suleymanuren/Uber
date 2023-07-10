//
//  UberMapViewRepresentable.swift
//  Uber
//
//  Created by Bulut Sistem on 10.07.2023.
//

import SwiftUI
import MapKit

struct UberMapViewRepresentable: UIViewRepresentable {
    
    let mapView = MKMapView()
    let locationManager = LocationManager()
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    @Binding var mapState : MapViewState
    
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewandCenterUserLocation()
            break
        case .searchingForLocation:
            
            break
        case .locationSelected:
            if let coordinate = locationViewModel.selectedLocationCoordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate) //seçilen yere marker oluşturuyor
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate) // seçilen yere rotasyon çizgisi oluşturuyor
            }
            break
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}
    
extension UberMapViewRepresentable {
    class MapCoordinator : NSObject, MKMapViewDelegate {
        let parent : UberMapViewRepresentable
        var userLocationCoordinate : CLLocationCoordinate2D?
        var currentRegion : MKCoordinateRegion?

        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation : MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion( //genel mapin hali kullanıcı konumunda açılıyor vs
                center: CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.currentRegion = region //navigasyon sıfırlandıktan sonra user lokasyonunu ortalıyor
            parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer { //seçilen hedef ile konum arasına polyline (çizgi koyuluyor)
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemRed
            polyline.lineWidth = 6 //polyline ayarları
            
            return polyline
        }
        
        func addAndSelectAnnotation (withCoordinate coordinate : CLLocationCoordinate2D) {
            parent.mapView.removeAnnotations(parent.mapView.annotations) //multi marker olmaması için markerları temizliyor
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            
            parent.mapView.addAnnotation(anno) //marker ekler
            parent.mapView.selectAnnotation(anno, animated: true) //marker işaretleme
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true) //markerleri gösterme
        }
        
        func configurePolyline (withDestinationCoordinate coordinate : CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocationCoordinate else {return}
            
            getDestinationRoute(from: userLocationCoordinate  , to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline) //hedef konuma polyline çiziyor
            
            }
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
                    
                    completion(route)
                }
                
            }
        func clearMapViewandCenterUserLocation() { // genel olarak mapi temizliyor marker , polyline , map location
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
        
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
    }
    
}


