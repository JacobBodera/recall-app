import SwiftUI

struct HomeView: View {
    @StateObject private var networkManager = NetworkManager()
    @State private var isCreatingObject = false
    @State private var objectToDelete: ObjectTracking?
    @State private var showDeleteConfirmation = false

    var body: some View {
        NavigationView {
            List {
                ForEach(networkManager.objects) { object in
                    ObjectCellView(object: object)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                objectToDelete = object
                                showDeleteConfirmation = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                }
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
            .alert("Delete Object?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let object = objectToDelete {
                        networkManager.deleteObject(id: object.id)
                    }
                }
            } message: {
                Text("Are you sure you want to delete \"\(objectToDelete?.name ?? "this object")\"?")
            }
        }
    }
}
