//
//  APICaller.swift
//  Spotify
//
//  Created by A'zamjon Abdumuxtorov on 03/02/26.
//

import Foundation

class APICaller{
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants{
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error{
        case failedToGetData
        case invalidResponse
    }
    
    func getCurrentUserProfile() async throws -> UserProfile{
        guard let url = URL(string: Constants.baseAPIURL + "/me") else {
            throw APIError.failedToGetData
        }
        
        let request = try await request(url: url, type: .GET)
        let (data, response) = try await URLSession.shared.data(for: request)
        debugPrint("Data: \(data), Response: \(response)")
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            if httpResponse.statusCode == 403 {
                print("Xato: Kirish taqiqlangan (Limit yoki Token xatosi)")
            }
        }
        
        if let jsonStr = String(data: data, encoding: .utf8) {
            print("Server Response JSON: \(jsonStr)")
        }
        
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(UserProfile.self, from: data)
            return result
        } catch{
            print(error.localizedDescription)
            throw APIError.failedToGetData
        }
    }
    
    // MARK: - Private
    
    enum HTTPMethod:String{
        case GET
        case POST
    }
    
    private func request(url:URL?,type: HTTPMethod) async throws -> URLRequest{
        let token = try await AuthManager.shared.withValidToken()
        print("Token: \(token)")
        guard let url = url else {return URLRequest(url: URL(string: "https://www.google.com")!)}
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = type.rawValue
        request.timeoutInterval = 30
        return request
    }
    
}
