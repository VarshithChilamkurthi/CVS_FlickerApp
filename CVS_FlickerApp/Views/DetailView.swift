//
//  DetailView.swift
//  CVS_FlickerApp
//
//  Created by Varshith Chilamkurthi on 03/12/24.
//

import SwiftUI

struct DetailView: View {
    var item: Item?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let item = item {
                    HStack {
                        Text("Author: \(Helper.shared.cleanName(title: item.author ?? "N/A"))")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.black)
                        Spacer()
                        Text(Helper.shared.formattedDate(from: item.published ?? "N/A"))
                            .font(.system(size: 10, weight: .light))
                            .foregroundStyle(Color.gray)
                    }
                    
                    AsyncImage(url: URL(string: item.media?.m ?? "")) { image in
                        image
                            .resizable()
                            .frame(width: 360, height: 360)
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } placeholder: {
                        ProgressView()
                            .frame(height: 220)
                    }
                    
                    Text(Helper.shared.cleanName(title: item.title ?? "No Title"))
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Show cleaned description
                    Text(Helper.shared.cleanDescription(from: item.description))
                        .padding(.top, 10)
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(Helper.shared.extractImageDimensions(from: item.description) ?? "n/a")
                        .padding(.top, 10)
                }
            }.padding()
        }
    }
}

#Preview {
    DetailView(item: Item(title: "title", link: "link", media: Media(m: "https://live.staticflickr.com/65535/54180499019_36ba01473a_m.jpg"), description: "desc", published: "2024-11-30T23:11:50Z", author: "nobody@flickr.com (\"kevin-palmer\")"))
}
