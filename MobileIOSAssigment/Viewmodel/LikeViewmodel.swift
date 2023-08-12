//
//  LikeViewmodel.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 12.08.2023.
//

import Foundation
import CoreData
import UIKit

class LikeViewmodel {
    
    private var managedObjectContext: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func addLikes(data: DataResponse) {
        let like = NSEntityDescription.insertNewObject(forEntityName: "Likes", into: managedObjectContext) as! Likes
        like.comment = Int32(data.comments)
        like.like = Int32(data.likes)
        like.view = Int32(data.views)
        like.image = data.previewURL
        like.previewWidth = Int32(data.previewWidth)
        like.previewHeight = Int32(data.previewHeight)
        like.id = Int64(data.id)
        like.isLike = true
        do {
            try managedObjectContext.save()
            print("like added successfully.")
            NotificationCenter.default.post(name: NSNotification.Name("DataUpdated"), object: nil)
        } catch {
            print("Failed to add like: \(error)")
        }
    }
    
    func addLikesIfNotExists(data: DataResponse) {
        // Core Data'da zaten eklenmiş mi?
        let fetchRequest: NSFetchRequest<Likes> = Likes.fetchRequest()
        do {
            let existingLikes = try managedObjectContext.fetch(fetchRequest) // bu kısım sorguya göre dolar. Eğer doluysa veri vardır. Yazdırma, Boşsa veri yokturyazdır.
            if existingLikes.first(where: { Likes in
                Likes.id == data.id // id'lerin sorgulanması
            }) != nil {
                print("Data already exists in Likes (Core Data). Skipping.")
            } else {
                // Eğer Core Data'da yoksa ekle
                addLikes(data: data)
            }
        } catch {
            print("Failed to check existing data: \(error)")
        }
    }
    
    func toggleLike(data: DataResponse) {
        let fetchRequest: NSFetchRequest<Likes> = Likes.fetchRequest()
        do {
            let existingLikes = try managedObjectContext.fetch(fetchRequest)
            if (existingLikes.first(where: { Likes in
                Likes.id == data.id // id'lerin sorgulanması
            }) != nil) {
                // Eğer veri varsa, Core Data'dan silinir
                removeLike(data: data)
                print("Data removed from Likes Core Data")
            } else {
                print("Data does not exist in Likes (Core Data). Adding to Likes.")
                // Veri Core Data'da yoksa, ekle
                addLikesIfNotExists(data: data)
            }
            try managedObjectContext.save() // Değişiklikleri kaydet
        } catch {
            print("Failed to check existing data or remove/add: \(error)")
        }
    }
    
    func removeLike(data: DataResponse) {
        let fetchRequest: NSFetchRequest<Likes> = Likes.fetchRequest()
        do {
            let existingLikes = try managedObjectContext.fetch(fetchRequest)
            if let existingLike = existingLikes.first(where: { Likes in
                Likes.id == data.id // id'lerin sorgulanması
            }) {
                // Eğer veri varsa, Core Data'dan silinir
                managedObjectContext.delete(existingLike)
                existingLike.isLike = false
            } else {
                print("Data does not exist in Likes (Core Data). Skipping removal.")
            }
            try managedObjectContext.save() // Değişiklikleri kaydet.
        } catch {
            print("Failed to check existing data or remove: \(error)")
        }
    }
    
    func isLiked(data: DataResponse) -> Bool {
        let fetchRequest: NSFetchRequest<Likes> = Likes.fetchRequest()
        do {
            let existingLikes = try managedObjectContext.fetch(fetchRequest)
            if existingLikes.first(where: { Likes in
                Likes.id == data.id // id'lerin sorgulanması
            }) != nil {
                // Eğer veri varsa true döner like'lanmış
                return true
            } else {
                // Veri Core Data'da yoksa false döner like'lanmamış
                return false
            }
        } catch {
            print("Failed to check existing data: \(error)")
        }
        return false // default olarak hepsi gri görünecek.
    }
    
}
