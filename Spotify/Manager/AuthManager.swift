//
//  AuthManager.swift
//  Spotify
//
//  Created by A'zamjon Abdumuxtorov on 01/02/26.
//

import Foundation

@MainActor
final class AuthManager {
    static let shared = AuthManager()
    
    private var refreshingToken = false
    private var onRefreshBlocks = [((String) -> Void)]()
    
    struct Constants {
        static let clientID = "87510d91dc934b108f95939901ce613b"
        static let clientSecret = "1f89ee6154e44913927b503299cbc37d"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.iosacademy.io"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-modify-private%20playlist-read-private%20user-follow-read%20user-library-read%20user-library-modify%20user-read-email"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let baseURL = "https://accounts.spotify.com/authorize"
        let redirectURI = Constants.redirectURI
        let urlString = "\(baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: urlString)
    }
    
    public var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    func exchangeCodeForToken(code: String) async throws -> Void {
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value:  Constants.redirectURI)
        ]
        
        try await apiRequest(components: components)
    }
    
  
    
    func withValidToken() async throws -> String {
        if refreshingToken {
            return try await withCheckedThrowingContinuation { continuation in
                onRefreshBlocks.append { token in
                    continuation.resume(returning: token)
                }
            }
        }
        if shouldRefreshToken {
            try await refreshIfNeeded()
        }
        
        if let token = accessToken {
            return token
        }
        throw URLError(.userAuthenticationRequired)
    }
    
    func refreshIfNeeded () async throws -> Void {
        guard !refreshingToken else { return}
        
        guard let refreshToken = refreshToken else { return }
        
        guard shouldRefreshToken else { return }
        
        refreshingToken = true
        defer{ refreshingToken = false }
    
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        try await apiRequest(components: components)
        
    }
    
    private func apiRequest(components:URLComponents) async throws -> Void {
        guard let url = URL(string: Constants.tokenAPIURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = "\(Constants.clientID):\(Constants.clientSecret)"
        guard let base64String = basicToken.data(using: .utf8) else {
            print("Failed to get base64")
            throw URLError(.badURL)
        }
        
        request.setValue("Basic \(base64String.base64EncodedString())",
                         forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        do{
            let result = try JSONDecoder().decode(AuthResponse.self, from: data)
            cacheToken(result: result)
            self.onRefreshBlocks.forEach { $0(result.access_token) }
            self.onRefreshBlocks.removeAll()
        }catch {
            print("Failed to parse token response: \(error)")
            throw error
        }
    }
    
    private func cacheToken(result: AuthResponse){
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
    
}



