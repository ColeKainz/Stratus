//
//  MapController.swift
//  Stratus
//
//  Created by student on 4/10/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation
import GoogleMaps
import CoreLocation

class MapController {
    
    var map: GMSMapView
    var zoom: Float
    var zoomIncrement: Float =  1
    
    var prevPosition: CLLocationCoordinate2D
    var position: CLLocationCoordinate2D
    
    let marker = GMSMarker()
    let linePath = GMSMutablePath()
    let polylinePath: GMSPolyline
    
    init( map: GMSMapView, zoom: Float, zoomIncrement: Float ) {
        self.map = map
        self.zoom = zoom
        self.zoomIncrement = zoomIncrement
        
        prevPosition = CLLocationCoordinate2DMake( 0, 0 )
        position = CLLocationCoordinate2DMake( 0, 0 )
        
        polylinePath = GMSPolyline( path: linePath )
        polylinePath.map = map
    }
    
    func setZoom( zoom: Float ) {
        self.zoom = zoom
        map.animate(toZoom: zoom)
    }
    
    func updateLongAndLat( longitude: Double, latitude: Double ) {
        prevPosition = position
        position = CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    //Adds Polyline that follows the user's position, updated with new position coordinates
    func setAndUpdateFlightPath() {
        linePath.add( position )
    }
    
    //Our plane icon
    //To do: Change plane icon size
    func planePosition(bearing: Double, longitude: Double, latitude: Double ) {
        marker.position = position
        marker.icon = UIImage(named: "plane")
        /*
        let size = CGSize(width: (marker.icon?.size.width)! / 2, height: (marker.icon?.size.width)! / 2) */
        
        //marker.title = "Hello Marker"
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        //Figure out how to change size of image
        marker.rotation = bearing
        marker.title = "Lat: " + String( format: "%.5f", latitude ) + " " + "Long: " + String( format: "%.5f", longitude )
        //marker.title = "Ori: " + String( bearing ) + "°"
        marker.tracksViewChanges = true
        marker.map = map
        
        //groundTrackLabel.text = "Ori: " + String( bearing ) + "°"
        //longitudeLabel.text = "Long: " + String( format: "%.5f", longitude )
        //latitudeLabel.text = "Lat: " + String( format: "%.5f", latitude )
    }
    
   // extension UIImage {
    /*
        func resizeImageWith(newSize: CGSize) -> UIImage {
            let horizontalRatio = newSize.width / size.width
            let verticalRatio = newSize.heigh / size.width
      */
        //}
    //}

    //Resize image functions
    /* NOTE: Madelyn will focus trying to change the image reponsively
    func resizeImage(image: UIImage /*newWidth: CGFloat*/) -> UIImage {
        //let scale = newWidth / image.size.width
        //let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: 100, height: 100))
        image.draw(in: CGRect(x: 0, y: 0, width: 100, height: 100))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    } */
    
    
    func trackingMode(bearing: Double) {
        
        let trackingCamera = GMSCameraPosition.camera(withTarget: position,
                                             zoom: 10,
                                             bearing: bearing,
                                             viewingAngle: 45)
        map.camera = trackingCamera
    }

    func updateCameraPosition() {
        let camera = GMSCameraPosition.camera(
            withTarget: position,
            zoom: zoom )
        
        map.camera = camera
    }
    
    func updateBearing( bearing: Double ) {
        map.animate( toBearing: bearing )
    }
}
