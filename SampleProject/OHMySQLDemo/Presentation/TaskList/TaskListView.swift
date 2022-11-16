//
//  Copyright (c) 2022-Present Oleg Hnidets
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel = TaskListViewModel()
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                ProgressView()
                    .progressViewStyle(.circular)
            case .fetched:
                List {
                    Section {
                        ForEach(viewModel.tasks) { task in
                            NavigationLink {
                                TaskDetailsView()
                            } label: {
                                Text(task.name ?? "-")
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.delete()
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            case .emptyList:
                Text("List is empty")
            case .error(let message):
                Text(message)
            case .fetching:
                ProgressView()
            }
        }.onAppear {
            viewModel.configureData()
        }.toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("+") {
                    viewModel.addRandomTask()
                }
            }
        }
    }
}
