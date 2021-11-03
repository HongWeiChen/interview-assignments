//
//  SearchListView.swift
//  SwiftUI_SearchExample
//
//  Created by Hongwei Chen on 2021/10/21.
//

import SwiftUI

struct SearchListView: View {
    
    /// 搜索文本
    @State var searchText = ""
    /// 搜索页数
    @State var searchIndex = 0
    
    @StateObject var searchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchViewModel.searchList) { data in
                    if searchViewModel.isFirst(data: data) {
                        Button("Tap here to refresh", action: refresh)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    Section(data.title) {
                        ForEach(data.items) { item in
                            SearchItemView(item: item)
                                .listRowSeparator(data.items.last == item ? .hidden : .visible)
                                .listRowSeparatorTint(Color.gray.opacity(0.2))
                                .padding(.vertical, 5)
                        }
                    }
                    .listSectionSeparator(.hidden)
                    .padding(.vertical, 5)
                    if searchViewModel.isLast(data: data)  {
                        ProgressView()
                            .frame(width: UIScreen.main.bounds.size.width - 40, height: 50, alignment: .center)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .onAppear {
                                loadMore()
                            }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .background(Color.gray.opacity(0.08))
            .overlay(alignment: .top) {
                NoResultView()
                    .opacity(searchViewModel.searchList.isEmpty && !searchText.isEmpty ? 1.0 : 0.0)
                    .padding(.top, 80)
            }
            .onChange(of: searchText) { newValue in
                /// 重新调整searchText的时候,searchIndex设置为0
                self.searchIndex = 0
                searchViewModel.searchKeyword = newValue
            }
            .navigationTitle("Search")
        }.searchable(text: $searchText, prompt: "Tap here to search")
    }
    
    func refresh() {
        self.searchIndex = 0
        searchViewModel.searchIndex = self.searchIndex
    }
    
    func loadMore() {
        self.searchIndex = searchIndex + 1
        searchViewModel.searchIndex = self.searchIndex
    }
        
}
