 //
 //  StratusDataFetch.swift
 //  Stratus
 //
 //  This is a singleton class that is responsible for connecting to and
 //  managing the data from the Stratus server.
 //
 //  Created by student on 2/9/18.
 //  Copyright © 2018 Cole Kainz. All rights reserved.
 //
 
 import Foundation
 
 class StratusDataFetcher {
    
    let BATTERYOFFSET: Int = 63
    
    //The structure the recieved Stratus data will be stored in.
    public struct StratusDataStruct {
        var battery: UInt8 = 0
        var GPSError: Bool = false
        var longitude: Double = 0
        var latitude: Double = 0
        var groundSpeed: Float = 0
        var altitude: Double = 0
        var vertSpeed: Double = 0
    }
    
    static let instance = StratusDataFetcher() // The shared instance of this class.
    
    private var observerArray = [ StratusObserver ]() // A list used to notify all observers of an update.
    private var stratusData = StratusDataStruct() // The data structure that this class will update then share with the observers.
    
    private var statusSocket: UDPSocket? = nil // The socket that will stream the stratus status.
    private var gpsSocket: UDPSocket? = nil // The socket that will stream GPS information.
    
    private init() {}
    
    // Updates all observers.
    internal func notify() {
        for observer in observerArray {
            observer.update(stratusData: stratusData)
        }
    }
    
    func attachObserver(observer: StratusObserver) {
        observerArray.append(observer)
    }
    
    internal func onRecieveData(data: Data) {
        stratusData.battery = stratusData.battery + 1
        notify()
    }
    
    // Sets up all sockets or ignores the call if every socket is already setup.
    // If any errors occure while setting up the sockets, pass them up to the UI.
    func setupSockets() throws {
        if statusSocket == nil || gpsSocket == nil {
            statusSocket = try UDPSocket(port: 41501, callback: onRecieveData)
            gpsSocket = try UDPSocket(port: 41502, callback: onRecieveData)
        }
    }
}
