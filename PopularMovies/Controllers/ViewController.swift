//
//  ViewController.swift
//  PopularMovies
//
//  Created by David Jose on 01/05/18.
//  Copyright © 2018 VinuDavidJose. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
 var reachability : Reachability?
    private var movies =  [PopularMovie]()
    private let cellIdentifier = "movieCell"
    var selectedMovie :PopularMovie?
    @IBOutlet weak var movieListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpReachbility()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeReachability()
    }
    func initialSetup() {
        title = "Popular Movies"
        movieListTable.estimatedRowHeight = 100
        
        if NetworkReachability.isConnectedToNetwork() {
            fetchPopularMovieList()
        } else {
            getDataFromCoreData()
        }
    }
    func fetchPopularMovieList() {
        NetworkClient.sharedClient.getMovieListFromAPI(page: 1, completion:{data, error in
            
            if let movieList = data {
               self.saveDataInCoreData(data: movieList)
            }
            
        })
    }
    
    func setUpReachbility() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachbailityChanged), name: NSNotification.Name.reachabilityChanged, object:nil)
        self.reachability = Reachability.forInternetConnection()
        self.reachability!.startNotifier()

    }


    func removeReachability() {
        self.reachability!.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.reachabilityChanged, object: nil)
    }

    @objc func reachbailityChanged(notification : Notification) {
        let remoteHostStatus = self.reachability?.currentReachabilityStatus()
        if (remoteHostStatus?.rawValue != NotReachable.rawValue) {
            print("Internet Available")
            fetchPopularMovieList()
        } else {
            print("Internet Gone")
            getDataFromCoreData()
        }
    }
    
    func  saveDataInCoreData(data: [Movie]) {
        movies.removeAll()
        deleteAllDataInCoreData()
        DispatchQueue.main.sync {
            for eachMovie in data {
                let movie = PopularMovie(context: PersistenceService.context)
                guard let name = eachMovie.title else { return }
                guard let voteAvg = eachMovie.vote_average else { return }
                guard let id = eachMovie.id else { return }
                guard let poster_path = eachMovie.poster_path else { return }
                guard let overview = eachMovie.overview else { return }
                
                movie.title = name
                movie.vote_average = voteAvg
                movie.id = id
                movie.poster_path = poster_path
                movie.overview = overview
                
                PersistenceService.saveContext()
                self.movies.append(movie)
            }
            reloadMovieListTable()
        }
       
       
    }
    func reloadMovieListTable() {
        DispatchQueue.main.async {
            self.movieListTable.reloadData()
        }
    }
    
    func getDataFromCoreData() {
        let fetchRequest : NSFetchRequest<PopularMovie> = PopularMovie.fetchRequest()
        do {
            let movieList = try PersistenceService.context.fetch(fetchRequest)
            self.movies = movieList
            reloadMovieListTable()
        } catch {
            print(error.localizedDescription)
        }
    }
    func deleteAllDataInCoreData() {
        let fetchRequest : NSFetchRequest<PopularMovie> = PopularMovie.fetchRequest()
        _ = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MovieConstant.segueListDetailIdentifier {
            let movieDetail = segue.destination as! MovieDetailViewController
            movieDetail.movie = selectedMovie
        }
    }
}


extension ViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:cellIdentifier) as! MovieListCell
        cell.setData(movie:movies[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = self.movies[indexPath.row]
        self.performSegue(withIdentifier:MovieConstant.segueListDetailIdentifier, sender: nil)
    
    }
    }


