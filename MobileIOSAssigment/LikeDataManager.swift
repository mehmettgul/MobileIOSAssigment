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
        print("add deniyoruz")
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
}
/*func deleteAllEntities(entityName: String, context: NSManagedObjectContext) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Likes")
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
        try context.execute(batchDeleteRequest)
        try context.save()
        print("\(Likes.self) entities deleted successfully.")
    } catch {
        print("Error deleting entities: \(error)")
    }
}*/
