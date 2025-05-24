//
//  APIManager.swift
//  Abhi Babriya
//
//  Created by Abhi Babriya on 24/05/25.
//

import Foundation

let headers = [
    "Authorization": "Bearer \(AUTH_TOKEN)",
    "Content-Type": "application/json"
]

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(statusCode: Int)
    case unknown(Error)
}

enum APIMethod: String {
    case get = "GET"
    case post = "POST"
}

class APIManager {
    static let shared = APIManager()
    private init() {}

    func request<T: Decodable>(
        urlString: String,
        method: APIMethod = .get,
        headers: [String: String]? = nil,
        body: Data? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        
        print("============== URL : \(urlString) ==============")
        print("============== body : \(String(data: body ?? Data(), encoding: .utf8) ?? "") ==============")
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error {
                completion(.failure(.unknown(err)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print("\n📦 Raw JSON response from \(url):\n\(prettyString)")
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                print("❌ JSON Decode error: \(error)")
                completion(.failure(.decodingError))
            }

        }.resume()
    }
}

