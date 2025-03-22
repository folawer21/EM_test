
import SwiftUI

struct TodoView: View {
    private var viewModel: TodoViewModel
    init(viewModel: TodoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            
            checkMark()
            
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.title)
                    .opacity(viewModel.isCompleted ? Layout.opacity50 : Layout.opacity100)
                    .strikethrough(viewModel.isCompleted)
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .lineLimit(1)
                
                Text(viewModel.description ?? "")
                    .opacity(viewModel.isCompleted ? Layout.opacity50 : Layout.opacity100)
                    .font(.system(size: 12, weight: .medium, design: .default))
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(viewModel.date)
                    .opacity(Layout.opacity50)
                    .font(.system(size: 12, weight: .medium, design: .default))
            }
            .padding(.vertical, 8)
        }
        .padding(.horizontal, 20)
    }
}

private extension TodoView {
    func checkMark() -> some View {
        Button(
            action: viewModel.toggleAction,
            label: {
                viewModel.isCompleted ? Images.filledCheckMark : Images.emptyCheckMark
            }
        )
        .frame(width: 24, height: 48)
        
    }
}

private extension TodoView {
    enum Layout {
        static let opacity50 = 0.5
        static let opacity100 = 1.0
    }
}

#if DEBUG
#Preview {
    let vm = TodoViewModel (
        id: "134",
        title: "Уборка в квартире",
        isCompleted: false,
        description: "Провести гениальную уборку в квартире",
        date: "02/10/24"
    )
    TodoView(viewModel: vm)
}
#endif
