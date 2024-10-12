import Foundation
import UIKit

final class ImageCache {
    private var cache: [URL: UIImage] = [:]

    func cacheImage(_ image: UIImage, for url: URL) {
        cache[url] = image
    }

    func image(for url: URL) -> UIImage? {
        return cache[url]
    }
}

final class ImageDownloader {
    private let imageCache = ImageCache()

    func downloadImage(from url: URL) async throws -> UIImage {
        if let cachedImage = imageCache.image(for: url) {
            return cachedImage
        }

        let data = try await downloadImageData(from: url)
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "InvalidImageData", code: 0, userInfo: nil)
        }

        imageCache.cacheImage(image, for: url)
        return image
    }
    
    func downloadImageData(from url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
//        print("the response is \(response)")
        return data
    }
}

