//
//  NetworkModel.swift
//  Assignment3
//
//  Created by Cenk Bilgen on 2024-02-11.
//

import Foundation
import Combine

class PhotosState: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []

    @Published var photos: [FlickrService.Photo] = []

    @Published var photoData: [FlickrService.Photo.ID: Data] = [:]

    init(maxPhotos: Int = 5) {
        FlickrService
            .getList()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                    case .failure(let error):
                        print("Network Error. \(error.localizedDescription)")
                    case .finished:
                        print("Network Request Finished.")
                        print("Downloading Photo Data")
                        for photo in self.photos {
                            self.downloadPhotoData(photo: photo)
                        }
                }
            } receiveValue: { photos in
                print("Got \(photos.map { $0.title }.formatted(.list(type: .and)))")
                if !photos.isEmpty {
                    // randomly shuffle photos array and pick first maxCount (or up to count)
                    self.photos = Array(photos.shuffled()[0..<min(maxPhotos, photos.count)])
                }
            }
            .store(in: &cancellables) // this completes the publisher-subscriber connection and starts the network request
    }

    func downloadPhotoData(photo: FlickrService.Photo) {
        let request = URLRequest(url: photo.url)
        URLSession.DataTaskPublisher(request: request, session: .shared)
        // Output: (Data, URLResponse). Failure: URLError
            .tryMap { data, response in
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                guard statusCode == 200 else {
                    print("Response not OK. \(statusCode?.description ?? "")")
                    throw URLError(.badServerResponse)
                    // note: any returned status code is not really a "bad response"
                    // but keeping things simple
                    // should make our own HTTPError type and set Failure type to just Error
                }
                return data
            }
        // Output: Data. Failure: URLError
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                    default: break
                }
            } receiveValue: { data in
                self.photoData[photo.id] = data
            }
            .store(in: &cancellables)
    }

}
