//
//  DetailView.swift
//  CVS_FlickerApp
//
//  Created by Varshith Chilamkurthi on 03/12/24.
//

import SwiftUI

struct DetailView: View {
    var item: Item?
    @State private var isShareSheetPresented = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let item = item {
                    HStack {
                        Text("Author: \(Helper.shared.cleanName(title: item.author ?? UIStrings.notApplicable.rawValue))")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.black)
                        Spacer()
                        Text(Helper.shared.formattedDate(from: item.published ?? UIStrings.notApplicable.rawValue))
                            .font(.system(size: 10, weight: .light))
                            .foregroundStyle(Color.gray)
                    }
                    
                    AsyncImage(url: URL(string: item.media?.m ?? UIStrings.notApplicable.rawValue)) { image in
                        image
                            .resizable()
                            .frame(width: 360, height: 360)
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } placeholder: {
                        ProgressView()
                            .frame(height: 220)
                    }
                    
                    Text(Helper.shared.cleanName(title: item.title ?? UIStrings.notApplicable.rawValue))
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Show cleaned description
                    Text(Helper.shared.cleanDescription(from: item.description))
                        .padding(.top, 10)
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(Helper.shared.extractImageDimensions(from: item.description) ?? UIStrings.notApplicable.rawValue)
                        .padding(.top, 10)
                }
            }.padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShareSheetPresented = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $isShareSheetPresented) {
            if let item = item {
                let shareContent = [
                    item.media?.m ?? "",
                    Helper.shared.cleanName(title: item.title ?? ""),
                    Helper.shared.cleanDescription(from: item.description)
                ]
                ShareSheet(activityItems: shareContent)
            }
        }
    }
}

#Preview {
    DetailView(item: Item(title: "title", link: "link", media: Media(m: "https://live.staticflickr.com/65535/54180499019_36ba01473a_m.jpg"), description: "desc", published: "2024-11-30T23:11:50Z", author: "nobody@flickr.com (\"kevin-palmer\")"))
}
