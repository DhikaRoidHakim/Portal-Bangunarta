import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:avatar_plus/avatar_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false, // Menghilangkan back button bawaan
        title: Row(
          children: [
            Image.asset('assets/images/logo_polos.png', width: 28, height: 28),
            const SizedBox(width: 8),
            const Text(
              'BPR BANGUNARTA',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
            ),
            child: IconButton(
              icon: const Icon(Icons.person_outline),
              color: AppTheme.primaryColor,
              onPressed: () {},
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppTheme.inputBorder, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DATA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Profil',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.inputBorder),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: AppTheme.textSecondary,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildProfileHeader(),
            const SizedBox(height: 32),
            const Text(
              'Informasi Profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Perbarui informasi profil dan alamat surel akun Anda.',
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.textPrimary.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildLabeledTextField(
                                label: 'Nama Lengkap',
                                initialValue: 'Ilham Sigit Waluya',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildLabeledTextField(
                                label: 'Username',
                                initialValue: 'Sigit',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildLabeledTextField(
                          label: 'Alamat Email',
                          initialValue: 'Sigit@Bprbangunarta.co.id',
                        ),
                        const SizedBox(height: 16),
                        _buildLabeledTextField(
                          label: 'Kantor',
                          initialValue: 'Kantor Pusat Pamanukan',
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildLabeledTextField(
                                label: 'Kode Kolektor',
                                initialValue: '661',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildLabeledTextField(
                                label: 'COA Samba',
                                initialValue: '1.100.2.2',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildLabeledTextField(
                          label: 'Password Baru',
                          hintText: '(Optional)',
                          isPassword: true,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(
                        0xFFF8FAFC,
                      ), // A very light gray background for the footer
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Divider(
                          color: AppTheme.inputBorder,
                          height: 1,
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.save_outlined, size: 20),
                              label: const Text(
                                'Simpan',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF006CE3),
                                foregroundColor: AppTheme.surfaceWhite,
                                elevation: 6,
                                shadowColor: const Color(
                                  0xFF006CE3,
                                ).withValues(alpha: 0.4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.15),
                width: 2,
              ),
            ),
            child: Center(child: AvatarPlus("Ilham Sigit")),
          ),
          // Container(
          //   width: 34,
          //   height: 34,
          //   decoration: BoxDecoration(
          //     color: AppTheme.primaryColor,
          //     shape: BoxShape.circle,
          //     border: Border.all(color: AppTheme.surfaceWhite, width: 2.5),
          //     boxShadow: [
          //       BoxShadow(
          //         color: AppTheme.primaryColor.withValues(alpha: 0.3),
          //         blurRadius: 8,
          //         offset: const Offset(0, 4),
          //       ),
          //     ],
          //   ),
          //   // child: IconButton(
          //   //   padding: EdgeInsets.zero,
          //   //   iconSize: 16,
          //   //   icon: const Icon(Icons.camera_alt, color: AppTheme.surfaceWhite),
          //   //   onPressed: () {
          //   //     // Tindakan ubah foto
          //   //   },
          //   // ),
          // ),
        ],
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    String? initialValue,
    String? hintText,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50), // Standard dark text
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          obscureText: isPassword ? _obscurePassword : false,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF334155),
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 15,
              color: AppTheme.textSecondary,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            filled: true,
            fillColor: const Color(
              0xFFF8FAFC,
            ), // A very subtle gray matching the footer
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppTheme.inputBorder,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF006CE3),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
