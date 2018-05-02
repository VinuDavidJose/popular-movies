//
//  MovieListCell.swift
//  PopularMovies
//
//  Created by David Jose on 01/05/18.
//  Copyright © 2018 VinuDavidJose. All rights reserved.
//

import UIKit


class MovieListCell : UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    var imageLoadDataTask:URLSessionDataTask?
    var imageURL: URL? {
        didSet {
            self.iconImage.sd_setImage(with:imageURL, placeholderImage: UIImage(named: "placeholder.png"))
        }
    }

    func setData(movie:PopularMovie)  {
        self.titleLabel.text = movie.title
        self.ratingLabel.text = "Rating - " + String(describing: movie.vote_average)
        if let movieUrl = movie.poster_path {
            self.imageURL = URL(string:MovieEndpoints.ImageBase + movieUrl)
        }
        
    }
    
    
}

