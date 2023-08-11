//
//  LikeDataManager.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 7.08.2023.
//

import Foundation
import CoreData
import UIKit

class LikeDataManager {
    
    static let shared = LikeDataManager()
    var likeDataArray: [dataResponse] = []
    var likedDataArray = UserDefaults.standard.array(forKey: "likedDataArray") as? [Int] ?? [] // id bilgilerini userdefaults'da tutuyorum.
    
    private var managedObjectContext: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func addLikes(data: dataResponse) {
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
        } catch {
            print("Failed to add like: \(error)")
        }
    }
    
    func fetchLikes() -> [Likes] {
        let fetchRequest: NSFetchRequest<Likes> = Likes.fetchRequest()
        NotificationCenter.default.post(name: NSNotification.Name("DataUpdated"), object: nil) // Veri güncellendiğinde bir bildirim gider DataUptated adında
        do {
            let likes = try managedObjectContext.fetch(fetchRequest)
            return likes
        } catch {
            print("Failed to fetch notes: \(error)")
            return []
        }
    }
    
    func countData(entityName: String) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Likes")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch {
            print("Error counting entities: \(error)")
            return 0
        }
    }
    
    func deleteAllEntities(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Likes")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("\(Likes.self) entities deleted successfully.")
        } catch {
            print("Error deleting entities: \(error)")
        }
    }
    
    func addLikesIfNotExists(data: dataResponse) {
//        if let bundle = Bundle.main.bundleIdentifier {
//            UserDefaults.standard.removePersistentDomain(forName: bundle)
//            UserDefaults.standard.synchronize()
//        }
//        UserDefaults.standard.removeObject(forKey: "8173402")
        if likedDataArray.contains(data.id) { // eğer burda veri varsa zaten eklenmiştir. Ekleme
            print("Data already exists in Likes (UserDefaults). Skipping.")
        } else {
            // Core Data'da zaten eklenmiş mi?
            let fetchRequest: NSFetchRequest<Likes> = Likes.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", data.id as CVarArg) // id bilgisine göre arama yapar.
            do {
                let existingLikes = try managedObjectContext.fetch(fetchRequest) // bu kısım sorguya göre dolar. Eğer doluysa veri vardır. Yazdırma, Boşsa veri yoktur yazdır.
                if existingLikes.isEmpty {
                    // Eğer Core Data'da yoksa ekle
                    addLikes(data: data)
                    // UserDefaults'a da ekle
                    var updatedLikedDataArray = likedDataArray
                    updatedLikedDataArray.append(data.id)
                    UserDefaults.standard.set(updatedLikedDataArray, forKey: "likedDataArray")
                } else {
                    print("Data already exists in Likes (Core Data). Skipping.")
                }
            } catch {
                print("Failed to check existing data: \(error)")
            }
        }
    }
    
    func removeLike(data: dataResponse) {
        let fetchRequest: NSFetchRequest<Likes> = Likes.fetchRequest()
        do {
            let existingLikes = try managedObjectContext.fetch(fetchRequest)
            if let existingLike = existingLikes.first(where: { Likes in
                Likes.id == data.id // id'lerin sorgulanması
            }) {
                // Eğer veri varsa, Core Data'dan silinir
                managedObjectContext.delete(existingLike)
                existingLike.isLike = false
                // Veriyi kullanıcı tercihlerinden (UserDefaults) de kaldırıyoruz
                var likedDataArray = UserDefaults.standard.array(forKey: "likedDataArray") as? [Int] ?? []
                if let index = likedDataArray.firstIndex(of: data.id) {
                    likedDataArray.remove(at: index)
                    UserDefaults.standard.set(likedDataArray, forKey: "likedDataArray")
                }
                print("Data removed from Likes (Core Data) and UserDefaults.")
            } else {
                print("Data does not exist in Likes (Core Data). Skipping removal.")
            }
            try managedObjectContext.save() // Değişiklikleri kaydet.
        } catch {
            print("Failed to check existing data or remove: \(error)")
        }
    }
    
    func toggleLike(data: dataResponse) {
        let fetchRequest: NSFetchRequest<Likes> = Likes.fetchRequest()
        do {
            let existingLikes = try managedObjectContext.fetch(fetchRequest)
            if let existingLike = existingLikes.first(where: { Likes in
                Likes.id == data.id // id'lerin sorgulanması
            }) {
                // Eğer veri varsa, Core Data'dan silinir
                managedObjectContext.delete(existingLike)
                // Veriyi kullanıcı UserDefaults'dan da kaldırıyoruz
                var likedDataArray = UserDefaults.standard.array(forKey: "likedDataArray") as? [Int] ?? []
                if let index = likedDataArray.firstIndex(of: data.id) {
                    likedDataArray.remove(at: index)
                    UserDefaults.standard.set(likedDataArray, forKey: "likedDataArray")
                }
                print("Data removed from Likes (Core Data) and UserDefaults.")
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
    
    func isLiked(data: dataResponse) -> Bool {
        let fetchRequest: NSFetchRequest<Likes> = Likes.fetchRequest()
        do {
            let existingLikes = try managedObjectContext.fetch(fetchRequest)
            if let existingLike = existingLikes.first(where: { Likes in
                Likes.id == data.id // id'lerin sorgulanması
            }) {
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
