import UIKit
import SafariServices


class SuggestionsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var suggestionsTableView: UITableView!
    
    @IBOutlet weak var typeSegmented: UISegmentedControl!
    
    var movies: [Movie] = []
    var tvShows: [TVShow] = []
    var musics: [Music] = []
    var books: [Book] = []
    var podcasts: [Podcast] = []
    
    var mood : String?
    
    var kindArr = [] as [Any]
    
    var pageNumber : Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        suggestionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieCell")
        
        typeSegmented.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        pageNumber = Int.random(in: 1...1000)
        
        fetchMovies(kindid: kindArr[0] as! Int, pageNumber: pageNumber!)
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        
        switch selectedSegmentIndex {
        case 0:
            fetchMovies(kindid: kindArr[0] as! Int, pageNumber: pageNumber!)
        case 1:
            fetchTVShows(kindid: kindArr[1] as! Int, pageNumber: pageNumber!)
        case 2:
            fetchMusic(kindid: kindArr[2] as! String)
        case 3:
            fetchBooks(kindid: kindArr[3] as! String)
        case 4:
            fetchPodcasts(kindid: kindArr[4] as! String)
        default:
            break
        }
       
    }

    func fetchMovies(kindid: Int, pageNumber : Int) {
        let apiKey = "d83edfbfcf04c95730e60df1879ce8f0"
        
        let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&with_genres=\(kindid)&sort_by=popularity.desc&page=\(pageNumber)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let results = json?["results"] as? [[String: Any]] {
                    self.movies = results.prefix(10).compactMap { dict in
                        guard let title = dict["title"] as? String,
                              let releaseDate = dict["release_date"] as? String,
                              let overview = dict["overview"] as? String,
                              let movieId = dict["id"] as? Int else {
                            return nil
                        }
                        let tmdbUrl = "https://www.themoviedb.org/movie/\(movieId)"
                        return Movie(title: title, releaseDate: releaseDate, overview: overview, tmdbUrl: tmdbUrl)
                    }
                    DispatchQueue.main.async {
                        self.suggestionsTableView.reloadData()
                    }
                } else {
                    print("Invalid JSON structure")
                }
            } catch let parseError {
                print("Parse error: \(parseError.localizedDescription)")
            }
        }

        task.resume()
    }
    
    func fetchTVShows(kindid: Int,pageNumber : Int ) {
        let apiKey = "d83edfbfcf04c95730e60df1879ce8f0"
        let urlString = "https://api.themoviedb.org/3/discover/tv?api_key=\(apiKey)&with_genres=\(kindid)&sort_by=popularity.desc&page=\(pageNumber)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let results = json?["results"] as? [[String: Any]] {
                    self.tvShows = results.prefix(10).compactMap { dict in
                        guard let name = dict["name"] as? String,
                              let firstAirDate = dict["first_air_date"] as? String,
                              let overview = dict["overview"] as? String,
                              let tvId = dict["id"] as? Int else {
                            return nil
                        }
                        let tmdbUrl = "https://www.themoviedb.org/tv/\(tvId)"
                        return TVShow(name: name, firstAirDate: firstAirDate, overview: overview, tmdbUrl: tmdbUrl)
                    }
                    DispatchQueue.main.async {
                        self.suggestionsTableView.reloadData()
                    }
                } else {
                    print("Invalid JSON structure")
                }
            } catch let parseError {
                print("Parse error: \(parseError.localizedDescription)")
            }
        }

        task.resume()
    }
    
    func fetchMusic(kindid: String) {
        // Spotify erişim belirtecinizi buraya ekleyin
        let accessToken = "BQAWPPXrPPhU54nBvlrU-0k4QnzrWikY2Wd5urWRKw2kURMjKsyi56bTonIdeHyAX3J4W8RnhJtmvrf7IDrkBBIboKCmMnQQ02Yhtp8dkh5WqppDQng"
        
        // 'üzgün' (sad) türünde müzikleri çekmek için Spotify API URL'si
        let query = kindid.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.spotify.com/v1/search?type=track&limit=10&q=\(query)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data")
                return
            }

            do {
                // JSON verilerini işleyin
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let tracks = json!["tracks"] as? [String: Any], let items = tracks["items"] as? [[String: Any]] {
                    // Music model nesnelerini oluşturun
                    self.musics = items.compactMap { dict in
                        guard let name = dict["name"] as? String,
                              let album = dict["album"] as? [String: Any],
                              let albumName = album["name"] as? String,
                              let artists = dict["artists"] as? [[String: Any]],
                              let artistName = artists.first?["name"] as? String,
                              let externalUrls = dict["external_urls"] as? [String: Any],
                              let spotifyUrl = externalUrls["spotify"] as? String else {
                            return nil
                        }
                        return Music(name: name, artist: artistName, album: albumName, spotifyUrl: spotifyUrl)
                    }
                    DispatchQueue.main.async {
                        self.suggestionsTableView.reloadData()
                    }
                } else {
                    print("Invalid JSON structure")
                    // Debugging: Print the raw JSON response
                    print(String(data: data, encoding: .utf8) ?? "Invalid data")
                }
            } catch let parseError {
                print("Parse error: \(parseError.localizedDescription)")
            }
        }
        
        task.resume()
    }

    
    
    func fetchBooks(kindid: String) {
        let query = kindid // Arama terimini buraya ekleyin
        let urlString = "https://openlibrary.org/search.json?q=\(query)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Invalid response or status code")
                return
            }

            guard let data = data else {
                print("No data")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let docs = json?["docs"] as? [[String: Any]] {
                    self.books = docs.compactMap { dict in
                        guard let title = dict["title_suggest"] as? String,
                              let authorNames = dict["author_name"] as? [String] else {
                            return nil
                        }
                        let author = authorNames.joined(separator: ", ")
                        let publishedDate = dict["first_publish_year"] as? String
                        let description = dict["first_sentence"] as? [String]
                        return Book(title: title, author: author, publishedDate: publishedDate, description: description?.first)
                    }
                    DispatchQueue.main.async {
                        self.suggestionsTableView.reloadData()
                    }
                } else {
                    print("Invalid JSON structure")
                }
            } catch let parseError {
                print("Parse error: \(parseError.localizedDescription)")
            }
        }
        
        task.resume()
    }


    
    func fetchPodcasts(kindid: String) {
        let query = kindid // Arama terimini buraya ekleyin
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Failed to encode query")
            return
        }
        let urlString = "https://itunes.apple.com/search?term=\(encodedQuery)&entity=podcast&limit=10"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data")
                return
            }

            // Debugging: Print the raw JSON response
            print(String(data: data, encoding: .utf8) ?? "Invalid data")

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]] {
                    
                    self.podcasts = results.compactMap { dict in
                        guard let trackName = dict["trackName"] as? String,
                              let collectionName = dict["collectionName"] as? String,
                              let trackUrl = dict["collectionViewUrl"] as? String else {
                            return nil
                        }
                        let releaseDate = dict["releaseDate"] as? String
                        let artworkUrl = dict["artworkUrl100"] as? String
                        return Podcast(trackName: trackName, collectionName: collectionName, releaseDate: releaseDate, artworkUrl: artworkUrl, trackUrl: trackUrl)
                    }
                    
                    DispatchQueue.main.async {
                        self.suggestionsTableView.reloadData()
                    }
                } else {
                    print("Invalid JSON structure")
                }
            } catch let parseError {
                print("Parse error: \(parseError.localizedDescription)")
            }
        }
        
        task.resume()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch typeSegmented.selectedSegmentIndex {
               case 0:
                   return movies.count
               case 1:
                   return tvShows.count
               case 2:
                   return musics.count
               case 3:
                   return books.count
               case 4:
                   return podcasts.count
               default:
                   return 0
               }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
           
           switch typeSegmented.selectedSegmentIndex {
           case 0:
               let movie = movies[indexPath.row]
               cell.textLabel?.text = movie.title
           case 1:
               let show = tvShows[indexPath.row]
               cell.textLabel?.text = show.name
           case 2:
               let music = musics[indexPath.row]
               cell.textLabel?.text = music.name
           case 3:
               let book = books[indexPath.row]
               cell.textLabel?.text = book.title
           case 4:
               let podcast = podcasts[indexPath.row]
               cell.textLabel?.text = podcast.trackName
           default:
               break
           }
           
           return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           switch typeSegmented.selectedSegmentIndex {
           case 0:
               // Filmler
               let movie = movies[indexPath.row]
               if let url = URL(string: movie.tmdbUrl) {
                   let safariVC = SFSafariViewController(url: url)
                   present(safariVC, animated: true, completion: nil)
               }
               
           case 1:
               // TV şovları
               let tvShow = tvShows[indexPath.row]
                if let url = URL(string: tvShow.tmdbUrl) {
                    let safariVC = SFSafariViewController(url: url)
                    present(safariVC, animated: true, completion: nil)
                } else {
                    print("Invalid TMDb URL")
                }
               
           case 2:
               //müzikler
               let music = musics[indexPath.row]
               if let url = URL(string: music.spotifyUrl) {
                   let safariVC = SFSafariViewController(url: url)
                   present(safariVC, animated: true, completion: nil)
               }
               
           case 3:
               // Kitaplar
               break
           case 4:
               // Podcast'ler 
               let podcast = podcasts[indexPath.row]
                 if let url = URL(string: podcast.trackUrl) {
                     let safariVC = SFSafariViewController(url: url)
                     present(safariVC, animated: true, completion: nil)
                 } else {
                     print("Invalid Podcast URL")
                 }
               
           default:
               break
           }
       }
   }

