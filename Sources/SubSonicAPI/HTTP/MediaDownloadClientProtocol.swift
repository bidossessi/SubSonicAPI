//
//  DataMonitor.swift
//  SubMaestro
//
//  Created by Stanislas Sodonon on 6/17/17.
//  Copyright © 2017 Stanislas Sodonon. All rights reserved.
//

import Foundation

protocol MediaDownloadClientProtocol: class {
    var downloadQueue: DownloadQueueProtocol { get }
    var activeQueueMap: [URL: Download] { get set }
    func enqueue(url: URL, forItem item: SubItem)
    var session: URLSessionProtocol { get }
    func startNext()
    var onComplete: ((_ result: Download?, _ error: NetworkError?) ->())? { get set }
}

