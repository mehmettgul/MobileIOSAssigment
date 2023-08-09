//
//  LikesViewController.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 15.06.2023.
//

import UIKit
import Kingfisher

class LikesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var likeCollectionView: UICollectionView!
    
    var likeDataManager = LikeDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        likeCollectionView.delegate = self
        likeCollectionView.dataSource = self
        
        likeCollectionView.register(UINib(nibName: "LikeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "likeItem")
        
        let layout = UICollectionViewFlowLayout() // grid düzen oluşturmak için kullandığımız blok
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20 // Hücreler arasındaki boşluk
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) // Hücreler ile ekran arasındaki boşluk
        likeCollectionView.setCollectionViewLayout(layout, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(dataUpdated), name: NSNotification.Name("DataUpdated"), object: nil) // LikeDataManager kısmında yollanan bildirim burda yakalanır ve dataUpdated adındaki fonksiyon çalıştırılarak collectionView güncellenir.
    }
    
    @objc func dataUpdated() {
        DispatchQueue.main.async {
            self.likeCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likeDataManager.countData(entityName: "Likes")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // İtemlerın boyutlarının belirlendiği kısım.
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 60) / 2 // Hücreler arasındaki boşluğu da hesaba katarak genişlik hesabı
        let cellHeight: CGFloat = 210
            
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likeItem", for: indexPath) as? LikeCollectionViewCell else { return UICollectionViewCell() }
        
        let like = likeDataManager.fetchLikes()[indexPath.item]
        
        if let imageURL = URL(string: like.image ?? "") { // cell'lerdeki image'ların çekilmesi.
            cell.likeImage.kf.setImage(with: imageURL)
        }
        cell.commentLabel.text = " (\(like.comment) Yorum)" // comments, like, görüntülenme bilgisi çekiliyor.
        cell.likeLabel.text = String(like.like)
        cell.viewLabel.text = "\(like.view) (görüntülenme)"
        
        return cell
    }
    
}
