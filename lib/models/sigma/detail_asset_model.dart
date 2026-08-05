class DetailAssetModel {
  final String? message;
  final int code;
  final List<DetailModel> data;

  const DetailAssetModel({
    required this.message,
    required this.code,
    required this.data,
  });

  factory DetailAssetModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<DetailModel> dataList = [];
    if (rawData is List) {
      dataList = rawData
          .map((item) => DetailModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (rawData is Map<String, dynamic>) {
      dataList = [DetailModel.fromJson(rawData)];
    }
    return DetailAssetModel(
      message: json['message']?.toString(),
      code: json['code'] as int? ?? 0,
      data: dataList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }

  DetailModel? get detail => data.isNotEmpty ? data.first : null;
}

class DetailModel {
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

  const DetailModel({
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

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    return DetailModel(
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
