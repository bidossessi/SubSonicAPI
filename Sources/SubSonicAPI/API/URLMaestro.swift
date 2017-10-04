//
//  URLMaestro.swift
//  SubMaestro
//
//  Created by Stanislas Sodonon on 6/18/17.
//  Copyright © 2017 Stanislas Sodonon. All rights reserved.
//

import Cocoa

protocol URLMaestro: class {
    var defaults: UserDefaults { get }
    static var shared: URLMaestro { get }
    func url(config: SubSonicConfig, endpoint: String, params: [String: String]) -> URL
}



class URLMonitor: URLMaestro {

    // My job is to return properly formatted URLs
    static let shared: URLMaestro = URLMonitor()

    let defaults: UserDefaults = UserDefaults.standard
    
    private init() {
        print("URLMonitor started")
    }

    private func getUrlString(config: SubSonicConfig, endpoint: String) -> String {
        let serverUrl = config.serverUrl
        return "\(serverUrl)/rest/\(endpoint).view"
    }
    
    func url(config: SubSonicConfig, endpoint: String, params: [String: String]) -> URL {
        let baseUrl: String = self.getUrlString(config: config, endpoint: endpoint)
        
        let defaultParams: [String: String] = [
            "u": config.username,
            "p": config.password,
            "c": Constants.SubSonicInfo.apiName,
            "v": Constants.SubSonicInfo.apiVersion,
            // Ideally, this should come from config (advanced)
            "f": Constants.SubSonicInfo.apiFormat
        ]
        var queryParams: [String: String] = [:]
        for (key, value) in defaultParams {
            queryParams[key] = value
        }
        for (key, value) in params {
            queryParams[key] = value
        }
        
        let parameterString = queryParams.stringFromHttpParameters()
        let finalString = "\(baseUrl)?\(parameterString)"
        return URL(string: finalString)!
    }
}
