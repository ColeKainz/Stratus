//
//  MapController.swift
//  Stratus
//
//  Created by student on 4/10/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var compassImage: UIImageView!
    @IBOutlet weak var drawLine: UIButton!
    
    var zoomInc: Float = 1
    
    var flightView = false
    var followMarker = true
    var drawFlightPath = false
    
    let marker = GMSMarker()
    let linePath = GMSMutablePath()
    var polylinePath: GMSPolyline!
    
    override func viewDidLoad() {
        //mapView.mapType = GMSMapViewType.none
        mapView.delegate = self

        polylinePath = GMSPolyline( path: linePath )
        polylinePath.map = mapView
        
        marker.icon = UIImage( named: "plane" )
        marker.groundAnchor = CGPoint( x: 0.5, y: 0.5 )
        marker.isFlat = true
        
        drawLine.setImage( ( UIImage( named: "Tracking_BG" ) ), for: .normal )
        drawLine.setImage( ( UIImage( named: "Tracking_BG_inverted" ) ), for: .selected )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateMarker( longitude: Double, latitude: Double, bearing: Double ) {
        marker.position = CLLocationCoordinate2DMake( latitude, longitude )
        marker.rotation = bearing
        
        marker.title = "Lat: " + String( format: "%.5f", latitude ) + " " + "Long: " + String( format: "%.5f", longitude )
        marker.map = mapView
        
        //Center the camera every update, provided we are following the marker.
        if followMarker {
            centerCamera()
            
            //If we are not following the marker, do not update the flight view
            if flightView {
                orientToFlightView()
            }
        }
        
        if drawFlightPath {
            setAndUpdateFlightPath()
        }
    }
    
    //Adds Polyline that follows the user's position, updated with new position coordinates
    func setAndUpdateFlightPath() {
        linePath.add( marker.position )
        polylinePath.path = linePath
    }
 
    func resetFlightPath() {
        linePath.removeAllCoordinates()
        polylinePath.path = linePath
    }
    
    func centerCamera() {
        mapView.animate(toLocation: marker.position)
    }
    
    func orientToFlightView() {
        mapView.animate( toBearing: marker.rotation )
    }
    
    //Right now this should get the buttons to change
    @IBAction func toggleDrawFlightPath( _ sender: Any ) {
        if let button = sender as? UIButton {
            if button.isSelected {
                drawFlightPath = false
                button.isSelected = false
            } else {
                flightView = true
                followMarker = true
                drawFlightPath = true
                button.isSelected = true
                
                centerCamera()
                orientToFlightView()
            }
        }
    }
    
    func mapView( _ mapView: GMSMapView, didChange position: GMSCameraPosition ) {
        let angle = position.bearing * Double.pi / 180
        
        compassImage.transform = CGAffineTransform( rotationAngle: CGFloat( angle ) )
        
        if !( position.target.latitude == marker.position.latitude &&
            position.target.longitude == marker.position.longitude ) {
            followMarker = false
        }
        
        if position.bearing != marker.rotation{
            flightView = false
        }
    }
    
    @IBAction func compassOnClick( _ sender: Any ) {
        if mapView.camera.bearing != 0 {
            mapView.animate( toBearing: 0 )
            flightView = false
        } else {
            orientToFlightView()
            flightView = true
        }
        
        centerCamera()
    }
    
    //Zoom In
    @IBAction func zoomIn( _ sender: Any ) {
        var zoom = mapView.camera.zoom
        if zoom < mapView.maxZoom {
            zoom += zoomInc
            mapView.animate( toZoom: zoom)
        }
    }
    
    //Zoom Out
    @IBAction func zoomOut( _ sender: Any ) {
        var zoom = mapView.camera.zoom
        if zoom > mapView.minZoom {
            zoom -= zoomInc
            mapView.animate( toZoom: zoom)
        }
    }
}
