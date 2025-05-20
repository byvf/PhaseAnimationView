//
//  ContentView.swift
//  FackFlow
//
//  Created by VF on 16.05.2025.
//

import SwiftUI

struct CardContentEntity: Identifiable {
    var id: UUID  = UUID()
    var title: String
    var color: Color
}

struct ContentView: View {
    
    @State private var items: [CardContentEntity] = [
        CardContentEntity(title: "Red", color: Color.red),
        CardContentEntity(title: "Green", color: Color.green),
        CardContentEntity(title: "Pink", color: Color.pink),
        CardContentEntity(title: "Secondary", color: Color.secondary),
        CardContentEntity(title: "Primary", color: Color.primary),
        CardContentEntity(title: "Purple", color: Color.purple),
        CardContentEntity(title: "Yellow", color: Color.yellow),
        CardContentEntity(title: "Brown", color: Color.brown),
        CardContentEntity(title: "Cyan", color: Color.cyan),
    ]
    
    @State private var isAnimatingOut = false
    @State private var isDragging: Bool = false
    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            ZStack {
                
                ZStack {
                    ForEach(1..<4, id: \.self) { offset in
                        if currentIndex + offset < items.count {
                            let item = items[currentIndex + offset]
                            
                            RoundedRectangle(cornerRadius: 16)
                                .fill(item.color)
                                .frame(width: 300, height: 300)
                                .offset(y: CGFloat(offset * 20))
                                .scaleEffect(1 - CGFloat(offset) * 0.05)
                                .opacity(0.3)
                                .zIndex(Double(-offset))
                        }
                    }
                }
                
                if items.indices.contains(currentIndex) {
                    let item = items[currentIndex]
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(item.color)
                        .frame(width: 300, height: 300)
                        .overlay(Text(item.title).foregroundColor(.white).font(.title))
                        .id(item.id)
                        .transition(
                            .asymmetric(
                                insertion: .cardScale,
                                removal: .cardMovedUp
                            )
                        )
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.isDragGoUp {
                                        withAnimation {
                                            currentIndex = (currentIndex + 1) % items.count
                                        }
                                    }
                                }
                        )
                }
            }
        }
    }
}

struct CardTransactionAnimation: ViewModifier, Animatable {
    
    var isActive: Bool = false
    var animatableData: Bool {
        get { isActive }
        set { isActive = newValue }
    }
    
    /// Applies a scaling, upward offset, and opacity animation to the content when activated.
    ///
    /// When `isActive` is true, the content scales down to 80%, moves up by 40 points, and fades to 70% opacity with an ease-in-out animation. When inactive, the content returns to its original state.
    func body(content: Content) -> some View {
        content
            .scaleEffect(isActive ? 0.8 : 1.0)
            .offset(y: isActive ? -40 : 0)
            .opacity(isActive ? 0.7 : 1)
            .animation(.easeInOut(duration: 0.5), value: isActive)
    }
}


struct CardUPAnimation: ViewModifier {
    
    var isActive: Bool = false
    
    /// Animates a view by scaling it up, moving it upward, and reducing its opacity when active.
    ///
    /// When `isActive` is true, the view scales to 1.1x, shifts up by 200 points, and fades to 80% opacity with an ease-in-out animation. When inactive, the view returns to its original state.
    func body(content: Content) -> some View {
        content
            .scaleEffect(isActive ? 1.1 : 1.0)
            .offset(y: isActive ? -200 : 0)
            .opacity(isActive ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: isActive)
    }
}

struct CardTransactionRotationAnimation: ViewModifier {
    
    var isActive: Bool = false
    
    /// Applies a 3D rotation and fade-out effect to the content when active.
    ///
    /// Rotates the content 180 degrees around the x-axis with perspective and fades it out when `isActive` is true. The transition is animated with an ease-in-out curve over 0.5 seconds.
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(isActive ? (1 * 180) : 0),
                axis: (x: 1.0, y: 0.0, z: 0.0),
                anchor: .trailing, perspective: 0.6
            )
            .opacity(isActive ? 0 : 1)
            .animation(.easeInOut(duration: 0.5), value: isActive)
    }
}

extension AnyTransition {
    static var cardScale: AnyTransition = .modifier(active: CardTransactionAnimation(isActive: true), identity: CardTransactionAnimation(isActive: false))
    static var cardRotation: AnyTransition = .modifier(active: CardTransactionRotationAnimation(isActive: true), identity: CardTransactionRotationAnimation(isActive: false))
    static var cardMovedUp: AnyTransition = .modifier(active: CardUPAnimation(isActive: true), identity: CardUPAnimation(isActive: false))
}

extension DragGesture.Value {
    var isDragGoUp: Bool {
        return self.translation.height < 0
    }
    
    var isDragGoDown: Bool {
        return self.translation.height > 0
    }
    
    var isDragGoLeft: Bool {
        return self.translation.width < 0
    }
    
    var isDragGoRight: Bool {
        return self.translation.width > 0
    }
}

#Preview {
    ContentView()
}
