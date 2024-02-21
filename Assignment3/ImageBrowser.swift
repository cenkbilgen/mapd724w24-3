//
//  ImageBrowser.swift
//  Assignment3
//
//  Created by Cenk Bilgen on 2024-02-12.
//

import SwiftUI

struct ImageBrowser: View {
    @StateObject var state = PhotosState(maxPhotos: 6)
    @State var index = 0 // the current photo index in the array of photos

    @State var scale: CGFloat = 1
    @GestureState var angle: Angle = .zero

    let dialRadius: CGFloat = 50
    @State var dialAngle: Angle = .zero
    var photoWedge: Angle { // the angle span of one photo on the
        Angle(degrees: 360/Double(state.photos.count))
    }

    @Environment(\.displayScale) var displayScale
    // device screen pixel scale (1,2 or 3), needed when displaying a pure CGImage
    // different from scale above used by tap gesture

    var photo: (FlickrService.Photo, data: Data)? {
        guard index < state.photos.count else {
            return nil
        }
        let photo = state.photos[index]
        if let data = state.photoData[photo.id] {
            return (photo, data)
        } else {
            return nil
        }
    }

    var body: some View {
        VStack {
            Spacer()
            if let photo {
                (Image(data: photo.data, scale: displayScale) ?? Image(systemName: "photo"))
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .rotationEffect(angle)
                    .overlay(alignment: .topTrailing) {
                        Text(photo.0.owner)
                            .font(.caption.bold())
                            .padding()
                            .background(.thinMaterial)
                    }
                    .gesture(
                        RotateGesture()
                            .updating($angle) { value, state, _ in
                                state = value.rotation
                            }
                    )
                    .gesture(
                        TapGesture(count: 2)
                            .onEnded { _ in
                                scale = 1
                            }
                    )
                    .gesture(
                        TapGesture(count: 1)
                            .onEnded { _ in
                                scale = scale * 1.25
                            }
                    )
            }
            Spacer()
        }
        .gesture(DragGesture()
            .onEnded{ value in
                if value.translation.width < 0 {
                    index = index + 1 >= state.photos.count ? 0 : index + 1
                } else {
                    index = index - 1 < 0 ? state.photos.count - 1 : index - 1
                }
                self.dialAngle = Angle(degrees: Double(index)*photoWedge.degrees)
                print(index)
            })
        .overlay(alignment: .bottomLeading) {
            Circle()
                .foregroundStyle(.pink)
                .frame(width: dialRadius*2, height: dialRadius*2)
                .overlay(alignment: .top) {
                    Capsule()
                        .frame(width: dialRadius/6, height: dialRadius/2)
                        .padding(dialRadius/10)
                }
                .rotationEffect(dialAngle)
                .opacity(state.photos.count > 1 ? 1 : 0) // hide if <1 photo
                .padding()
                .gesture(DragGesture()
                    .onChanged { value in
                        let angle = self.normalizeRadians(angle: atan2(value.location.y-dialRadius, value.location.x-dialRadius))
                        self.dialAngle = Angle(radians: angle)
                        self.index = Int(angle/photoWedge.radians)
                        print(index)
                    })
        }
    }

    // you may need this
    func normalizeRadians(angle: CGFloat) -> CGFloat {
        let positiveAngle = angle < 0 ? angle + .pi*2 : angle
        return positiveAngle.truncatingRemainder(dividingBy: .pi*2)
    }
}

#Preview {
    ImageBrowser()
}

// SwiftUI Image does not have an initializer from Data. UIImage does, so we created a SwiftUI Image by creating a UIImage first, which is probably fine for just a class assignment, but I still don't like it.
// Use this instead.
// NOTE: when making extensions to system-wide types like Image,
// keep your modifications private to the file to avoid conflicts
// especially if you are doing so in a shared library

fileprivate extension Image {
    init?(data: Data, scale: CGFloat) {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
            return nil
        }
        self = Image(decorative: cgImage, scale: scale)
    }
}

