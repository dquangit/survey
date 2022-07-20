//
//  ConnectivityService.swift
//  Survey
//
//  Created by Quang Pham on 20/07/2022.
//

import Foundation
import RxSwift
import Connectivity
import RxRelay

protocol ConnectivityService {
    var onConnectStatusChanged: Observable<Bool> { get }
    var isConnected: Bool { get }
}


class ConnectivityServiceImpl: ConnectivityService {
    
    private let connectivity = Connectivity()
    private let onConnected = BehaviorRelay<Bool>(value: true)
    
    var onConnectStatusChanged: Observable<Bool> {
        onConnected.asObservable()
    }
    
    var isConnected: Bool {
        connectivity.isConnected
    }
    
    init() {
        onConnected.accept(connectivity.isConnected)
        connectivity.pollingInterval = Constants.requestTimeOutInterval
        connectivity.pollWhileOfflineOnly = true
        connectivity.isPollingEnabled = true
        connectivity.whenConnected = { [weak self] _ in
            self?.onConnected.accept(true)
        }
        connectivity.whenDisconnected = { [weak self] _ in
            self?.onConnected.accept(false)
        }
        connectivity.startNotifier()
    }
    
    deinit {
        connectivity.stopNotifier()
    }
}

