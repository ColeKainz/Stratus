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
  //  @IBOutlet weak var pathDraw: UIButton!
    @IBOutlet weak var drawLine: UIButton!
    
    
    var zoom: Float = 0
    var zoomInc: Float = 1
    
    var flightView = false
    var followMarker = true
    
    var markerPosition = CLLocationCoordinate2DMake( 0, 0 )
    var markerBearing: Double = 0
    
    let marker = GMSMarker()
    let linePath = GMSMutablePath()
    var polylinePath: GMSPolyline!
    
    override func viewDidLoad() {
        //mapView.mapType = GMSMapViewType.none
        mapView.delegate = self

        polylinePath = GMSPolyline( path: linePath )
        polylinePath.map = mapView
        
        marker.icon = UIImage( named: "plane" )
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        
        drawLine.setImage((UIImage(named: "Tracking_BG")), for: .normal)
        drawLine.setImage((UIImage(named: "Tracking_BG_inverted")), for: .selected)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setZoom( zoom: Float ) {
        self.zoom = zoom
        mapView.animate( toZoom: zoom )
    }
    
    func updateMarker( longitude: Double, latitude: Double, bearing: Double ) {
        markerPosition = CLLocationCoordinate2DMake( latitude, longitude )
        markerBearing = bearing
        
        marker.position = markerPosition
        marker.rotation = markerBearing
        
        marker.title = "Lat: " + String( format: "%.5f", latitude ) + " " + "Long: " + String( format: "%.5f", longitude )

        marker.tracksViewChanges = true
        marker.map = mapView
        
        //Center the camera every update, provided we are following the marker.
        if followMarker {
            centerCamera()
        }
    }
    
    //Adds Polyline that follows the user's position, updated with new position coordinates
    func setAndUpdateFlightPath() {
        linePath.add( markerPosition )
    }
 
    func centerCamera() {
        let camera = GMSCameraPosition.camera(
            withTarget: markerPosition,
            zoom: zoom )
        mapView.animate( to: camera )
        
        //If we are not following the marker, do not update the flight view
        if flightView {
            mapView.animate( toBearing: markerBearing )
        }
    }
    
    //Right now this should get the buttons to change
    @IBAction func toggleButton(_ sender: Any) {
        if let button = sender as? UIButton {
            if button.isSelected {
                flightView = false
                followMarker = false
                button.isSelected = false
            } else {
                flightView = true
                followMarker = true
                centerCamera()
                setAndUpdateFlightPath()
                button.isSelected = true
            }
        }
    }
    
    
    func mapView( _ mapView: GMSMapView, didChange position: GMSCameraPosition ) {
        let angle = position.bearing * Double.pi / 180
        
        compassImage.transform = CGAffineTransform( rotationAngle: CGFloat( angle ) )
        
        if !( position.target.latitude == markerPosition.latitude &&
            position.target.longitude == markerPosition.longitude ) {
            followMarker = false
        }
        
        if position.bearing != markerBearing {
            flightView = false
        }
    }
    
    //Polylines
    /*
    func drawline() {
        flightView = true
        followMarker = true
        centerCamera()
        setAndUpdateFlightPath()
    }*/
    
    //flight path button
    
    /*
    @IBAction func pathDraw(_ sender: UIButton) {
        
        sender.isSelected = sender.isSelected
        
        if sender.isSelected == true {
            flightView = true
            followMarker = true
            centerCamera()
            setAndUpdateFlightPath()
        }
        else {
            flightView = false
            followMarker = false
            linePath.removeLastCoordinate()
        }
     } */

    
    @IBAction func compassOnClick( _ sender: Any ) {
        if mapView.camera.bearing != 0 {
            mapView.animate( toBearing: 0 )
            flightView = false
        } else {
            mapView.animate( toBearing: markerBearing )
            flightView = true
        }
        
        centerCamera()
    }
    
    //Zoom In
    @IBAction func zoomIn(_ sender: Any) {
        if self.zoom < mapView.maxZoom {
            self.zoom += zoomInc
            mapView.animate( toZoom: zoom)
        }
    }
    
    //Zoom Out
    @IBAction func zoomOut(_ sender: Any) {
        if self.zoom > mapView.minZoom {
            self.zoom -= zoomInc
            mapView.animate( toZoom: zoom)
        }
    }
}
