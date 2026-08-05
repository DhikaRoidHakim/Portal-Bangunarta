class ListAssetsModel {
  final String? message;
  final int code;
  final List<AssetsModel> data;

  const ListAssetsModel({
    required this.message,
    required this.code,
    required this.data,
  });

  factory ListAssetsModel.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List?;
    return ListAssetsModel(
      message: json['message']?.toString(),
      code: json['code'] as int? ?? 0,
      data: list != null
          ? list
                .map(
                  (item) => AssetsModel.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class AssetsModel {
  final String id;
  final String kodeAset;
  final String namaAset;
  final String currentOfficeId;
  final String currentRoomId;
  final String? lastMovedAt;
  final String createdAt;
  final String updatedAt;
  final String currentOfficeName;
  final String currentRoomName;
  final String? currentRoomPic;
  final int totalMoves;
  final int totalRepairs;
  final bool inRepair;

  const AssetsModel({
    required this.id,
    required this.kodeAset,
    required this.namaAset,
    required this.currentOfficeId,
    required this.currentRoomId,
    this.lastMovedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.currentOfficeName,
    required this.currentRoomName,
    this.currentRoomPic,
    required this.totalMoves,
    required this.totalRepairs,
    required this.inRepair,
  });

  factory AssetsModel.fromJson(Map<String, dynamic> json) {
    return AssetsModel(
      id: json['id']?.toString() ?? '',
      kodeAset: json['kode_aset']?.toString() ?? '',
      namaAset: json['nama_aset']?.toString() ?? '',
      currentOfficeId: json['current_office_id']?.toString() ?? '',
      currentRoomId: json['current_room_id']?.toString() ?? '',
      lastMovedAt: json['last_moved_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      currentOfficeName: json['current_office_name']?.toString() ?? '',
      currentRoomName: json['current_room_name']?.toString() ?? '',
      currentRoomPic: json['current_room_pic']?.toString(),
      totalMoves: json['total_moves'] as int? ?? 0,
      totalRepairs: json['total_repairs'] as int? ?? 0,
      inRepair: json['in_repair'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_aset': kodeAset,
      'nama_aset': namaAset,
      'current_office_id': currentOfficeId,
      'current_room_id': currentRoomId,
      'last_moved_at': lastMovedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'current_office_name': currentOfficeName,
      'current_room_name': currentRoomName,
      'current_room_pic': currentRoomPic,
      'total_moves': totalMoves,
      'total_repairs': totalRepairs,
      'in_repair': inRepair,
    };
  }
}
