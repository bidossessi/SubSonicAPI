//
//  QueueMaestro.swift
//  SubMaestro
//
//  Created by Stanislas Sodonon on 6/22/17.
//  Copyright © 2017 Stanislas Sodonon. All rights reserved.
//

import Cocoa

protocol DownloadQueueProtocol {
    // TODO: Make it reusable!!!
    static var shared: DownloadQueueProtocol { get }
    var store: NSMutableArray { get }
    var count: Int { get }
    var isEmpty: Bool { get }
    subscript(_ index: Int) -> Download? { get }
    func enqueue(aDownload: Download)
    func enqueue(someDownloads: [Download])
    func next() -> Download?
    func reprocess()
    func clean()
}

class DownloadQueue: DownloadQueueProtocol {
    static let shared: DownloadQueueProtocol = DownloadQueue()
    private var unprocessed: [Download] = []
    private var processed: [Download] = []
    
    var store: NSMutableArray {
        get {
            return NSMutableArray(array: self.unprocessed + self.processed)
        }
    }
    var count: Int {
        get {
            return self.unprocessed.count
        }
    }
    
    var isEmpty: Bool {
        return self.unprocessed.isEmpty
    }
    
    subscript(_ index: Int) -> Download? {
        return self.store.object(at: index) as? Download
    }
    

    private init() {
        print("DownloadQueue started")
    }
    
    func enqueue(aDownload: Download) {
        // Any preprocessing?
        if self.unprocessed.contains(aDownload) {
            return
        }
        if self.processed.contains(aDownload) {
            return
        }
        self.unprocessed.append(aDownload)
        print("\(self) enqueued: \(aDownload.item), count: \(self.count)")
    }
    
    func enqueue(someDownloads: [Download]) {
        for download in someDownloads {
            self.enqueue(aDownload: download)
        }
    }
    
    func reprocess() {
        self.unprocessed = self.processed.map{ d in
            d.state = .Pending
            return d
        }
        self.processed = []
    }
    
    func clean() {
        self.unprocessed = []
        self.processed = []
    }
    
    // MRK: - return next pending item
    func next() -> Download? {
        if self.unprocessed.isEmpty {
            print("\(self) has no unprocessed items")
            return nil
        }
        print("Checking for next pending")
        print("unprocessed: \(self.unprocessed.count)")
        print("processed: \(self.processed.count)")
        let candidate = self.unprocessed[0]
        switch candidate.state {
        case .Completed, .Cancelled:
            print("This one is done; Trying again")
            let move = self.unprocessed.removeFirst()
            self.processed.append(move)
            return self.next()
        case .Downloading:
            print("Busy; come back later")
            return nil
        default:
            return candidate
        }
    }
}
