//
//  Download.swift
//  SubMaestro
//
//  Created by Stanislas Sodonon on 6/20/17.
//  Copyright © 2017 Stanislas Sodonon. All rights reserved.
//

import Foundation


enum DownloadState: String {
    case Downloading = "Downloading"
    case Cancel = "Cancelled"
    case Complete = "Complete"
    case Pending = "Pending"
}

protocol Downloadable {
    var item: SubItem { get }
    var task: URLSessionDownloadTask { get }
    var state: DownloadState { get set }
    var resumeData: Data? { get set }
    var progress: Progress { get }
    var url: URL { get }
}


class Download: Downloadable {
    let item: SubItem
    let url: URL
    let task: URLSessionDownloadTask
    var state: DownloadState = .Pending
    var resumeData: Data?
    var progress: Progress {
        get {
            return task.progress
        }
    }
    
    init(item: SubItem, url: URL, task: URLSessionDownloadTask) {
        self.item = item
        self.url = url
        self.task = task
    }
}

