import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/features/simontok/providers/simontok_provider.dart';
import 'package:bangunarta_portal/models/simontok/detail_pinjaman_model.dart';

class DetailKreditScreen extends ConsumerStatefulWidget {
  final String? namaDebitur;
  final String? nomorKredit;

  const DetailKreditScreen({super.key, this.namaDebitur, this.nomorKredit});

  @override
  ConsumerState<DetailKreditScreen> createState() => _DetailKreditScreenState();
}

class _DetailKreditScreenState extends ConsumerState<DetailKreditScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  late AnimationController _headerAnim;
  late Animation<double> _fadeAnim;

  final Set<int> _expandedTaskIds = {};

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

  String _formatRupiah(String? value) {
    if (value == null || value.isEmpty) return 'Rp 0';
    final number = double.tryParse(value);
    if (number == null) return value;
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(number);
  }

  String _formatRupiahShort(String? value) {
    if (value == null || value.isEmpty) return '0';
    final number = double.tryParse(value);
    if (number == null) return value;

    if (number >= 1000000) {
      final millions = number / 1000000;
      final formatted = millions.toStringAsFixed(
        millions.truncateToDouble() == millions ? 0 : 1,
      );
      return '$formatted Jt';
    }

    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    final noRekening = widget.nomorKredit ?? '';
    final detailPinjamanAsync = ref.watch(detailPinjamanProvider(noRekening));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: detailPinjamanAsync.when(
        data: (model) {
          final credit = model.data.credit;
          final collaterals = model.data.collaterals;
          final tasks = model.data.tasks;

          return RefreshIndicator(
            color: AppTheme.primaryColor,
            onRefresh: () async {
              ref.invalidate(detailPinjamanProvider(noRekening));
            },
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                _buildSliverAppBar(credit, innerBoxIsScrolled),
              ],
              body: _buildBody(credit, collaterals, tasks),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (error, stack) => _buildErrorState(error.toString()),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 56,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal Memuat Detail',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message.replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(
                  detailPinjamanProvider(widget.nomorKredit ?? ''),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(CreditDetailModel credit, bool innerBoxIsScrolled) {
    final nama = credit.namaDebitur;
    final noKredit = credit.nomorAlt ?? credit.nomorRekening;

    return SliverAppBar(
      expandedHeight: 190,
      pinned: true,
      elevation: 0,
      backgroundColor: AppTheme.primaryColor,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
        ),
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
        background: _buildHeaderBackground(credit),
      ),
    );
  }

  Widget _buildHeaderBackground(CreditDetailModel credit) {
    final nama = credit.namaDebitur;
    final noKredit = credit.nomorAlt ?? credit.nomorRekening;
    final isLancar = credit.coll == '1';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a1070), Color(0xFF092966), Color(0xFF0d3d7a)],
        ),
      ),
      child: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                                color: Colors.white.withValues(alpha: .7),
                                size: 13,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                noKredit,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: .8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isLancar
                            ? const Color(0xFF10B981).withValues(alpha: .2)
                            : Colors.amber.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isLancar
                              ? const Color(0xFF10B981).withValues(alpha: .5)
                              : Colors.amber.withValues(alpha: .5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        isLancar
                            ? 'Lancar (Coll ${credit.coll})'
                            : 'Perhatian (Coll ${credit.coll})',
                        style: TextStyle(
                          color: isLancar
                              ? const Color(0xFF6EE7B7)
                              : Colors.amber.shade200,
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
                      value: _formatRupiahShort(credit.plafondAwal),
                      icon: Icons.account_balance_wallet_outlined,
                    ),
                    _miniDivider(),
                    _MiniStat(
                      label: 'Baki Debet',
                      value: _formatRupiahShort(credit.bakiDebet),
                      icon: Icons.payments_outlined,
                    ),
                    _miniDivider(),
                    _MiniStat(
                      label: 'Jangka Waktu',
                      value: '${credit.jangkaWaktu ?? "-"} Bln',
                      icon: Icons.calendar_today_outlined,
                    ),
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

  Widget _buildBody(
    CreditDetailModel credit,
    List<CollateralModel> collaterals,
    List<TaskModel> tasks,
  ) {
    return Column(
      children: [
        // Tab selectors
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
                ? _KreditTab(credit: credit, formatRupiah: _formatRupiah)
                : _selectedTab == 1
                ? _AgunanTab(collaterals: collaterals)
                : _PenangananTab(
                    key: const ValueKey('penanganan'),
                    tasks: tasks,
                    expandedTaskIds: _expandedTaskIds,
                    onToggle: (id) {
                      setState(() {
                        if (_expandedTaskIds.contains(id)) {
                          _expandedTaskIds.remove(id);
                        } else {
                          _expandedTaskIds.add(id);
                        }
                      });
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
  });

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
                          ),
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

class _KreditTab extends StatelessWidget {
  final CreditDetailModel credit;
  final String Function(String?) formatRupiah;

  const _KreditTab({required this.credit, required this.formatRupiah});

  List<Map<String, dynamic>> get _sections => [
    {
      'header': 'Informasi Kontak',
      'fields': [
        {'label': 'Nomor HP', 'value': credit.nomorHp ?? '-', 'icon': 'phone'},
        {
          'label': 'Nomor CIF',
          'value': credit.nomorCif ?? '-',
          'icon': 'badge',
        },
        {
          'label': 'No. Rekening Alternatif',
          'value': credit.nomorAlt ?? '-',
          'icon': 'doc',
        },
        {
          'label': 'Wilayah / Resort',
          'value': credit.wilayah ?? '-',
          'icon': 'location',
        },
      ],
    },
    {
      'header': 'Detail Fasilitas',
      'fields': [
        {
          'label': 'Plafon',
          'value': formatRupiah(credit.plafondAwal),
          'icon': 'money',
          'highlight': true,
        },
        {
          'label': 'Baki Debet',
          'value': formatRupiah(credit.bakiDebet),
          'icon': 'money',
          'highlight': true,
        },
        {
          'label': 'Jangka Waktu',
          'value': '${credit.jangkaWaktu ?? "-"} Bulan',
          'icon': 'time',
        },
        {
          'label': 'Rate Bunga',
          'value': '${credit.rate ?? "-"}%',
          'icon': 'percent',
        },
        {
          'label': 'Metode RPS',
          'value': credit.metodeRps ?? '-',
          'icon': 'method',
        },
      ],
    },
    {
      'header': 'Jadwal & Status',
      'fields': [
        {
          'label': 'Realisasi',
          'value': credit.tglRealisasi ?? '-',
          'icon': 'calendar',
        },
        {
          'label': 'Jatuh Tempo',
          'value': credit.tglJatuhTempo ?? '-',
          'icon': 'calendar',
        },
        {
          'label': 'Kolektor Penanggung Jawab',
          'value': credit.kolektor ?? '-',
          'icon': 'badge',
        },
      ],
    },
    {
      'header': 'Tunggakan',
      'fields': [
        {
          'label': 'Tunggakan Pokok',
          'value': formatRupiah(credit.tunggakanPokok),
          'icon': 'money',
          'ok': credit.tunggakanPokok == '0' || credit.tunggakanPokok == null,
        },
        {
          'label': 'Tunggakan Bunga',
          'value': formatRupiah(credit.tunggakanBunga),
          'icon': 'money',
          'ok': credit.tunggakanBunga == '0' || credit.tunggakanBunga == null,
        },
        {
          'label': 'Tunggakan Denda',
          'value': formatRupiah(credit.tunggakanDenda),
          'icon': 'money',
          'ok': credit.tunggakanDenda == '0' || credit.tunggakanDenda == null,
        },
        {
          'label': 'Tunggakan Hari',
          'value': credit.tunggakanHari ?? '0',
          'icon': 'time',
          'ok': credit.tunggakanHari == '0' || credit.tunggakanHari == null,
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('kredit'),
      padding: const EdgeInsets.all(16),
      children: _sections.map((section) {
        final fields = (section['fields'] as List).cast<Map<String, dynamic>>();
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
      case 'location':
        return Icons.location_on_outlined;
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
          if (isOk && field['label'].toString().contains('Tunggakan'))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

class _AgunanTab extends StatelessWidget {
  final List<CollateralModel> collaterals;
  const _AgunanTab({required this.collaterals});

  @override
  Widget build(BuildContext context) {
    if (collaterals.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.home_work_outlined,
                size: 48,
                color: AppTheme.textSecondary,
              ),
              SizedBox(height: 12),
              Text(
                'Tidak Ada Data Agunan',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      key: const ValueKey('agunan'),
      padding: const EdgeInsets.all(16),
      itemCount: collaterals.length,
      itemBuilder: (context, index) {
        final col = collaterals[index];
        final isSertifikat = col.nama.toUpperCase().contains('SERTIFIKAT');

        return _SectionCard(
          header: 'Agunan Ke-${index + 1}',
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: .2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSertifikat
                            ? Icons.home_work_outlined
                            : Icons.description_outlined,
                        size: 13,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isSertifikat ? 'Tanah & Bangunan' : 'Dokumen Berharga',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  col.nama.trim(),
                  style: const TextStyle(
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
                    if (col.noregAlt != null && col.noregAlt!.isNotEmpty)
                      _AgunanChip(
                        icon: Icons.numbers_outlined,
                        label: 'No. Reg: ${col.noregAlt}',
                      ),
                    if (col.nomorAlt != null && col.nomorAlt!.isNotEmpty)
                      _AgunanChip(
                        icon: Icons.link_outlined,
                        label: 'Alt Norek: ${col.nomorAlt}',
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

class _PenangananTab extends StatelessWidget {
  final List<TaskModel> tasks;
  final Set<int> expandedTaskIds;
  final ValueChanged<int> onToggle;

  const _PenangananTab({
    super.key,
    required this.tasks,
    required this.expandedTaskIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.handshake_outlined,
                size: 48,
                color: AppTheme.textSecondary,
              ),
              SizedBox(height: 12),
              Text(
                'Belum Ada Riwayat Penanganan',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      key: const ValueKey('penanganan'),
      padding: const EdgeInsets.all(16),
      children: [
        ...List.generate(tasks.length, (i) {
          final item = tasks[i];
          final isExpanded = expandedTaskIds.contains(item.id);
          final isSelesai = item.status == 'Selesai';

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: isExpanded
                    ? Border.all(
                        color: AppTheme.primaryColor.withValues(alpha: .25),
                        width: 1.2,
                      )
                    : Border.all(color: const Color(0xFFEEF0F6), width: 1),
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
                    // Accordion Header
                    InkWell(
                      onTap: () => onToggle(item.id),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: isExpanded
                                    ? AppTheme.primaryColor.withValues(
                                        alpha: .1,
                                      )
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.tanggal ?? '-',
                                    style: TextStyle(
                                      color: isExpanded
                                          ? AppTheme.primaryColor
                                          : AppTheme.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.jenis ?? 'Penanganan',
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Status Badge
                            Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: isSelesai
                                    ? const Color(
                                        0xFF10B981,
                                      ).withValues(alpha: .1)
                                    : Colors.amber.withValues(alpha: .1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.status ?? 'Proses',
                                style: TextStyle(
                                  color: isSelesai
                                      ? const Color(0xFF10B981)
                                      : Colors.amber.shade800,
                                  fontSize: 10,
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
                    // Expanded Detail
                    AnimatedCrossFade(
                      firstChild: const SizedBox(width: double.infinity),
                      secondChild: _PenangananDetail(item: item),
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
  final TaskModel item;
  const _PenangananDetail({required this.item});

  @override
  Widget build(BuildContext context) {
    final hasTunggakan =
        item.tunggakanPokok != null ||
        item.tunggakanBunga != null ||
        item.tunggakanDenda != null;

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
          // Petugas ID / Maker info
          Row(
            children: [
              const Icon(
                Icons.person_pin_circle_outlined,
                size: 14,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 5),
              Text(
                item.executorId != null
                    ? 'Petugas ID: ${item.executorId}'
                    : 'Maker ID: ${item.makerId}',
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
            content: item.pelaksanaan ?? item.jenis ?? '-',
          ),
          _DetailBlock(
            icon: Icons.home_outlined,
            title: 'Follow Up',
            content: item.pelaksanaanDetail ?? '-',
          ),
          _DetailBlock(
            icon: Icons.check_circle_outline,
            title: 'Hasil Penanganan',
            content: item.hasil ?? '-',
          ),
          _DetailBlock(
            icon: Icons.notes_outlined,
            title: 'Keterangan Hasil',
            content: item.hasilDetail ?? '-',
          ),
          if (item.catatan != null && item.catatan!.isNotEmpty)
            _DetailBlock(
              icon: Icons.chat_bubble_outline,
              title: 'Catatan Maker',
              content: item.catatan!,
            ),
          if (hasTunggakan) ...[
            const SizedBox(height: 10),
            // Tunggakan Row
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
                    value: item.tunggakanPokok ?? '0',
                  ),
                  const SizedBox(width: 1),
                  Container(
                    width: 1,
                    height: 28,
                    color: const Color(0xFFEEF0F6),
                  ),
                  const SizedBox(width: 1),
                  _TunggakanBadge(
                    label: 'Bunga',
                    value: item.tunggakanBunga ?? '0',
                  ),
                  const SizedBox(width: 1),
                  Container(
                    width: 1,
                    height: 28,
                    color: const Color(0xFFEEF0F6),
                  ),
                  const SizedBox(width: 1),
                  _TunggakanBadge(
                    label: 'Denda',
                    value: item.tunggakanDenda ?? '0',
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
  const _DetailBlock({
    required this.icon,
    required this.title,
    required this.content,
  });

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
    final isZero = value == '0' || value == 'Rp 0' || value == '0.00';
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
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
            const Divider(height: 1, thickness: 0.8, color: Color(0xFFEEF0F6)),
            child,
          ],
        ),
      ),
    );
  }
}
