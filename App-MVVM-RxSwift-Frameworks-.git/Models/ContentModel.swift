//
//  ContentModel.swift
//  App-MVVM-RxSwift-Frameworks-.git
//
//  Created by Александр Муклинов on 14.06.2024.
//

import Foundation
import CoreData

struct ContentModel: Decodable {
    
    var news: [News] = []
    
    enum ContentKeys: String, CodingKey{
        case contentKey = "articles"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContentKeys.self)
        self.news = try container.decode([News].self, forKey: .contentKey)
    }
    
    struct News: Decodable {
        
        //for JSON
        var title: String?
        var publishedAt: Date?
        var description: String?
        var urlToImage: URL?
        var urlToSourсe: URL?
        
        //for storageData
        var imageData: Data?
        var uniqueNewsIdentifier: String?
        
        private enum CodingKeys: String, CodingKey {
            case title, publishedAt, description, urlToImage, urlToSourсe = "url"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try container.decodeIfPresent(String.self, forKey: .title)
            self.publishedAt = try container.decodeIfPresent(Date.self, forKey: .publishedAt)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            if let urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage),
               let url = URL(string: urlToImage) {
                self.urlToImage = url
            }
            if let urlToSource = try container.decodeIfPresent(String.self, forKey: .urlToSourсe) {
                if let url = URL(string: urlToSource) {
                    self.urlToSourсe = url
                }
                self.uniqueNewsIdentifier = urlToSource
            }
        }
        
        init(title: String, publishedAt: Date, description: String, urlToSource: URL, imageData: Data?, uniqueNewsIdentifier: String) {
            self.title = title
            self.publishedAt = publishedAt
            self.description = description
            self.urlToSourсe = urlToSource
            self.imageData = imageData
            self.uniqueNewsIdentifier = uniqueNewsIdentifier
        }
    }
}
