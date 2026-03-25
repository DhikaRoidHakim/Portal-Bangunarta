import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';

// ─────────────────────────────────────────────────────────────
// Main Screen
// ─────────────────────────────────────────────────────────────
class DetailKreditScreen extends StatefulWidget {
  final String? namaDebitur;
  final String? nomorKredit;

  const DetailKreditScreen({
    super.key,
    this.namaDebitur,
    this.nomorKredit,
  });

  @override
  State<DetailKreditScreen> createState() => _DetailKreditScreenState();
}

class _DetailKreditScreenState extends State<DetailKreditScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  late AnimationController _headerAnim;
  late Animation<double> _fadeAnim;

  final List<Map<String, dynamic>> _penangananList = [
    {
      'tanggal': 'Rabu, 20 Agustus 2025',
      'isExpanded': true,
      'petugas': 'Cecep Suhandi',
      'jenis': 'Melakukan Penagihan – Penagihan Kredit',
      'fu': 'Fu kerumah deb',
      'lainnya':
          'Acah, bertemu dengan deb, deb akan bayar dikantor tgl 22.08.25 sumber dana dari hasil gaji suaminya di bangunan',
      'tunggakanPokok': '0',
      'tunggakanBunga': '0',
      'tunggakanDenda': '0',
      'catatan':
          'M. Zam Zami: pastikan kembali catat di google calender',
    },
    {'tanggal': 'Jumat, 18 Juli 2025', 'isExpanded': false},
    {'tanggal': 'Kamis, 17 Juli 2025', 'isExpanded': false},
    {'tanggal': 'Rabu, 16 Juli 2025', 'isExpanded': false},
    {'tanggal': 'Rabu, 16 Juli 2025', 'isExpanded': false},
    {'tanggal': 'Selasa, 15 Juli 2025', 'isExpanded': false},
    {'tanggal': 'Kamis, 26 Juni 2025', 'isExpanded': false},
    {'tanggal': 'Kamis, 26 Juni 2025', 'isExpanded': false},
    {'tanggal': 'Rabu, 25 Juni 2025', 'isExpanded': false},
  ];

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nama = widget.namaDebitur ?? 'ACAH CAHYATI';
    final noKredit = widget.nomorKredit ?? '001010140151516756';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(nama, noKredit, innerBoxIsScrolled),
        ],
        body: _buildBody(),
      ),
    );
  }

  // ── Sliver AppBar with gradient header ──────────────────────
  Widget _buildSliverAppBar(
      String nama, String noKredit, bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 190,
      pinned: true,
      elevation: 0,
      backgroundColor: AppTheme.primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new,
            color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: AnimatedOpacity(
        opacity: innerBoxIsScrolled ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(
          nama,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: _buildHeaderBackground(nama, noKredit),
      ),
    );
  }

  Widget _buildHeaderBackground(String nama, String noKredit) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1a1070),
            Color(0xFF092966),
            Color(0xFF0d3d7a),
          ],
        ),
      ),
      child: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nama,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.credit_card_outlined,
                                color:
                                    Colors.white.withValues(alpha: .7),
                                size: 13,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                noKredit,
                                style: TextStyle(
                                  color:
                                      Colors.white.withValues(alpha: .8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF10B981)
                              .withValues(alpha: .5),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'Aktif',
                        style: TextStyle(
                          color: Color(0xFF6EE7B7),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Mini stats strip
                Row(
                  children: [
                    _MiniStat(
                        label: 'Plafon',
                        value: '18,6 Jt',
                        icon: Icons.account_balance_wallet_outlined),
                    _miniDivider(),
                    _MiniStat(
                        label: 'Baki Debet',
                        value: '4,26 Jt',
                        icon: Icons.payments_outlined),
                    _miniDivider(),
                    _MiniStat(
                        label: 'Angsuran',
                        value: 'Ke-38',
                        icon: Icons.calendar_today_outlined),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniDivider() => Container(
        width: 1,
        height: 32,
        color: Colors.white.withValues(alpha: .2),
        margin: const EdgeInsets.symmetric(horizontal: 12),
      );

  // ── Body ────────────────────────────────────────────────────
  Widget _buildBody() {
    return Column(
      children: [
        // Tab pill selector
        Container(
          color: AppTheme.primaryColor,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          child: _TabSelector(
            selected: _selectedTab,
            onChanged: (i) => setState(() => _selectedTab = i),
          ),
        ),
        // Content
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: _selectedTab == 0
                ? const _KreditTab()
                : _selectedTab == 1
                    ? const _AgunanTab()
                    : _PenangananTab(
                        key: const ValueKey('penanganan'),
                        items: _penangananList,
                        onToggle: (index) {
                          setState(() {
                            _penangananList[index]['isExpanded'] =
                                !_penangananList[index]['isExpanded'];
                          });
                        },
                      ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Mini Stat Widget (header strip)
// ─────────────────────────────────────────────────────────────
class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _MiniStat(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: .6), size: 14),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .6),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Tab Selector – premium pill style
// ─────────────────────────────────────────────────────────────
class _TabSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  const _TabSelector({required this.selected, required this.onChanged});

  static const _labels = ['Kredit', 'Agunan', 'Penanganan'];
  static const _icons = [
    Icons.credit_score_outlined,
    Icons.home_work_outlined,
    Icons.handshake_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: List.generate(_labels.length, (i) {
          final isActive = selected == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _icons[i],
                      size: 13,
                      color: isActive
                          ? AppTheme.primaryColor
                          : Colors.white.withValues(alpha: .75),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _labels[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isActive
                            ? AppTheme.primaryColor
                            : Colors.white.withValues(alpha: .75),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Tab 1: Kredit
// ─────────────────────────────────────────────────────────────
class _KreditTab extends StatelessWidget {
  const _KreditTab();

  static const _sections = [
    {
      'header': 'Informasi Kontak',
      'fields': [
        {'label': 'Nomor HP', 'value': '081212450920', 'icon': 'phone'},
        {'label': 'Nomor CIF', 'value': '00133317709', 'icon': 'badge'},
        {'label': 'Nomor SPK', 'value': '591/KRU/IV/2019', 'icon': 'doc'},
        {
          'label': 'No. Tabungan',
          'value': '0010101201034165',
          'icon': 'savings'
        },
      ],
    },
    {
      'header': 'Detail Fasilitas',
      'fields': [
        {'label': 'Plafon', 'value': 'Rp 18.600.000', 'icon': 'money', 'highlight': true},
        {'label': 'Baki Debet', 'value': 'Rp 4.262.500', 'icon': 'money', 'highlight': true},
        {'label': 'Jangka Waktu', 'value': '48 Bulan', 'icon': 'time'},
        {'label': 'Rate Bunga', 'value': '18% / tahun', 'icon': 'percent'},
        {'label': 'Metode RPS', 'value': 'Flat', 'icon': 'method'},
      ],
    },
    {
      'header': 'Jadwal & Status',
      'fields': [
        {'label': 'Realisasi', 'value': '14 Juni 2022', 'icon': 'calendar'},
        {'label': 'Jatuh Tempo', 'value': '14 Juni 2026', 'icon': 'calendar'},
        {'label': 'Angsuran Ke', 'value': '38 dari 48', 'icon': 'progress'},
      ],
    },
    {
      'header': 'Tunggakan',
      'fields': [
        {'label': 'Tunggakan Pokok', 'value': 'Rp 0', 'icon': 'money', 'ok': true},
        {'label': 'Tunggakan Bunga', 'value': 'Rp 0', 'icon': 'money', 'ok': true},
        {'label': 'Tunggakan Denda', 'value': 'Rp 0', 'icon': 'money', 'ok': true},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('kredit'),
      padding: const EdgeInsets.all(16),
      children: _sections.map((section) {
        final fields =
            (section['fields'] as List).cast<Map<String, dynamic>>();
        return _SectionCard(
          header: section['header'] as String,
          child: Column(
            children: List.generate(fields.length, (i) {
              final f = fields[i];
              return Column(
                children: [
                  _KreditFieldRow(field: f),
                  if (i < fields.length - 1)
                    const Divider(
                      color: Color(0xFFEEF0F6),
                      thickness: 0.8,
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }),
          ),
        );
      }).toList(),
    );
  }
}

class _KreditFieldRow extends StatelessWidget {
  final Map<String, dynamic> field;
  const _KreditFieldRow({required this.field});

  IconData _iconFor(String? key) {
    switch (key) {
      case 'phone':
        return Icons.phone_outlined;
      case 'badge':
        return Icons.badge_outlined;
      case 'doc':
        return Icons.description_outlined;
      case 'savings':
        return Icons.savings_outlined;
      case 'money':
        return Icons.account_balance_wallet_outlined;
      case 'time':
        return Icons.timer_outlined;
      case 'percent':
        return Icons.percent;
      case 'method':
        return Icons.tune_outlined;
      case 'calendar':
        return Icons.calendar_month_outlined;
      case 'progress':
        return Icons.format_list_numbered_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHighlight = field['highlight'] == true;
    final isOk = field['ok'] == true;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isOk
                  ? const Color(0xFF10B981).withValues(alpha: .1)
                  : isHighlight
                      ? AppTheme.primaryColor.withValues(alpha: .08)
                      : const Color(0xFFF1F3FB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _iconFor(field['icon'] as String?),
              size: 17,
              color: isOk
                  ? const Color(0xFF10B981)
                  : isHighlight
                      ? AppTheme.primaryColor
                      : AppTheme.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field['label'] as String,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  field['value'] as String,
                  style: TextStyle(
                    color: isOk
                        ? const Color(0xFF10B981)
                        : isHighlight
                            ? AppTheme.primaryColor
                            : AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (isOk)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: .1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Lunas',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Tab 2: Agunan
// ─────────────────────────────────────────────────────────────
class _AgunanTab extends StatelessWidget {
  const _AgunanTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('agunan'),
      padding: const EdgeInsets.all(16),
      children: [
        _SectionCard(
          header: 'Data Agunan',
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.primaryColor.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: .2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.home_work_outlined,
                          size: 13, color: AppTheme.primaryColor),
                      const SizedBox(width: 5),
                      const Text(
                        'Tanah & Bangunan',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'SERTIFIKAT TANAH DAN BANGUNAN NO 610, LUAS 794 M2, ATAS NAMA ACAH CAHYATI, ALAMAT LEGONWETAN LEGONKULON SUBANG JAWA BARAT',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.7,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 16),
                // Detail chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _AgunanChip(
                        icon: Icons.map_outlined, label: 'Luas 794 m²'),
                    _AgunanChip(
                        icon: Icons.numbers_outlined,
                        label: 'No. 610'),
                    _AgunanChip(
                        icon: Icons.location_on_outlined,
                        label: 'Subang, Jawa Barat'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AgunanChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _AgunanChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3FB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.textSecondary),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Tab 3: Penanganan (Accordion)
// ─────────────────────────────────────────────────────────────
class _PenangananTab extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final ValueChanged<int> onToggle;

  const _PenangananTab(
      {super.key, required this.items, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('penanganan'),
      padding: const EdgeInsets.all(16),
      children: [
        ...List.generate(items.length, (i) {
          final item = items[i];
          final isExpanded = item['isExpanded'] == true;
          final hasDetail = item.containsKey('petugas');

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: isExpanded
                    ? Border.all(
                        color:
                            AppTheme.primaryColor.withValues(alpha: .25),
                        width: 1.2)
                    : Border.all(
                        color: const Color(0xFFEEF0F6), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .035),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Column(
                  children: [
                    // Accordion header
                    InkWell(
                      onTap: () => onToggle(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: isExpanded
                                    ? AppTheme.primaryColor
                                        .withValues(alpha: .1)
                                    : const Color(0xFFF1F3FB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.event_note_outlined,
                                size: 16,
                                color: isExpanded
                                    ? AppTheme.primaryColor
                                    : AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item['tanggal'],
                                style: TextStyle(
                                  color: isExpanded
                                      ? AppTheme.primaryColor
                                      : AppTheme.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            AnimatedRotation(
                              turns: isExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: isExpanded
                                    ? AppTheme.primaryColor
                                    : AppTheme.textSecondary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Expanded detail
                    AnimatedCrossFade(
                      firstChild: const SizedBox(width: double.infinity),
                      secondChild: hasDetail
                          ? _PenangananDetail(item: item)
                          : const Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 14),
                              child: Text(
                                'Detail tidak tersedia.',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                      crossFadeState: isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 250),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _PenangananDetail extends StatelessWidget {
  final Map<String, dynamic> item;
  const _PenangananDetail({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Petugas chip
          Row(
            children: [
              const Icon(Icons.person_pin_circle_outlined,
                  size: 14, color: AppTheme.primaryColor),
              const SizedBox(width: 5),
              Text(
                item['petugas'] ?? '',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _DetailBlock(
              icon: Icons.task_alt_outlined,
              title: 'Jenis Kegiatan',
              content: item['jenis'] ?? ''),
          _DetailBlock(
              icon: Icons.home_outlined,
              title: 'Follow Up',
              content: item['fu'] ?? ''),
          _DetailBlock(
              icon: Icons.notes_outlined,
              title: 'Catatan',
              content: item['lainnya'] ?? ''),
          const SizedBox(height: 10),
          // Tunggakan row
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFEEF0F6)),
            ),
            child: Row(
              children: [
                _TunggakanBadge(
                    label: 'Pokok',
                    value: item['tunggakanPokok'] ?? '0'),
                const SizedBox(width: 1),
                Container(
                    width: 1,
                    height: 28,
                    color: const Color(0xFFEEF0F6)),
                const SizedBox(width: 1),
                _TunggakanBadge(
                    label: 'Bunga',
                    value: item['tunggakanBunga'] ?? '0'),
                const SizedBox(width: 1),
                Container(
                    width: 1,
                    height: 28,
                    color: const Color(0xFFEEF0F6)),
                const SizedBox(width: 1),
                _TunggakanBadge(
                    label: 'Denda',
                    value: item['tunggakanDenda'] ?? '0'),
              ],
            ),
          ),
          if (item.containsKey('catatan')) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.sticky_note_2_outlined,
                      size: 14, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item['catatan'],
                      style: const TextStyle(
                        color: Color(0xFF92400E),
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  const _DetailBlock(
      {required this.icon, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 13, color: AppTheme.textSecondary),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TunggakanBadge extends StatelessWidget {
  final String label;
  final String value;
  const _TunggakanBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isZero = value == '0' || value == 'Rp 0';
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              color: isZero ? const Color(0xFF10B981) : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Section Card wrapper
// ─────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String header;
  final Widget child;
  const _SectionCard({required this.header, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    header,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
                height: 1,
                thickness: 0.8,
                color: Color(0xFFEEF0F6)),
            child,
          ],
        ),
      ),
    );
  }
}
