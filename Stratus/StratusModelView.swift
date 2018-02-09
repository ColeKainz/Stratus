 
 //
 //  stratusModelView.swift
 //  Stratus
 //
 //  Created by student on 2/9/18.
 //  Copyright © 2018 Cole Kainz. All rights reserved.
 //
 
 class StratusModelView {
    private static var _battery: Int = 0
    private static var _GPSError: Bool = false
    private static var _longitude: Double = 0
    private static var _latitude: Double = 0
    private static var _groundSpeed: Float = 0
    private static var _altitude: Double = 0
    private static var _vertSpeed: Double = 0
    
    static var battery: Int {
        set {
            _battery = newValue
        }
        
        get {
            return _battery
        }
    }
    
    static var GPSError: Bool {
        set {
            _GPSError = newValue
        }
        
        get {
            return _GPSError
        }
    }
    
    static var longitude: Double {
        set {
            _longitude = newValue
        }
        
        get {
            return _longitude
        }
    }
    
    static var latitude: Double {
        set {
            _latitude = newValue
        }
        
        get {
            return _latitude
        }
    }
    static var groundSpeed: Float {
        set {
            _groundSpeed = newValue
        }
        
        get {
            return _groundSpeed
        }
    }
    static var altitude: Double {
        set {
            _altitude = newValue
        }
        
        get {
            return _altitude
        }
    }
    static var vertSpeed: Double {
        set {
            _vertSpeed = newValue
        }
        
        get {
            return _vertSpeed
        }
    }
 }
