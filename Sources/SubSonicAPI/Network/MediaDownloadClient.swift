//
//  DataMonitor.swift
//  SubMaestro
//
//  Created by Stanislas Sodonon on 6/17/17.
//  Copyright © 2017 Stanislas Sodonon. All rights reserved.
//

import Foundation

class MediaDownloadClient: NSObject, MediaDownloadClientProtocol {
    
    var activeQueueMap: [URL: Download] = [:]
    let downloadQueue: DownloadQueueProtocol = DownloadQueue.shared
    var onComplete: ((_ result: Download?, _ error: NetworkError?) ->())?
    var onEmpty: (()->())?

    private var _session: URLSessionProtocol?
    var session : URLSessionProtocol {
        get {
            if _session == nil {
                let config = URLSessionConfiguration.default
                // TODO: Get this from settings
                config.allowsCellularAccess = true
                config.requestCachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
                _session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
            }
            return _session!
        }
        set(newSession) {
            _session = newSession
        }
    }

    
    convenience init(session: URLSessionProtocol) {
        self.init()
        self.session = session
    }
    
    func makeDownload(from set: [(URL, Song)]) -> [Download] {
        return set.map{ (k: URL, v: Song) -> Download in
            let task = self.session.downloadTask(with: k)
            return Download(item: v, url: k, task: task)
        }
    }
    
    func enqueue(set: [(URL, Song)]) {
        let downloads = self.makeDownload(from: set)
        self.downloadQueue.enqueue(someDownloads: downloads)
        self.startNext()
    }
    
    func startNext() {
        guard let nextDownload: Download = self.downloadQueue.next() else {
//            print("nothing found in queue")
            self.onEmpty?()
            return
        }
//        print("startNext called: \(nextDownload.item.id)")
        self.activeQueueMap.updateValue(nextDownload, forKey: nextDownload.url)
        nextDownload.task?.resume()
    }
}


extension MediaDownloadClient: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        if let _ = error {
            self.onComplete?(nil, .Query)
            return
        }
        else{
            guard let sourceURL = task.originalRequest?.url else { return }
            guard let download = self.activeQueueMap.removeValue(forKey: sourceURL) else { return }
            print("Download complete!")
            self.onComplete?(download, nil)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesExpectedToWrite > 0 {
            let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
//            print("file progress: \(progress)")
            guard let sourceURL = downloadTask.originalRequest?.url else { return }
            let download = self.activeQueueMap[sourceURL]
            download?.state = .Downloading
            download?.progress = progress
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("file downloaded: \(location.absoluteString)")
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        let download = self.activeQueueMap[sourceURL]
        download?.tmpFile = location
        download?.state = .Completed
        startNext()
    }
    
}
