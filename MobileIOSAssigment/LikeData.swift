//
//  LikeData.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 7.08.2023.
//

import Foundation

struct LikeData : Codable {
    
    var previewURL : String
    var likes : Int
    var comments : Int
    var views : Int
    var previewWidth : Int
    var previewHeight : Int
    var id: Int
    
    init(previewURL: String, likes: Int, comments: Int, views: Int, previewWidth: Int, previewHeight: Int, id: Int) {
        self.previewURL = previewURL
        self.likes = likes
        self.comments = comments
        self.views = views
        self.previewWidth = previewWidth
        self.previewHeight = previewHeight
        self.id = id
    }
    
}
