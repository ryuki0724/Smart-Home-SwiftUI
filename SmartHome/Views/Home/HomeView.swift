import SwiftUI

struct HomeView: View {
    
    @ObservedObject var userModel = UserModel.shared
    
    @AppStorage("storedUserId") var storedUserId: Int = 0
    
    @State private var houses:  [HouseModel]  = []
    @State private var rooms:   [RoomModel]   = []
    @State private var devices: [DeviceModel] = []
    
    @State private var selectedHouse:  HouseModel?  = nil
    @State private var selectedRoom:   RoomModel?   = nil
    @State private var selectedDevice: DeviceModel? = nil
    
    @State private var showAddHouseSheet   = false
    @State private var showAddRoomSheet    = false
    @State private var showAddDeviceSheet  = false
    
    @State private var showPairDeviceSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    roomSelectionView
                    
                    sectionHeaderView
                    
                    deviceGridView
                    
                    Spacer()
                }
                .navigationTitle("我的家")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            addButton
                            moreButton
                        }
                    }
                }
            }
            .onAppear {
                loadHouses()
            }
            .sheet(isPresented: $showAddHouseSheet) {
                AddHouseSheet(isPresented: $showAddHouseSheet, houses: $houses, selectedHouse: $selectedHouse, loadRooms: loadRooms)
            }
            .sheet(isPresented: $showAddRoomSheet) {
                AddRoomSheet(isPresented: $showAddRoomSheet, rooms: $rooms, selectedRoom: $selectedRoom, selectedHouse: $selectedHouse, loadDevicesByRoom: loadDevicesByRoom)
            }
            .sheet(isPresented: $showAddDeviceSheet) {
                AddDeviceSheet(selectedRoom: $selectedRoom, isPresented: $showAddDeviceSheet, refreshDevices: {
                    if let roomId = selectedRoom?.id {
                        loadDevicesByRoom(for: roomId)
                    }
                }, rooms: rooms)
                .presentationDetents([.medium, .large])
                .presentationCornerRadius(50)
            }
        }
    }
    
    private var roomSelectionView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                if let house = selectedHouse {
                    RoomButton(
                        room: RoomModel(id: 0, houseId: house.id, name: house.name, icon: "house.fill"),
                        isSelected: selectedRoom == nil
                    )
                    .onTapGesture {
                        selectedRoom = nil
                        loadAllDevicesForHouse()
                    }
                }
                ForEach($rooms) { $room in
                    RoomButton(
                        room: room,
                        isSelected: selectedRoom?.id == room.id
                    )
                    .onTapGesture {
                        selectedRoom = room
                        loadDevicesByRoom(for: room.id)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
        }
    }
    
    private var sectionHeaderView: some View {
        HStack {
            Text("設備")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            Image(systemName: "list.bullet.rectangle")
                .font(.title)
        }
        .padding(.horizontal, 20)
    }
    
    private var deviceGridView: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach($devices) { $device in
                NavigationLink(destination: DeviceDetailView(device: device)) {
                    DeviceButton(
                        userId: $storedUserId,
                        device: device,
                        changeStatus: device.changeStatus
                    )
                }
            }
            AddButton()
                .onTapGesture {
                    showAddDeviceSheet.toggle()
                }
        }
        .padding(.horizontal, 20)
    }
    
    private var addButton: some View {
        Menu {
            Button(action: { showAddDeviceSheet.toggle() }) {
                Label("加入配件", systemImage: "plus.circle")
            }
            
            Button(action: { showAddRoomSheet.toggle() }) {
                Label("加入房間", systemImage: "square.split.bottomrightquarter")
            }
            
            Divider()
            
            Button(action: { showAddHouseSheet.toggle() }) {
                Label("新增家庭", systemImage: "house")
            }
        } label: {
            Image(systemName: "plus")
        }
    }
    
    private var moreButton: some View {
        Menu {
            Button(action: { /* Handle family settings */ }) {
                Label("家庭設定", systemImage: "gear")
            }
            
            Divider()
            
            ForEach(houses) { house in
                Button(action: {
                    selectedHouse = house
                    loadRooms(for: house.id)
                }) {
                    HStack {
                        Text(house.name)
                        if selectedHouse?.id == house.id {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "ellipsis")
        }
    }
    
    private func loadHouses() {
        HouseModel.getAll(userId: storedUserId) { fetchedHouses in
            DispatchQueue.main.async {
                houses = fetchedHouses
                if let firstHouse = fetchedHouses.first {
                    selectedHouse = firstHouse
                    loadRooms(for: firstHouse.id)
                }
            }
        }
    }
    
    private func loadRooms(for houseId: Int) {
        RoomModel.getAll(houseId: houseId) { fetchedRooms in
            DispatchQueue.main.async {
                rooms = fetchedRooms
                if selectedRoom == nil {
                    loadAllDevicesForHouse()
                } else if let firstRoom = fetchedRooms.first {
                    selectedRoom = firstRoom
                    loadDevicesByRoom(for: firstRoom.id)
                }
            }
        }
     }
    
    private func loadDevicesByRoom(for roomId: Int) {
        DeviceModel.getByRoom(roomId: roomId) { fetchedDevices in
            DispatchQueue.main.async {
                devices = fetchedDevices
            }
        }
    }
    
    private func loadAllDevicesForHouse() {
        guard let houseId = selectedHouse?.id else { return }
        DeviceModel.getAll(houseId: houseId) { fetchedDevices in
            DispatchQueue.main.async {
                devices = fetchedDevices
            }
        }
    }
}

#Preview {
    HomeView()
}
