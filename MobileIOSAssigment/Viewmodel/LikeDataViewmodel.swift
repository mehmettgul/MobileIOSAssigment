//
//  LikeDataManager.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 7.08.2023.
//

import Foundation
import CoreData
import UIKit

class LikeDataViewmodel {
    
    static let shared = LikeDataViewmodel()
    var likeDataArray: [DataResponse] = []
    
    private var managedObjectContext: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func fetchLikes() -> [Likes] {
        let fetchRequest: NSFetchRequest<Likes> = Likes.fetchRequest()
        NotificationCenter.default.post(name: NSNotification.Name("DataUpdated"), object: nil)
        do {
            let likes = try managedObjectContext.fetch(fetchRequest)
            return likes
        } catch {
            print("Failed to fetch likes: \(error)")
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
    
}
