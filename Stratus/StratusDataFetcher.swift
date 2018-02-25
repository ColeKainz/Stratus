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

import CocoaAsyncSocket
 
 class StratusDataFetcher: NSObject, GCDAsyncUdpSocketDelegate{
    
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
//    private var socket: GCDAsyncUdpSocket
    
    func test() {
        let socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
    
        do {
            try socket.bind(toPort: 41501)
            try socket.enableBroadcast(true)
            try socket.beginReceiving()
        } catch {}
    }
    
    internal func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        stratusData.battery = stratusData.battery + 1
        notify()
    }
    
    internal func notify() {
        for observer in observerArray {
            observer.update(stratusData: stratusData)
        }
    }
    
    internal func attachObserver(observer: StratusObserver) {
        observerArray.append(observer)
    }
}
