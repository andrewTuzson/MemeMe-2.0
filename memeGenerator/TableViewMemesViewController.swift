//
//  TableViewMemesViewController.swift
//  memeGenerator
//
//  Created by Andrew Tuzson on 12/31/17.
//  Copyright © 2017 Andrew Tuzson. All rights reserved.
//

import UIKit

class TableViewMemesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme]! {
        didSet {
            tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let meme = memes[indexPath.row]
        cell?.imageView?.image = meme.memedImage
        cell?.textLabel?.text = meme.topText
        cell?.imageView?.contentMode = .scaleAspectFit
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        let detailController = UIStoryboard(name: "DetailsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailController.memeImage = meme.memedImage //Pass image like this
        self.navigationController?.pushViewController(detailController, animated: true)
    }

}








