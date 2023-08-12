//
//  HomeViewmodel.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 11.08.2023.
//

import Foundation
import Alamofire

class HomeViewmodel {
    
    let baseUrl = "https://pixabay.com/api/"
    
    func fetchData(completion: @escaping (_ data: [DataResponse]) -> Void) {
        AF.request("\(baseUrl)?key=37427312-d8d1e5548011abcd225706ea7", method: .get).responseJSON { response in
                if let error = response.error { // hata alıp almadığımızı kontrol ediyoruz.
                    print(error)
                } else { // hata yoksa çektiğimiz verileri konsoldan görebiliyoruz.
                    do {
                        if let data = response.data {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                // JSON verisi başarıyla parse edildi, verilere eriş
                                if let fetchData = json["hits"] as? [[String: Any]] {
                                    for data in fetchData { // her bir nesnenin doğru türden olup olmadığını kontrol ediyor.
                                        if  let id = data["id"] as? Int,
                                            let previewURL = data["previewURL"] as? String,
                                            let previewWidth = data["previewWidth"] as? Int,
                                            let previewHeight = data["previewHeight"] as? Int,
                                            let likes = data["likes"] as? Int,
                                            let comments = data["comments"] as? Int,
                                            let views = data["views"] as? Int,
                                            let user = data["user"] as? String,
                                            let userImageURL = data["userImageURL"] as? String,
                                            let webformatURL = data["webformatURL"] as? String,
                                            let webformatWidth = data["webformatWidth"] as? Int,
                                            let webformatHeight = data["webformatHeight"] as? Int {
                                            let responseData = DataResponse(id: id, previewURL: previewURL, previewWidth: previewWidth, previewHeight: previewHeight, likes: likes, comments: comments, views: views, user: user, userImageURL: userImageURL, webformatURL: webformatURL, webformatWidth: webformatWidth, webformatHeight: webformatHeight)
                                            DataManager.shared.dataArray.append(responseData)
                                            completion(DataManager.shared.dataArray)
                                        }
                                    }
                                }
                            } else {
                                print("else'deki error")
                            }
                        }
                    } catch {
                        print("catch'deki error")
                    }
                }
            }
        }
    }


