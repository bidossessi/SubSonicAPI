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

    private var _session: URLSessionProtocol?
    var session : URLSessionProtocol {
        get {
            if _session == nil {
                let config = URLSessionConfiguration.default
                // TODO: Get this from settings
                config.allowsCellularAccess = true
                config.requestCachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
                _session = URLSession(configuration: config)
            }
            return _session!
        }
        set(newSession) {
            _session = newSession
        }
    }

    init(session: URLSessionProtocol) {
        super.init()
        self.session = session
    }
    
    func makeDownload(url: URL, item: SubItem) -> Download {
        let task = self.session.downloadTask(with: url)
        return Download(item: item, url: url, task: task)
    }
    
    func enqueue(url: URL, forItem item: SubItem) {
        let download = self.makeDownload(url: url, item: item)
        self.downloadQueue.enqueue(aDownload: download)
    }
    
    func startNext() {
        guard let nextDownload: Download = self.downloadQueue.next() else {
            print("nothing found in queue")
            return
        }
        self.activeQueueMap.updateValue(nextDownload, forKey: nextDownload.url)
        nextDownload.task?.resume()
    }
}


extension MediaDownloadClient: URLSessionDelegate, URLSessionTaskDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        if let _ = error {
            self.onComplete?(nil, .Query)
            return
        }
        else{
            print("MediaDownloadClient: Download - complete!")
            guard let sourceURL = task.originalRequest?.url else { return }
            guard let download = self.activeQueueMap.removeValue(forKey: sourceURL) else { return }
            self.onComplete?(download, nil)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesExpectedToWrite > 0 {
            let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            guard let sourceURL = downloadTask.originalRequest?.url else { return }
            let download = self.activeQueueMap[sourceURL]
            download?.progress = progress
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        let download = self.activeQueueMap[sourceURL]
        download?.tmpFile = location
        download?.state = .Completed
        startNext()
    }
    
}
