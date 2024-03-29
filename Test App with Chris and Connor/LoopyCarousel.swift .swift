//
//  LoopyCarousel.swift .swift
//  Test App with Chris and Connor
//
//  Created by Connor Brown on 6/2/23.
//

import SwiftUI
import Turf



struct LoopyCarousel: View {
    @Binding var FC: FeatureCollection!
    
  var body: some View {
      
    @State var fountainNames = FC.features.compactMap
      {
          $0.properties!["signname"] as? String
      }

    VStack {
      Text("Loopy Carousel").font(.title)
      Text("Tap on any card to select and see it slide onto the center of the carousel.")

        Carousel(cardLabels: $fountainNames)
      .padding()
      .frame(maxWidth: .infinity)
      .clipped()

      Spacer()
    }
  }
    
}

struct Carousel: View {

  private static let spacing = CGFloat(8)

  @Binding var cardLabels: [String]
  @State private var current: Int

  var body: some View {
    VStack {

      HStack(spacing: 0) {

        HStack(spacing: Self.spacing) {
          ForEach(0 ..< loopCount) { i in
            Card(content: cardLabels[i % cardLabels.count], isSelected: .constant(current == i))
              .onTapGesture { onSelect(i) }
          }
        }
        .offset(x: offset)
      }
      .frame(height: 170)
      .padding()
      .clipped()
      .background(Color.purple)

      VStack(alignment: .leading) {
          if cardLabels.count > 0 {
              Text("Card \(current % cardLabels.count) of \(cardLabels.count)")
              Text("Index \(current) of \(loopCount)")
              Text("Offset: \(offset, specifier: "%d") points")
          }
      }
      .font(.system(.caption, design: .monospaced))
    }
  }

  init(cardLabels: Binding<[String]>) {
    _cardLabels = cardLabels
    _current = State(initialValue: cardLabels.wrappedValue.count)
  }

  private var loopCount: Int {
    cardLabels.count * 3
  }

  private var cardWidth: CGFloat {
    Card.normalWidth + Self.spacing
  }

  private var evenShift: CGFloat {
    loopCount.isMultiple(of: 2)
    ? -cardWidth / 2
    : 0
  }

  private var offset: CGFloat {
    cardWidth * CGFloat(loopCount / 2 - current) + evenShift
  }

  private func onSelect(_ index: Int) -> () {
    let jump = abs(current - index)
    if (index >= cardLabels.count * 2) {
      current = cardLabels.count + (index % cardLabels.count) - jump
      withAnimation { current += jump }
    } else if (index < cardLabels.count) {
      current = cardLabels.count + (index % cardLabels.count) + jump
      withAnimation { current -= jump }
    } else {
      withAnimation { current = index }
    }
  }
}

fileprivate struct Card: View {

  static let normalWidth = CGFloat(100)
  static private let selectedWidth = CGFloat(140)

  let content: String
  @Binding var isSelected: Bool

  var body: some View {
    VStack {
      Text(content)
      Image(systemName: isSelected ? "checkmark.circle.fill" : "checkmark.circle")
    }
    .font(.largeTitle)
    .foregroundColor(.purple)
    .padding()
    .frame(width: width)
    .frame(maxHeight: isSelected ? .infinity : nil)
    .background(Color.orange)
  }

  private var width: CGFloat {
    isSelected ? Self.selectedWidth : Self.normalWidth
  }
}

//struct LoopyCarousel_Previews: PreviewProvider {
//  static var previews: some View {
//      LoopyCarousel(fountainNames: <#[String]#>, FC: <#Binding<FeatureCollection?>#>)
//  }
//}
