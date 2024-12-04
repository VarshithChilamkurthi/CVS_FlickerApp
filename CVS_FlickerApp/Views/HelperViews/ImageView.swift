//
//  ImageView.swift
//  CVS_FlickerApp
//
//  Created by Varshith Chilamkurthi on 03/12/24.
//

import SwiftUI

struct ImageView: View {
    @StateObject private var viewModel = ImageViewModel()
    
    
    let columns = [GridItem(.flexible(), spacing: 10),
//                   GridItem(.flexible(), spacing: 10),
                   GridItem(.flexible(), spacing: 10)]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView() {
                    // MARK: - Image grid section
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.images, id: \.self) { item in
                            NavigationLink(destination: DetailView(item: item)) {
                                AsyncImage(url: URL(string: item.media?.m ?? "")) { image in
                                    image
                                        .resizable()
                                        .frame(height: 220)
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } placeholder: {
                                    ProgressView()
                                        .frame(height: 220)
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchImages(url: Constants.API.baseURL.rawValue)
                }
            }
            .navigationTitle(UIStrings.flickrSearchTitle.rawValue)
            .searchable(text: $viewModel.searchText, prompt: UIStrings.searchImagesPlaceholder.rawValue).padding()
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    ImageView()
}
