//
//  ViewController.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 5/21/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    var newList:Listing!
    
    var listings: [Listing.listingResults]?
    
    var photos: [Listing.standardFields.PhotoDictionary]?
//    var photos: [Listing.photoResults]?
//    var token:Listing.resultsArr!
//    let photo = [String: Any]()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        Listing.standardFields.fetchListing { (listings) -> () in
            self.listings = listings.D.Results
            print(listings.D.Results)

            


            
            self.collectionView?.reloadData()

        }
        
        navigationItem.title = "Sherwood Real Estate"
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.dataSource = self
        collectionView?.delegate = self

    }
    func showListingDetailController(_ listing: Listing.listingResults) {
        let layout = UICollectionViewFlowLayout()
        let listingDetailController = ListingDetailController(collectionViewLayout: layout)
        
        
        listingDetailController.listing = listing
        
        
        navigationController?.pushViewController(listingDetailController, animated: true)
    }
    // MARK: - Home CollectionViewController
    
    let homeCollectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
        
    }()
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
        
        cell.listing = listings?[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = listings?.count {
            
            
            return count
        }
        return 0
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let listing = listings?[indexPath.item] {
            showListingDetailController(listing)
        }
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}

class HomeCell: UICollectionViewCell {
    var listing: Listing.listingResults? {
        didSet {
            
            setupThumbNailImage()
            if let thePhoto = listing?.StandardFields.Photos[0] {
                print(thePhoto)
            }
            if let theAddress = listing?.StandardFields.UnparsedAddress {
                nameLabel.text = theAddress
            }
            if let listPrice = listing?.StandardFields.ListPrice {
                let nf = NumberFormatter()
                nf.numberStyle = .decimal
                let subTitleCost = "$\(nf.string(from: NSNumber(value:(UInt64(listPrice))))!)"
                costLabel.text = subTitleCost
            }
            
        }
    }
//
//    var photo: Listing.photoResults? {
//        didSet {
//            if let newPic = self.photo {
//                self.photo = newPic
//
//            }
//            self.setupThumbNailImage()
//
//        }
//    }
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Best New Apps"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let costLabel: UILabel = {
        let label = UILabel()
        label.text = "400"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"pic")
//        iv.backgroundColor = UIColor.black
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        return iv
    }()

    func setupThumbNailImage() {
        
//        if let thePhoto = listing?.StandardFields.Photos {
//            print(thePhoto)
//        }

        if let thumbnailImageUrl = listing?.StandardFields.Photos[0].Uri1600 {
            imageView.loadImageUsingUrlString(urlString: (thumbnailImageUrl))
        }
    }
    func setupViews() {
        backgroundColor = UIColor.clear
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(costLabel)
        
        addConstraintsWithFormat(format: "H:|-14-[v0]-14-|", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0]-20-|", views: nameLabel)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: costLabel)
        addConstraintsWithFormat(format: "V:[v0]-8-|", views: costLabel)
        
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
        
    }
}








extension UIImageView {
    func loadImageUsingUrlString(urlString: String) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data:data!)
            }
            
        }).resume()
    }
}








extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views:viewsDictionary))
    }
    
}
class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
    }
}

