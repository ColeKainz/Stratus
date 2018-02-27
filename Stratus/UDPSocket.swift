//
//  UDPSocket.swift
//  Stratus
//
//  This class creates a UDP socket and passes all of the its recieved data
//  through a given callback function.
//
//  Created by student on 2/23/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class UDPSocket: NSObject, GCDAsyncUdpSocketDelegate {
    var callback: (Data) -> Void //  The function that reacts to the socket's recieved data.
    
    //  @port The port the socket will listen on.
    //  @callback The function to call when data is recieved.
    init(port: UInt16, callback: @escaping (Data) -> Void) throws {
        self.callback = callback
        super.init()
        
        let socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)

        try socket.bind(toPort: port)
        try socket.beginReceiving()
    }
    
    // Sends recived data through the callback.
    internal func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        callback(data)
    }
}

