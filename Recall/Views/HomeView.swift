import SwiftUI

struct HomeView: View {
    @StateObject private var networkManager = NetworkManager()
    @State private var isCreatingObject = false

    var body: some View {
        NavigationView {
            List(networkManager.objects) { object in
                ObjectCellView(object: object)
            }
            .listStyle(PlainListStyle())
            .refreshable {
                networkManager.fetchAllData()
            }
            .navigationTitle("Tracked Objects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isCreatingObject = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                networkManager.fetchAllData()
            }
            .sheet(isPresented: $isCreatingObject) {
                CreateObjectView(networkManager: networkManager, isCreatingObject: $isCreatingObject)
            }
        }
    }
}
