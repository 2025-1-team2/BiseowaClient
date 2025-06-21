//
//  NetworkManager.swift
//  BiseowaClient
//
//  Created by minji on 6/22/25.
//


import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func sendSummaryRequest(text: String,
                            completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://your-backend.com/summarize") else {
            return
        }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["text": text]
        req.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: req) { data, res, err in
            if let err = err {
                return completion(.failure(err))
            }
            guard let data = data,
                  let json = try? JSONDecoder().decode([String: String].self, from: data),
                  let summary = json["summary"]
            else {
                return completion(.failure(NSError(domain: "parsing", code: -1)))
            }
            DispatchQueue.main.async {
                completion(.success(summary))
            }
        }.resume()
    }
}
