import SwiftUI

struct ResultsView: View {
    @StateObject private var viewModel = MatchesViewModel()
    @State private var selectedLeague = "super-lig"
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                VStack {
                    Picker("Lig", selection: $selectedLeague) {
                        ForEach(viewModel.leagues) { league in
                            Text(league.name)
                                .tag(league.key)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .tint(Theme.accent)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .foregroundColor(Theme.foreground)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible())], spacing: Theme.padding) {
                                ForEach(viewModel.matches) { match in
                                    NavigationLink(destination: MatchDetailView(match: match)) {
                                        MatchRowView(match: match)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Sonuçlar")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if viewModel.leagues.isEmpty {
                viewModel.fetchLeagues()
            }
            viewModel.fetchResults(for: selectedLeague)
        }
        .onChange(of: selectedLeague) { newValue in
            viewModel.fetchResults(for: newValue)
        }
    }
} 