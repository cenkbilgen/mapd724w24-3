//
//  ContentView.swift
//  Assignment3
//
//  Created by Cenk Bilgen on 2024-02-11.
//

import SwiftUI

struct ContentView: View {
    @StateObject var state = PhotosState()

    var body: some View {
        List(state.photos) { photo in
            ImageView(photo: photo, photoData: state.photoData[photo.id, default: Data()])
        }
    }
}

struct ImageView: View {
    let photo: FlickrService.Photo
    let photoData: Data

    var body: some View {
        Image(uiImage: UIImage(data: photoData) ?? UIImage())
            .resizable()
            .aspectRatio(1, contentMode: .fill)
            .overlay(alignment: .topLeading) {
                Text(photo.title)
                    .padding()
                    .background(Material.regular, in: RoundedRectangle(cornerRadius: 10))
                    .padding()
            }
    }
}

#Preview {
    ContentView()
}
