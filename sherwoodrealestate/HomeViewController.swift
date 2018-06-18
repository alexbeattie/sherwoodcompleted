//
//  ViewController.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 5/21/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import UIKit
import SafariServices

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SFSafariViewControllerDelegate {
    
    let cellId = "cellId"
    
    var newList:Listing!
    
    var listings: [Listing.listingResults]?

    var photos : [Listing.standardFields.PhotoDictionary]?
    var picture = [[String: Any]]()


    

    override func viewDidLoad() {
        super.viewDidLoad()
        Listing.standardFields.fetchListing { (listings) -> () in
            self.listings = listings.D.Results
           // print(listings.D.Results)
            self.collectionView?.reloadData()

        }
        
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x:0, y:0, width:view.frame.width - 32, height:view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize:20)
        navigationItem.titleView = titleLabel

        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.dataSource = self
        collectionView?.delegate = self

//        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)

//        setupCollectionView()
        //setupMenuBar()
        setupNavBarButtons()


    }
//    func setupCollectionView() {
//        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.scrollDirection = .horizontal
//            flowLayout.minimumLineSpacing = 0
//        }
//
//        collectionView?.backgroundColor = UIColor.white
//
//        //        collectionView?.registerClass(VideoCell.self, forCellWithReuseIdentifier: "cellId")
//        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
//
//        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
//
//        collectionView?.isPagingEnabled = true
//    }
    
    func setupNavBarButtons() {
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        //let searchBarButtonItem = UIBarButtonItem(image: "search_icon", style: .Plain, target: self, action: #selector(handleSearch))
        
        let moreButton = UIBarButtonItem(image: UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreButton, searchBarButtonItem]
        

    }
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    @objc func handleMore() {
        print(123)
        //show menu
        settingsLauncher.showSettings()
    }
    func showControllerForSetting(setting: Setting) {
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.view.backgroundColor = UIColor.white
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    func showControllerForMap(_ setting: Setting) {
        
        let mapVC = AllListingsMapVC()
        navigationController?.pushViewController(mapVC, animated: true)
        
//        let TermsController = UIViewController()
//        TermsController.view.backgroundColor = UIColor.white
//        TermsController.navigationItem.title = setting.name.rawValue
//        navigationController?.navigationBar.tintColor = UIColor.white
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        navigationController?.pushViewController(TermsController, animated: true)

//        guard let url = URL(string: "http://sherwoodrealestate.com/about-us") else {
//            print("Unable to construct Github Repo URL")
//            return
//        }
//        let safariViewController = SFSafariViewController(url: url)
//        safariViewController.delegate = self
//        self.present(safariViewController, animated: true)
        
        
        }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
        
    }

    func showControllerForFeedBack(_ setting: Setting) {
        print(123)
    }
    @objc func handleSearch() {
        print(123)
    }
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:|[v0(50)]", views: menuBar)
    }

//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let height = (view.frame.width - 16 - 16) * 9 / 16
//        return CGSize(width: view.frame.width, height: height + 16 + 88)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }

    
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
            
            if let thePhoto = listing?.StandardFields.Photos {
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

