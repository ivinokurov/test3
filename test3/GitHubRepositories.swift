//
//  GitHubRepositories.swift
//  test3
//
//  Created by И.В. Винокуров
//

import Foundation
import Alamofire

class GitHubRepositories {

    private let baseURL = "https://api.github.com/users/"
    private var isReady: Bool = false
    
    func getRequestURL() -> String? {
        print("Enter GinHub login")
        if let login = readLine() {
            return baseURL + login + "/repos"
        } else {
            return nil
        }
    }
    
    func printRepositoryFullNames(requestURL: String) {
        AF.request(requestURL, method: .get, encoding: JSONEncoding.default).responseJSON { [weak self] response in
            guard let self = self else { return }
            switch response.result {
                case .success(let json):
                    if let jsonDic = json as? [NSDictionary] {
                        for dicItem in jsonDic {
                            print(dicItem["full_name"]!)
                        }
                    }
                case .failure(let error):
                    print(error)
            }
            self.isReady = false
        }
    }
    
    func printRepositoriesList() {
        guard let requestURL = getRequestURL() else { return }
        
        self.isReady = true
        self.printRepositoryFullNames(requestURL: requestURL)
        
        while self.isReady && RunLoop.current.run(mode: RunLoop.Mode.default, before: Date(timeIntervalSinceNow: 0.1)) {}
    }
}
