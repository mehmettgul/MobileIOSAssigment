//
//  ListViewController.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 15.06.2023.
//

import UIKit
import Alamofire

class ListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, ListItemCollectionViewCellDelegate{
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    var listData: [DataResponse] = []
    let baseUrl = "https://pixabay.com/api/"
    var viewmodel = ListViewmodel()
    var likeviewmodel = LikeViewmodel()
    var likedataviewmodel = LikeDataViewmodel()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // her bir item'ın boyutunu belirlediğimiz fonksiyon.
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 60) / 2 // Hücreler arasındaki boşluğu da hesaba katarak genişlik hesabı
        let cellHeight: CGFloat = 210
            
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // kaç section olacağıyla alakalı method
        return listData.count // kaç eleman olacağını döndürür.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = listData[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listItem", for: indexPath) as? ListItemCollectionViewCell else { return UICollectionViewCell() }
        
        cell.getWidthHeightListItem(width: item.previewWidth, height: item.previewHeight)
        if let imageURL = URL(string: item.previewURL) {
            cell.imageView.kf.setImage(with: imageURL)
        }
        let isLiked = likeviewmodel.isLiked(data: item)
        cell.isLiked = isLiked
        cell.delegate = self // ListItemCollectionViewCellDelegate protocolu'ünü kullanabilmek için kullanılır.
        cell.comments.text = "(\(item.comments) Yorum)"
        cell.likes.text = String(item.likes)
        cell.views.text = "\(item.views) (görüntülenme)"
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.isEmpty {
            listData.removeAll() // Mevcut verileri temizleyin.
            viewmodel.fetchData(with: query) { data in
                self.listData = data
                self.listCollectionView.reloadData()
            }
            searchBar.resignFirstResponder()
        }
    }
    
    @objc func listDataUpload() {
        DispatchQueue.main.async {
            self.listCollectionView.reloadData()
        }
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
        NotificationCenter.default.addObserver(self, selector: #selector(listDataUpload), name: NSNotification.Name("listDataUpload"), object: nil)
    }
    
    func didTapButtonInCell(_ cell: UICollectionViewCell) {
        guard let indexPath = listCollectionView.indexPath(for: cell) else {
            return
        }
        let selectedItem = listData[indexPath.row]
        likeviewmodel.toggleLike(data: selectedItem)
    }
    
}
