//
//  StratusObserver.swift
//  Stratus
//
//  Created by Cole Kainz on 2/19/18.
//  Copyright © 2018 student. All rights reserved.
//

protocol StratusObserver {
    func onUpdate( stratusData: StratusDataFetcher.StratusDataStruct )
    func onSocketError( error: Error )
}
