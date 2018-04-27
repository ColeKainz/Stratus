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
    
    enum FlightViewState {
        case mapView
        case travelView
        case userView
    }
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var compassImage: UIImageView!
    @IBOutlet weak var drawLine: UIButton!
    
    let zoomInc: Float = 1
    
    var flightViewState: FlightViewState = .mapView
    
    var followMarker = true
    var drawFlightPath = false
    
    let marker = GMSMarker()
    let linePath = GMSMutablePath()
    var polylinePath: GMSPolyline!

    override func viewDidLoad() {
        //mapView.mapType = GMSMapViewType.none
        mapView.delegate = self
        
        polylinePath = GMSPolyline( path: linePath )
        polylinePath.strokeWidth = 6
        polylinePath.map = mapView
        
        marker.icon = UIImage( named: "plane" )
        marker.groundAnchor = CGPoint( x: 0.5, y: 0.5 )
        marker.isFlat = true
        
        drawLine.setImage( ( UIImage( named: "Tracking_BG" ) ), for: .normal )
        drawLine.setImage( ( UIImage( named: "Tracking_BG_inverted" ) ), for: .selected )
        
        let drawLineLongPressGesture = UILongPressGestureRecognizer( target: self, action: #selector( drawLineLongPress( _: ) ) )
        drawLine.addGestureRecognizer(drawLineLongPressGesture)

        let drawLineTapGesture = UITapGestureRecognizer( target: self, action: #selector( drawLineTap( _: ) ) )
        drawLineTapGesture.numberOfTapsRequired = 1
        drawLine.addGestureRecognizer(drawLineTapGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateMarker( longitude: Double, latitude: Double, bearing: Double, GPSValid: Bool ) {
        marker.position = CLLocationCoordinate2DMake( latitude, longitude )
        marker.rotation = bearing
        
        marker.title = "Lat: " + String( format: "%.5f", latitude ) + " " + "Long: " + String( format: "%.5f", longitude )
        marker.snippet = GPSValid ? "" : "Invalid"
        
        marker.map = mapView
        
        //Center the camera every update, provided we are following the marker.
        if followMarker {
            centerCamera()
            
            //If we are not following the marker, do not update the flight view
            if flightViewState == .travelView {
                orientToFlightView()
            }
        }
        
        if drawFlightPath {
            updateFlightPath()
        }
    }
    
    //Adds Polyline that follows the user's position, updated with new position coordinates
    func updateFlightPath() {
        let lastIndex = Int( linePath.count() ) - 1

        if lastIndex > -1 {
            let lastCoord = polylinePath.path!.coordinate( at: UInt(lastIndex) )
        
            if !( marker.position.latitude == lastCoord.latitude && marker.position.longitude == lastCoord.longitude ) {
                linePath.add( marker.position )
                polylinePath.path = linePath
            }
        } else {
            linePath.add( marker.position )
            polylinePath.path = linePath
        }
    }
    
    func setupNewPolyLine() {
        linePath.removeAllCoordinates()
        
        polylinePath = GMSPolyline( path: linePath )
        polylinePath.strokeWidth = 6
        polylinePath.map = mapView
        
        linePath.add( marker.position )
        polylinePath.path = linePath
    }
 
    func resetFlightPath() {
        mapView.clear()
        polylinePath.map = nil
        linePath.removeAllCoordinates()
    }
    
    func centerCamera() {
        if !( mapView.camera.target.latitude == marker.position.latitude &&
            mapView.camera.target.longitude == marker.position.longitude ) {
            mapView.animate(toLocation: marker.position)
        }
    }
    
    func orientToFlightView() {
        if mapView.camera.bearing != marker.rotation {
            mapView.animate( toBearing: marker.rotation )
        }
    }
    
    @objc func drawLineTap( _ sender: UIGestureRecognizer ) {
        if drawLine.isSelected {
            drawFlightPath = false
            drawLine.isSelected = false
        } else {
            flightViewState = .travelView
            followMarker = true
            drawFlightPath = true
            drawLine.isSelected = true
            
            setupNewPolyLine()
            centerCamera()
            orientToFlightView()
        }
    }
    
    @objc func drawLineLongPress( _ sender: UIGestureRecognizer ) {
        if sender.state == .ended {
            resetFlightPath()
            drawFlightPath = false
            drawLine.isSelected = false
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {

        let angle = position.bearing * Double.pi / 180
        compassImage.transform = CGAffineTransform( rotationAngle: CGFloat( angle ) )
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            followMarker = false
            flightViewState = .userView
        }
    }
    
    @IBAction func compassOnClick( _ sender: Any ) {
        if flightViewState != .mapView {
            mapView.animate( toBearing: 0 )
            flightViewState = .mapView
        } else {
            orientToFlightView()
            flightViewState = .travelView
        }
        
        followMarker = true
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
