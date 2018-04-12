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
    /*
    func zoomIn() {
        zoom = zoom + zoomIncrement
        map.animate(toZoom: zoom)
    }
    
    func zoomOut() {
        zoom = zoom - zoomIncrement
        map.animate(toZoom: zoom)
    } */
    
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
