import 'dart:ui' show ImageFilter;
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
  });

  final String title;
  final String message;
  final String time;
  final NotificationType type;
  final bool isRead;

  NotificationItem copyWith({
    String? title,
    String? message,
    String? time,
    NotificationType? type,
    bool? isRead,
  }) {
    return NotificationItem(
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum NotificationType { info, announcement, security, system }

const List<NotificationItem> dummyNotifications = [
  NotificationItem(
    title: 'Selamat Datang di Bangunarta One',
    message:
        'Portal internal siap membantu Anda mengakses layanan perusahaan dengan lebih mudah.',
    time: 'Baru saja',
    type: NotificationType.info,
    isRead: false,
  ),
  NotificationItem(
    title: 'Peningkatan Keamanan Akun',
    message:
        'Aktifkan login biometrik melalui halaman profile untuk akses yang lebih cepat dan aman.',
    time: '10 menit lalu',
    type: NotificationType.security,
    isRead: false,
  ),
  NotificationItem(
    title: 'Pemeliharaan Sistem',
    message:
        'Beberapa layanan internal akan mengalami pemeliharaan berkala malam ini.',
    time: '1 jam lalu',
    type: NotificationType.system,
    isRead: true,
  ),
  NotificationItem(
    title: 'Pengumuman Perusahaan',
    message:
        'Informasi terbaru perusahaan dapat dilihat pada menu Berita di aplikasi.',
    time: 'Kemarin',
    type: NotificationType.announcement,
    isRead: true,
  ),
];

class NotificationCenterPage extends StatefulWidget {
  const NotificationCenterPage({super.key});

  @override
  State<NotificationCenterPage> createState() => _NotificationCenterPageState();
}

class _NotificationCenterPageState extends State<NotificationCenterPage> {
  late List<NotificationItem> _notifications;
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _notifications = List.from(dummyNotifications);
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications
          .map((notification) => notification.copyWith(isRead: true))
          .toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.done_all_rounded, color: Colors.white, size: 20.sp),
            SizedBox(width: 10.w),
            Text('Semua notifikasi ditandai dibaca'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleReadStatus(int index, bool status) {
    setState(() {
      _notifications[index] = _notifications[index].copyWith(isRead: status);
    });
  }

  void _deleteNotification(NotificationItem item) {
    setState(() {
      _notifications.removeWhere(
        (n) => n.title == item.title && n.time == item.time,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 10.w),
            Text('Notifikasi berhasil dihapus'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<NotificationItem> _getFilteredNotifications() {
    if (_selectedFilter == 'Semua') {
      return _notifications;
    } else if (_selectedFilter == 'Belum Dibaca') {
      return _notifications.where((n) => !n.isRead).toList();
    } else if (_selectedFilter == 'Keamanan') {
      return _notifications
          .where((n) => n.type == NotificationType.security)
          .toList();
    } else if (_selectedFilter == 'Pengumuman') {
      return _notifications
          .where((n) => n.type == NotificationType.announcement)
          .toList();
    } else if (_selectedFilter == 'Sistem') {
      return _notifications
          .where((n) => n.type == NotificationType.system)
          .toList();
    }
    return _notifications;
  }

  void _showNotificationDetail(NotificationItem item, int actualIndex) {
    // Tandai sebagai dibaca otomatis jika dibuka
    if (!item.isRead) {
      _toggleReadStatus(actualIndex, true);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final typeColor = _getNotificationColor(item.type);
        final typeIcon = _getNotificationIcon(item.type);
        final typeLabel = _getNotificationLabel(item.type);

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 44.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: .24),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 28.h),

                // Icon & Tag
                Row(
                  children: [
                    Container(
                      width: 52.w,
                      height: 52.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [typeColor, typeColor.withValues(alpha: .7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: typeColor.withValues(alpha: .3),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(typeIcon, color: Colors.white, size: 24),
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            typeLabel,
                            style: TextStyle(
                              color: typeColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          item.time,
                          style: TextStyle(
                            color: AppTheme.textSecondary.withValues(alpha: .7),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Title
                Text(
                  item.title,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 16.h),

                // Divider
                WidgetDivider(color: Colors.grey.withValues(alpha: .15)),
                SizedBox(height: 18.h),

                // Message text
                Text(
                  item.message,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 36.h),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteNotification(item);
                        },
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.redAccent,
                          size: 20.sp,
                        ),
                        label: Text(
                          'Hapus',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          side: BorderSide(color: Colors.redAccent, width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Tutup',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final filteredList = _getFilteredNotifications();
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Beautiful Header with dynamic actions
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: .18),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            actions: [
              if (unreadCount > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: TextButton.icon(
                    onPressed: _markAllAsRead,
                    icon: const Icon(
                      Icons.done_all_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: const Text(
                      'Tandai Dibaca',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: .14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, Color(0xFF133B85)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Subtle background shapes
                    Positioned(
                      top: -40,
                      right: -30,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: .04),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      left: 50,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: .03),
                        ),
                      ),
                    ),
                    // Header text contents
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 88, 24, 24),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: .2),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.notifications_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Notification Center',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    unreadCount > 0
                                        ? '$unreadCount notifikasi belum dibaca'
                                        : 'Semua notifikasi telah dibaca',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: .75,
                                      ),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Sticky Horizontal Filter Chips
          SliverPersistentHeader(
            pinned: true,
            delegate: _FilterHeaderDelegate(
              selectedFilter: _selectedFilter,
              onFilterChanged: (filter) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
            ),
          ),

          // 3. Dynamic List View
          filteredList.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    color: AppTheme.backgroundLight,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withValues(alpha: .08),
                            ),
                            child: Icon(
                              Icons.notifications_off_outlined,
                              size: 64,
                              color: AppTheme.textSecondary.withValues(
                                alpha: .5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Tidak Ada Notifikasi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary.withValues(alpha: .8),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _selectedFilter == 'Semua'
                                ? 'Pusat notifikasi Anda kosong.'
                                : 'Tidak ada notifikasi dalam filter ini.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary.withValues(
                                alpha: .7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                  sliver: SliverList.separated(
                    itemCount: filteredList.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      // Dapatkan index asli dari list lengkap untuk state update
                      final actualIndex = _notifications.indexWhere(
                        (n) => n.title == item.title && n.time == item.time,
                      );

                      return _NotificationCard(
                        notification: item,
                        onTap: () => _showNotificationDetail(item, actualIndex),
                        onDelete: () => _deleteNotification(item),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    return switch (type) {
      NotificationType.info => AppTheme.primaryColor,
      NotificationType.announcement => const Color(0xFFF59E0B),
      NotificationType.security => const Color(0xFF10B981),
      NotificationType.system => const Color(0xFF6366F1),
    };
  }

  IconData _getNotificationIcon(NotificationType type) {
    return switch (type) {
      NotificationType.info => Icons.info_outline_rounded,
      NotificationType.announcement => Icons.campaign_rounded,
      NotificationType.security => Icons.verified_user_outlined,
      NotificationType.system => Icons.settings_suggest_rounded,
    };
  }

  String _getNotificationLabel(NotificationType type) {
    return switch (type) {
      NotificationType.info => 'INFORMASI',
      NotificationType.announcement => 'PENGUMUMAN',
      NotificationType.security => 'KEAMANAN',
      NotificationType.system => 'SISTEM',
    };
  }
}

class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  _FilterHeaderDelegate({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final filters = [
      'Semua',
      'Belum Dibaca',
      'Keamanan',
      'Pengumuman',
      'Sistem',
    ];

    return Container(
      color: AppTheme.backgroundLight,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return InkWell(
            onTap: () => onFilterChanged(filter),
            borderRadius: BorderRadius.circular(30),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppTheme.inputBorder,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: .15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => 58.0;

  @override
  double get minExtent => 58.0;

  @override
  bool shouldRebuild(covariant _FilterHeaderDelegate oldDelegate) {
    return oldDelegate.selectedFilter != selectedFilter;
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  final NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final typeColor = _notificationColor(notification.type);
    final typeIcon = _notificationIcon(notification.type);
    final typeLabel = _notificationLabel(notification.type);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white
              : const Color(0xFFF1F5FC), // Light blue-ish tint for unread
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: notification.isRead
                ? Colors.transparent
                : AppTheme.primaryColor.withValues(alpha: .12),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: notification.isRead ? 0.04 : 0.06,
              ),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Beautiful left accent stripe for unread notifications
              if (!notification.isRead)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 4, color: AppTheme.primaryColor),
                ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 10, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon with nice gradient container
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [typeColor, typeColor.withValues(alpha: .8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(typeIcon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 14),

                    // Main Info Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pill category tag
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: typeColor.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              typeLabel,
                              style: TextStyle(
                                color: typeColor,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),

                          // Title and Unread Blue Dot
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 14.5,
                                    fontWeight: notification.isRead
                                        ? FontWeight.w700
                                        : FontWeight.w900,
                                    height: 1.25,
                                  ),
                                ),
                              ),
                              if (!notification.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(
                                    top: 4,
                                    left: 6,
                                    right: 4,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Message Snippet
                          Text(
                            notification.message,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.textSecondary.withValues(
                                alpha: .85,
                              ),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Time text
                          Text(
                            notification.time,
                            style: TextStyle(
                              color: AppTheme.textSecondary.withValues(
                                alpha: .6,
                              ),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Quick Actions (Delete/Close button)
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppTheme.textSecondary.withValues(alpha: .5),
                      ),
                      onPressed: onDelete,
                      splashRadius: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _notificationColor(NotificationType type) {
    return switch (type) {
      NotificationType.info => AppTheme.primaryColor,
      NotificationType.announcement => const Color(0xFFF59E0B),
      NotificationType.security => const Color(0xFF10B981),
      NotificationType.system => const Color(0xFF6366F1),
    };
  }

  IconData _notificationIcon(NotificationType type) {
    return switch (type) {
      NotificationType.info => Icons.info_outline_rounded,
      NotificationType.announcement => Icons.campaign_rounded,
      NotificationType.security => Icons.verified_user_outlined,
      NotificationType.system => Icons.settings_suggest_rounded,
    };
  }

  String _notificationLabel(NotificationType type) {
    return switch (type) {
      NotificationType.info => 'INFORMASI',
      NotificationType.announcement => 'PENGUMUMAN',
      NotificationType.security => 'KEAMANAN',
      NotificationType.system => 'SISTEM',
    };
  }
}

class WidgetDivider extends StatelessWidget {
  const WidgetDivider({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Divider(color: color, height: 1);
  }
}
