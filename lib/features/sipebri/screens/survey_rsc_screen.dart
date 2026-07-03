import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/features/sipebri/dummy/dummy_sipebri.dart';

class SipebriSurveyRscScreen extends ConsumerStatefulWidget {
  final bool showBackButton;
  final VoidCallback? onMenuTap;

  const SipebriSurveyRscScreen({
    super.key,
    this.showBackButton = false,
    this.onMenuTap,
  });

  @override
  ConsumerState<SipebriSurveyRscScreen> createState() =>
      _SipebriSurveyRscScreenState();
}

class _SipebriSurveyRscScreenState
    extends ConsumerState<SipebriSurveyRscScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _filteredSurveys {
    if (_searchQuery.isEmpty) {
      return allSurveys;
    }
    return allSurveys
        .where(
          (name) => name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredSurveys;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),

        // Dynamic leading icon
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
              )
            : widget.onMenuTap != null
            ? IconButton(
                icon: Icon(Icons.menu_rounded, size: 24.sp),
                onPressed: widget.onMenuTap,
              )
            : widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.pop(context),
              )
            : null,

        // Dynamic title
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Cari survey RSC...',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 16.sp,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Text(
                'SURVEY RSC',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),

        // Search action
        actions: [
          if (!_isSearching)
            IconButton(
              icon: Icon(Icons.search_rounded, size: 24.sp),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            )
          else if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _searchController.clear();
            _searchQuery = '';
            _isSearching = false;
          });
        },
        child: filtered.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _buildSurveyTile(
                    name: 'TIDAK ADA DATA',
                    hasActiveStatus: false,
                    isEmptyState: true,
                  ),
                ],
              )
            : ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (context, index) => Container(
                  height: 1.h,
                  color: AppTheme.inputBorder.withValues(alpha: 0.5),
                ),
                itemBuilder: (context, index) {
                  final name = filtered[index];
                  final hasActiveStatus = activeStatusMap[name] ?? false;
                  return _buildSurveyTile(
                    name: name,
                    hasActiveStatus: hasActiveStatus,
                    isEmptyState: false,
                  );
                },
              ),
      ),
    );
  }

  Widget _buildSurveyTile({
    required String name,
    required bool hasActiveStatus,
    required bool isEmptyState,
  }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          width: 40.r,
          height: 40.r,
          decoration: const BoxDecoration(
            color: AppTheme.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person_rounded, color: Colors.white, size: 20.sp),
        ),
        title: Text(
          name.toUpperCase(),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isEmptyState ? AppTheme.textSecondary : AppTheme.textPrimary,
            letterSpacing: 0.2,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasActiveStatus && !isEmptyState) ...[
              Container(
                width: 8.r,
                height: 8.r,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
            ],
            Icon(
              Icons.chevron_right_rounded,
              color: isEmptyState
                  ? AppTheme.textSecondary.withValues(alpha: 0.3)
                  : AppTheme.textSecondary.withValues(alpha: 0.6),
              size: 20.sp,
            ),
          ],
        ),
        onTap: isEmptyState
            ? null
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Membuka detail survey RSC untuk $name'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
      ),
    );
  }
}
