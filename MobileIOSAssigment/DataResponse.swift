//
//  DataResponse.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 20.06.2023.
//

import Foundation
struct dataResponse : Codable { // Codable bir protokoldür. decode ve encode işlemlerimi kolay hale getirir. jsonla çalışmak rahatlaşır.
    var id : Int
    var previewURL : String
    var previewWidth : Int
    var previewHeight : Int
    var likes : Int
    var comments : Int
    var views : Int
    var user: String
    var userImageURL: String
    var webformatURL: String
    var webformatWidth: Int
    var webformatHeight: Int
    
    init(id: Int, previewURL: String, previewWidth: Int, previewHeight: Int, likes: Int, comments: Int, views: Int, user: String, userImageURL: String, webformatURL: String, webformatWidth: Int, webformatHeight: Int) {
        self.id = id
        self.previewURL = previewURL
        self.previewWidth = previewWidth
        self.previewHeight = previewHeight
        self.likes = likes
        self.comments = comments
        self.views = views
        self.user = user
        self.userImageURL = userImageURL
        self.webformatURL = webformatURL
        self.webformatWidth = webformatWidth
        self.webformatHeight = webformatHeight
    }
}
