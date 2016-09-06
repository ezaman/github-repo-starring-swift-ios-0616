//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit


class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/repositories?client_id=\(Secrets.githubClientID)&client_secret=\(Secrets.githubClientSecret)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }
        task.resume()
    }
    
    
    class func checkIfRepositoryIsStarred(fullName: String, completion: Bool -> ()) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let urlString = "\(Secrets.githubStarApiUrl)/\(fullName)"
        
        let url = NSURL(string: urlString)
        //let session = NSURLSession.sharedSession()
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "GET"
        request.addValue("\(Secrets.token)", forHTTPHeaderField: "Authorization")
        let task = session.dataTaskWithRequest(request) {data, response, error in
            guard let responseResult = response as? NSHTTPURLResponse else {
                assertionFailure("not working")
                return
            }
            
            if responseResult.statusCode == 204 {
                completion(true)
                 print("204 working")
            }else if responseResult.statusCode == 404 {
                completion(false)
                print("404 fix error")
            }else {
                print("Other status code \(responseResult.statusCode)")
            }
            
        }
        task.resume()
    }
    
    class func starRepository(fullName: String, completion:() -> ()) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let urlString = "\(Secrets.githubStarApiUrl)/\(fullName)"
        
        let url = NSURL(string: urlString)
        //let session = NSURLSession.sharedSession()
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "PUT"
        request.addValue("\(Secrets.token)", forHTTPHeaderField: "Authorization")
        let task = session.dataTaskWithRequest(request) {data, response, error in
            guard let responseResult = response as? NSHTTPURLResponse else {
                assertionFailure("not working")
                return
            }
            
            if responseResult.statusCode == 204 {
                completion()
               
            }else {
                print("Other status code \(responseResult.statusCode)")
            }
            
            
            
            
        }
        task.resume()
        
    }
    
    class func unStarRepository(fullName: String, completion:() -> ()) {
       let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let urlString = "\(Secrets.githubStarApiUrl)/\(fullName)"
        
        let url = NSURL(string: urlString)
        //let session = NSURLSession.sharedSession()
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "DELETE"
        request.addValue("\(Secrets.token)", forHTTPHeaderField: "Authorization")
        let task = session.dataTaskWithRequest(request) {data, response, error in
            guard let responseResult = response as? NSHTTPURLResponse else {
                assertionFailure("not working")
                return
            }
            
            if responseResult.statusCode == 204 {
                completion()
            }else {
                print("Other status code \(responseResult.statusCode)")
            }
            
            
    
            
        }
        task.resume()
        
    }

}
