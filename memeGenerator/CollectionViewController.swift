//
//  CollectionViewController.swift
//  memeGenerator
//
//  Created by Angela Tuzson on 12/31/17.
//  Copyright © 2017 Andrew Tuzson. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var memes: [Meme]! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.imageView.image = memes[indexPath.row].memedImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        let detailController = UIStoryboard(name: "DetailsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        present(detailController, animated: true, completion: nil)
        detailController.detailsImageView.image = meme.memedImage
    }


}
