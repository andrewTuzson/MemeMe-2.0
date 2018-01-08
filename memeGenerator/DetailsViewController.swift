//
//  DetailsCollectionViewCell.swift
//  memeGenerator
//
//  Created by Angela Tuzson on 1/1/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var memeImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsImageView.image = memeImage
    }
    
    @IBOutlet weak var detailsImageView: UIImageView!
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
