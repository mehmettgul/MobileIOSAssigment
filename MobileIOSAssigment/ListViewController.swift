//
//  ListViewController.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 15.06.2023.
//

import UIKit

class ListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // her bir item'ın sağdan soldan yukardan ve aşağıdan boşluklarını belirtir.
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // her bir item'ın boyutunu belirlediğimiz fonksiyon.
        let gridLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - gridLayout.minimumInteritemSpacing
        return CGSize(width:widthPerItem, height:300)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // kaç section olacağıyla alakalı method
        return 50 // kaç eleman olacağını döndürür.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Cell'lerin içerisindeki verileri göstermeye yarayan method
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listItem", for: indexPath) as? ListItemCollectionViewCell else { return UICollectionViewCell() } // guard ve if aynı guard hatayı başta yakalar.
            // dequeueReusableCell bunun amacı hücre yeniden kullanılabilir. hücre içindeki veriler silinse de değişse de yeniden aynı hücre kullanılabilir.
        cell.comments.text = "Bu bir yorumdur" // comments, like, görüntülenme bilgisi çekiliyor.
        cell.likes.text = "123"
        cell.views.text = "1231k (görüntülenme)"
        cell.topToDetailButtonClicked = { // segue yaptığımız bölüm
            self.performSegue(withIdentifier: "ListToDetail", sender: self)
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listCollectionView.delegate = self 
        listCollectionView.dataSource = self
        
        listCollectionView.register(UINib(nibName: "ListItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listItem") // Burası hazırladığımız cell tasarımını collectiona tanıtır.
        
        let layout = UICollectionViewFlowLayout() // grid düzen oluşturmak için kullandığımız blok
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        listCollectionView.setCollectionViewLayout(layout, animated: true)
        
    }

}
