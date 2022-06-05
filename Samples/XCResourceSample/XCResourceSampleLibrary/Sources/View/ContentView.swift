import SwiftUI
import Resource

public struct ContentView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Image(key: .dogWithApple)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(form: .dogEatingApples(dogName: "Charlie", appleCount: 1))
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
