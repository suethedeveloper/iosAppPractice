//
//  RottonTomatoTableViewController.swift
//  RtTomato
//
//  Created by Sue Lucas on 9/26/15.
//  Copyright © 2015 Sue Lucas. All rights reserved.
//

import UIKit

class RottonTomatoTableViewController: UITableViewController {

    var moviesArray: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiKey = "vex9ab8yex8f5jfj5ch3yft7"
        let url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json?apikey=\(apiKey)")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    if let downloadedData = data,
                        json = try! NSJSONSerialization.JSONObjectWithData(downloadedData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary,
                        movies = json["movies"] as? [NSDictionary] {
                            dispatch_async(dispatch_get_main_queue()){
                            self.moviesArray = movies
                                self.tableView.reloadData()
                            }
                    }
                default:
                    NSLog("Unexpected response code: \(httpResponse.statusCode)")
                }
            }
        }
        task.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return moviesArray?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieTableViewCell

         //Configure the cell...
        if let moviesArray = self.moviesArray {
            let movie = moviesArray[indexPath.row]
            let movieTitile = movie["title"] as? String ?? "Missing Title!"
            let movieDescription = movie["synopsis"] as? String ?? "Missing Description!"
            
            cell.movieTitleLabel.text = movieTitile
            cell.movieDescriptionLabel.text = movieDescription
            
            if let posters = movie["posters"] as? NSDictionary, posterURLString = posters["thumbnail"] as? String,
                posterURL = NSURL(string: posterURLString) {
                cell.posterURL = posterURL
                self.downloadImageURL(posterURL, forCell: cell)
            }
            cell.imageView?.image = nil
        }
        

        return cell
    }
    
    /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = UIViewController
    }
    */
    
    func downloadImageURL(url: NSURL, forCell: MovieTableViewCell) {
       let request = NSURLRequest(URL: url, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 10.0)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            if let httpResponse = response as? NSHTTPURLResponse, downloadedImageData = data  where httpResponse.statusCode == 200 {
                dispatch_async(dispatch_get_main_queue()) {
                    if httpResponse.URL == forCell.posterURL {
                        let image = UIImage(data: downloadedImageData)
                        forCell.moviePosterImageView.image = image
                    } else {
                        //wrong poster for this cell!
                    }
                }
            }
        }
            task.resume()
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
