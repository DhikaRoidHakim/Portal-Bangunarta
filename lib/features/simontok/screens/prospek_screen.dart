import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:go_router/go_router.dart';

class ProspekPage extends StatelessWidget {
  final bool showBackButton;
  const ProspekPage({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
        title: Text(
          'PROSPEK',
          style: TextStyle(color: AppTheme.textWhite, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.textPrimary.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildProspekItem(context, 'ENTER BINTI H TOHIR'),
                _buildProspekItem(context, 'ENIH BINTI ASMIN'),
                _buildProspekItem(context, 'AGUN GUNAWAN BIN SAMBAS'),
                _buildProspekItem(context, 'ANDRIAS SANDRIA AGUSTIAN'),
                _buildProspekItem(context, 'KARWECIH'),
                _buildProspekItem(context, 'UNENGSIH'),
                _buildProspekItem(context, 'HENDRA'),
                _buildProspekItem(context, 'CICIH WIDIANINGSIH'),
                _buildProspekItem(context, 'SANTI JUANTI'),
                _buildProspekItem(context, 'STHEPANUS YUS WINARKO'),
                _buildProspekItem(context, 'WAWA WIBAWA', isLast: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProspekItem(BuildContext context, String name, {bool isLast = false}) {
    return GestureDetector(
      onTap: () => context.push('/simontok/detail-prospek', extra: name),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7F8C9D),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(color: AppTheme.textPrimary).copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isLast)
            const Divider(
              color: AppTheme.inputBorder,
              thickness: 0.5,
              height: 0,
              indent: 72,
            ),
        ],
      ),
    );
  }
}
