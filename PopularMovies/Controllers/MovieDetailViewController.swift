//
//  MovieDetailViewController.swift
//  PopularMovies
//
//  Created by David Jose on 01/05/18.
//  Copyright © 2018 VinuDavidJose. All rights reserved.
//

import UIKit

enum MovieDetailSection: String {
    case Overview = "Overview"
    case Title = "Title"
}

class MovieDetailViewController: UITableViewController {
    @IBOutlet private weak var imageView: UIImageView!
    var movie: PopularMovie?
    var cast: [String] = []
    var order:[MovieDetailSection] = [.Title, .Overview]
    var imageLoadDataTask:URLSessionDataTask?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
        super.viewWillDisappear(animated)
    }
    
    func initView() {
        if movie != nil {
            title = movie?.title
            if let url = movie?.poster_path {
                self.imageView.sd_setImage(with:URL(string:MovieEndpoints.largeImageBase + url), placeholderImage: UIImage(named: "placeholder.png"))
            }
            else {
                self.tableView.tableHeaderView = nil
            }
        }
    }
    // MARK: Table view Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.order.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieDetailCell
        cell.label.text = textForCell(indexPath:indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.order[section].rawValue
    }
    
    func textForCell(indexPath i:IndexPath) -> String {
        let section = self.order[i.section]

        switch section {
        case .Overview:
            return movie?.overview ?? "No data"
        case .Title:
            return movie?.title ?? "No data"
        }
    }

}


