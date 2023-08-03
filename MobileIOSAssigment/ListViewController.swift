//
//  ListViewController.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 15.06.2023.
//

import UIKit

class ListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    var listData: [dataResponse] = DataManager.shared.dataArray
    var searchData: [dataResponse] = []
    var isSearching: Bool = false
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // her bir item'ın boyutunu belirlediğimiz fonksiyon.
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 60) / 2 // Hücreler arasındaki boşluğu da hesaba katarak genişlik hesabı
        let cellHeight: CGFloat = 210
            
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // kaç section olacağıyla alakalı method
        return isSearching ? searchData.count : listData.count // kaç eleman olacağını döndürür.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Cell'lerin içerisindeki verileri göstermeye yarayan method
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listItem", for: indexPath) as? ListItemCollectionViewCell else { return UICollectionViewCell() }
        
        let item = searchData[indexPath.row]
        
        cell.getWidthHeightListItem(width: item.previewWidth, height: item.previewHeight)
        if let imageURL = URL(string: item.previewURL) {
            cell.imageView.kf.setImage(with: imageURL)
        }
        cell.comments.text = "(\(item.comments) Yorum)"
        cell.likes.text = String(item.likes)
        cell.views.text = "\(item.views) (görüntülenme)"
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            searchData = []
        } else {
            isSearching = true
            searchData = listData.filter{$0.user.lowercased().contains(searchText.lowercased())}
        }
        listCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listCollectionView.delegate = self 
        listCollectionView.dataSource = self
        searchBar.delegate = self
        
        listCollectionView.register(UINib(nibName: "ListItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listItem") // Burası hazırladığımız cell tasarımını collectiona tanıtır.
        
        let layout = UICollectionViewFlowLayout() // grid düzen oluşturmak için kullandığımız blok
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        listCollectionView.setCollectionViewLayout(layout, animated: true)
        print(listData)
    }
}
