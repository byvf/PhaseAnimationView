import SwiftUI

struct PhaseAnimationView: View {
    
    @State private var searchText: String = ""
    @State private var isRabished = false
    @State private var isSearched = false
    @State private var isTextFieldFocused = false
    @FocusState private var isFocused: Bool
    
    enum Theme {
        static var sizeImage: CGFloat = 32
        static var textFieldHeight: CGFloat = 44
        static var cornerRadius: CGFloat = 12
        static var animationDuration: Double = 0.3
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(colors: [.red, .orange, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: 0) {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                .fill(Color.white.opacity(0.9))
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.purple.opacity(0.7), .blue.opacity(0.7)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: isFocused ? 2 : 0.5
                                        )
                                )
                                .shadow(
                                    color: Color.black.opacity(0.15),
                                    radius: 5,
                                    x: 0,
                                    y: 2
                                )

                            if searchText.isEmpty {
                                Text("Search...")
                                    .foregroundColor(.gray.opacity(isFocused ? 0.5 : 0.7))
                                    .font(.system(size: isFocused ? 12 : 16))
                                    .padding(.leading, isFocused ? 16 : 16)
                                    .padding(.top, isFocused ? -14 : 0)
                                    .animation(.easeInOut(duration: Theme.animationDuration), value: isFocused)
                            }
                            
                            TextField("", text: $searchText)
                                .padding(.horizontal, 16)
                                .foregroundColor(.black)
                                .frame(height: Theme.textFieldHeight)
                                .focused($isFocused)
                                .onChange(of: isFocused) { oldValue, newValue in
                                    isTextFieldFocused = newValue
                                }
                        }
                        .frame(width: geometry.size.width - 16 - (Theme.sizeImage * 2) - 32)
                        .frame(height: Theme.textFieldHeight)
                        
                        Button {
                            isSearched.toggle()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.green.opacity(0.8), .green.opacity(0.6)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                                    .frame(width: Theme.sizeImage + 10, height: Theme.sizeImage + 10)
                                
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .frame(width: Theme.sizeImage * 0.7, height: Theme.sizeImage * 0.7)
                                    .phaseAnimator(MagnifyingglassAnimationPhase.allCases, trigger: isSearched) { content, phase in
                                        content
                                            .foregroundColor(phase.iconColor)
                                            .scaleEffect(phase.scale)
                                            .offset(x: phase == .liftLeft ? -(geometry.size.width - 32 - (Theme.sizeImage * 2)) : 0)
                                            .offset(x: phase.xoffSet)
                                            .offset(y: phase.yoffSet)
                                            .rotationEffect(.degrees(phase.ratationDegress))
                                            .shadow(color: phase.iconColor.opacity(phase == .idle ? 0 : 0.6), radius: phase == .idle ? 0 : 5)
                                    } animation: { phase in
                                        switch phase {
                                        case .idle:
                                                .spring(bounce: 0.5)
                                        case .liftLeft:
                                                .easeInOut(duration: 0.5)
                                        case .liftRight:
                                                .easeInOut(duration: 0.5)
                                        case .dragLeft, .dragRight:
                                                .easeInOut(duration: 0.5)
                                        }
                                    }
                            }
                            .frame(width: Theme.sizeImage + 10, height: Theme.sizeImage + 10)
                        }
                        .padding(.leading, 10)
                        
                        Button {
                            withAnimation(.spring(duration: 0.6)) {
                                isRabished.toggle()
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.red.opacity(0.8), .red.opacity(0.6)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                                    .frame(width: Theme.sizeImage + 10, height: Theme.sizeImage + 10)
                                
                                Image(systemName: "trash")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: Theme.sizeImage * 0.6, height: Theme.sizeImage * 0.6)
                                    .foregroundColor(.white)
                                    .phaseAnimator(
                                        SimpleTrashAnimationPhase.allCases,
                                        trigger: isRabished
                                    ) { content, phase in
                                        content
                                            .scaleEffect(phase.scale)
                                            .offset(y: phase.yOffset)
                                            .rotation3DEffect(
                                                .degrees(phase.rotationYDegrees),
                                                axis: (x: 0.0, y: 1.0, z: 0.0),
                                                anchor: .center
                                            )
                                    } animation: { phase in
                                        switch phase {
                                        case .idle:
                                            .spring(duration: 0.4)
                                        case .liftUp:
                                            .easeOut(duration: 0.2)
                                        case .rotateLeft:
                                            .easeInOut(duration: 0.3)
                                        case .rotateRight:
                                            .easeInOut(duration: 0.3)
                                        }
                                    }
                            }
                            .frame(width: Theme.sizeImage + 10, height: Theme.sizeImage + 10)
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.cornerRadius + 8)
                            .fill(Color.white.opacity(0.15))
                            .blur(radius: 5)
                    )
                    .padding(.horizontal, 8)
                    
                    Spacer()
                }
            }
            .frame(width: geometry.size.width)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

enum SimpleTrashAnimationPhase: CaseIterable {
    case idle
    case liftUp
    case rotateLeft
    case rotateRight
    
    var yOffset: CGFloat {
        switch self {
        case .idle:
            return 0
        case .liftUp, .rotateLeft, .rotateRight:
            return -15
        }
    }
    
    var scale: CGFloat {
        switch self {
        case .idle:
            return 1.0
        case .liftUp, .rotateLeft, .rotateRight:
            return 1.2
        }
    }
    
    var rotationYDegrees: Double {
        switch self {
        case .idle, .liftUp:
            return 0
        case .rotateLeft:
            return -30
        case .rotateRight:
            return 30
        }
    }
}

enum MagnifyingglassAnimationPhase: CaseIterable {
    case idle
    case liftLeft
    case liftRight
    case dragLeft
    case dragRight
    
    var yoffSet: CGFloat {
        switch self {
        case .idle: return 0
        case .liftLeft: return 0
        case .liftRight: return 0
        case .dragLeft, .dragRight: return -20
        }
    }
    
    var xoffSet: CGFloat {
        switch self {
        case .idle: return 0
        case .liftLeft: return 0
        case .liftRight: return 0
        case .dragLeft, .dragRight: return 0
        }
    }
    
    var scale: CGFloat {
        switch self {
        case .idle: return 1
        case .liftLeft: return 1.6
        case .liftRight: return 1.6
        case .dragLeft, .dragRight: return 1.3
        }
    }
    
    var ratationDegress: Double {
        switch self {
        case .idle: return 0
        case .liftLeft: return 0
        case .liftRight: return 0
        case .dragLeft: return 30
        case .dragRight: return -30
        }
    }
    
    var iconColor: Color {
        switch self {
        case .idle:
            return .white
        case .liftLeft, .liftRight, .dragLeft, .dragRight:
            return Color.gray.opacity(0.9)
        }
    }
}

#Preview {
    PhaseAnimationView()
}

