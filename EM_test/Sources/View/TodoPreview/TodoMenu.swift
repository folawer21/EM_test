import SwiftUI

// MARK: К сожалению, не удалось все же использовать кастомные кнопки для конекстного меню ячейки в виду проблем, поэтому пришлось оставить черное

struct ContentView: View {
    let shareAction: () -> Void
    let deleteAction: () -> Void
    let editAction: () -> Void
    var body: some View {
        ZStack{
            Colors.white50
            VStack(spacing: 0) {
                Button(
                    action: editAction,
                    label: {
                        HStack(alignment: .center) {
                            Text("Редактировать")
                                .foregroundStyle(Colors.black4)
                                .padding(.leading, 16)
                            Spacer()
                            Image("edit")
                                .frame(width: 16, height: 16)
                                .padding(.trailing, 14)
                        }
                    })
                .frame(height: 44)
                Divider()
                Button(
                    action: editAction,
                    label: {
                        HStack(alignment: .center) {
                            Text("Поделиться")
                                .foregroundStyle(Colors.black4)
                                .padding(.leading, 16)
                            Spacer()
                            Image("share")
                                .frame(width: 16, height: 16)
                                .padding(.trailing, 14)
                        }
                    })
                .frame(height: 44)
                Divider()
                Button(
                    action: editAction,
                    label: {
                        HStack(alignment: .center) {
                            Text("Удалить")
                                .foregroundStyle(Colors.red)
                                .padding(.leading, 16)
                            Spacer()
                            Image("trash")
                                .frame(width: 16, height: 16)
                                .padding(.trailing, 14)
                    }})
                .frame(height: 44)
            }
        }
        .cornerRadius(12)
        .frame(width: 256)
    }
}

#Preview {
    ContentView(shareAction: {print(1)}, deleteAction: {print(2)}, editAction: {print(3)})
}
