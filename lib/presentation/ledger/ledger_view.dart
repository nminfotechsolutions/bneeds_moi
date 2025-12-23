// lib/presentation/ledger/ledger_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/utils/app_localizations.dart';
import '../../core/utils/shared_prefrences_helper.dart';
import '../../core/utils/tamil_search_utils.dart';
import '../../data/models/ledger_model.dart';
import 'ledger_viewmodel.dart';
import '../widgets/shimmer_loading.dart';

//<----------- LedgerScreen Class ----------->
class LedgerScreen extends ConsumerStatefulWidget {
  const LedgerScreen({super.key});

  @override
  ConsumerState<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends ConsumerState<LedgerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });

    // ✨ படி 2: initState-இல் cloudId-ஐப் பயன்படுத்தவும்
    Future.microtask(() {
      final cloudId = SharedPrefsHelper.getCloudId();
      if (cloudId != null && cloudId.isNotEmpty) {
        ref.read(ledgerViewModelProvider.notifier).fetchLedgerView(cloudId);
      } else {
        print("Ledger Screen: Cloud ID not found in SharedPreferences!");
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ledgerState = ref.watch(ledgerViewModelProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final lang = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(lang.memberLedger, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: colorScheme.primaryContainer,
        elevation: 1.0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildSearchField(context, lang),
          Expanded(
            child: ledgerState.when(
              loading: () => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: 10,
                itemBuilder: (context, index) => const ShimmerListTile(),
              ),
              error: (error, stack) => Center(child: Text('தரவைப் பெறுவதில் பிழை: $error')),
              data: (ledgerList) {
                final filteredList = ledgerList.where((member) {
                  return TamilSearchUtils.searchInFields(_searchQuery, [
                    member.memName,
                    member.cityName,
                    member.memMobileNo,
                  ]);
                }).toList();

                if (ledgerList.isEmpty) {
                  return Center(child: Text(lang.noLedgerData));
                }

                if (filteredList.isEmpty && _searchQuery.isNotEmpty) {
                  return Center(child: Text(lang.noResults));
                }

                return RefreshIndicator(
                  // ✨✨ முக்கிய மாற்றம் இங்கே ✨✨
                  onRefresh: () async {
                    // SharedPreferences-லிருந்து cloudId-ஐப் பெறவும்
                    final cloudId = SharedPrefsHelper.getCloudId();
                    if (cloudId != null && cloudId.isNotEmpty) {
                      // cloudId இருந்தால், தரவை மீண்டும் fetch செய்யவும்
                      await ref.read(ledgerViewModelProvider.notifier).fetchLedgerView(cloudId);
                    }
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final memberLedger = filteredList[index];
                      return _buildMemberCard(context, memberLedger);
                    },
                  ),
                );

              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, AppLocalizations lang) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: lang.searchPlaceholder,
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, LedgerViewModel memberLedger) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final totalAmount = memberLedger.ledger.fold(0, (sum, entry) => sum + entry.amount);
    final totalReturn = memberLedger.ledger.fold(0, (sum, entry) => sum + entry.returnAmount);
    final balance = totalAmount - totalReturn;
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // புதிய Detail Screen க்கு செல்ல
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LedgerDetailScreen(member: memberLedger),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  memberLedger.memName.isNotEmpty ? memberLedger.memName[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memberLedger.memName,
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${memberLedger.cityName} | ${memberLedger.memMobileNo}',
                      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildBalanceChip(context, balance, currencyFormat),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceChip(BuildContext context, int balance, NumberFormat format) {
    final bool isPositive = balance >= 0;
    final Color chipColor = isPositive ? Colors.green.shade700 : Colors.red.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: chipColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        format.format(balance.abs()),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: chipColor,
          fontSize: 14,
        ),
      ),
    );
  }
}


//<----------- LedgerDetailScreen Class ----------->
class LedgerDetailScreen extends StatelessWidget {
  final LedgerViewModel member;

  const LedgerDetailScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final totalAmount = member.ledger.fold(0, (sum, entry) => sum + entry.amount);
    final totalReturn = member.ledger.fold(0, (sum, entry) => sum + entry.returnAmount);
    final balance = totalAmount - totalReturn;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(member.memName, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceStatCard(
              context: context,
              lang: lang,
              totalCredit: totalAmount,
              totalReturn: totalReturn,
              balance: balance,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context, lang.memberDetails),
            _buildDetailCard(context, [
              _buildDetailRow(context, Icons.phone_outlined, lang.mobile, member.memMobileNo),
              _buildDetailRow(context, Icons.location_city_outlined, lang.city, member.cityName),
              _buildDetailRow(context, Icons.school_outlined, lang.education, member.memEdu),
              _buildDetailRow(context, Icons.work_outline, lang.occupation, member.memWork),
              _buildDetailRow(context, Icons.person_outline, lang.spouseName, member.memSpouse),
              _buildDetailRow(context, Icons.info_outline, lang.notes, member.memIni),
            ]),
            const SizedBox(height: 24),
            _buildSectionHeader(context, lang.transactionList),
            if (member.ledger.isNotEmpty)
              ...member.ledger.map((entry) => _buildTransactionTile(context, entry, lang)).toList()
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(lang.noTransactions),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

//<----------- Helper Functions for LedgerDetailScreen ----------->

Widget _buildSectionHeader(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    ),
  );
}

Widget _buildDetailCard(BuildContext context, List<Widget> children) {
  // ✨✨ மாற்றம் ✨✨
  // இங்கு இப்போது whereType<Widget> என்று மாற்றியுள்ளோம், அதனால் எல்லா விட்ஜெட்களும் ஏற்றுக்கொள்ளப்படும்.
  final validChildren = children.where((child) => child is! SizedBox || (child.height != 0 && child.width != 0)).toList();
  if (validChildren.isEmpty) return const SizedBox.shrink();

  return Card(
    elevation: 0,
    color: Theme.of(context).colorScheme.surfaceContainer,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: validChildren),
    ),
  );
}

// ✨✨ மாற்றம் இங்கே ✨✨
// இப்போது இந்தச் செயல்பாடு Widget-ஐ திருப்பி அனுப்புகிறது, இது SizedBox அல்லது Padding ஆக இருக்கலாம்.
Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
  if (value.trim().isEmpty) return const SizedBox(height: 0, width: 0); // SizedBox ஐ திருப்பி அனுப்புங்கள்

  final colorScheme = Theme.of(context).colorScheme;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildBalanceStatCard({
  required BuildContext context,
  required AppLocalizations lang,
  required int totalCredit,
  required int totalReturn,
  required int balance,
}) {
  final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
  final bool isPositive = balance >= 0;

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: [
          isPositive ? Colors.green.shade700 : Colors.red.shade700,
          isPositive ? Colors.green.shade500 : Colors.red.shade500,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: (isPositive ? Colors.green : Colors.red).withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.balanceAmount,
          style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
        ),
        const SizedBox(height: 8),
        Text(
          currencyFormat.format(balance),
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Divider(height: 32, color: Colors.white30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StatItem(label: lang.totalCredit, amount: currencyFormat.format(totalCredit)),
            _StatItem(label: lang.totalDebit, amount: currencyFormat.format(totalReturn)),
          ],
        ),
      ],
    ),
  );
}

Widget _buildTransactionTile(BuildContext context, LedgerEntry entry, AppLocalizations lang) {
  final bool isCredit = entry.amount > 0;
  final currencyFormat = NumberFormat.decimalPattern();

  return Card(
    elevation: 0,
    margin: const EdgeInsets.symmetric(vertical: 5),
    color: Theme.of(context).colorScheme.surfaceContainer,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: (isCredit ? Colors.green : Colors.red).withOpacity(0.1),
        child: Icon(
          isCredit ? Icons.arrow_downward : Icons.arrow_upward,
          color: isCredit ? Colors.green.shade700 : Colors.red.shade700,
          size: 22,
        ),
      ),
      title: Text(
        isCredit ? lang.credit : lang.debit,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        DateFormat('dd MMM yyyy').format(DateTime.parse(entry.billDate)),
        style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      trailing: Text(
        '₹${currencyFormat.format(isCredit ? entry.amount : entry.returnAmount)}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isCredit ? Colors.green.shade800 : Colors.red.shade800,
        ),
      ),
    ),
  );
}

class _StatItem extends StatelessWidget {
  final String label;
  final String amount;
  const _StatItem({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9)),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
