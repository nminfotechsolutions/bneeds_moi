// lib/presentation/statement/report_screen.dartimport 'package:bneeds_moi/data/repositories/statement_repository.dart';
import 'package:bneeds_moi/presentation/statement/report_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 
import 'package:intl/intl.dart';
import '../../core/utils/app_localizations.dart';
import '../../data/models/statement_model.dart';
import '../../data/repositories/statement_repository.dart';
import 'pdf_generator.dart';
import '../widgets/shimmer_loading.dart';

// Filter நிலையை நிர்வகிக்க ஒரு provider
enum StatementFilter { all, collection, returned }

final statementFilterProvider =
StateProvider<StatementFilter>((ref) => StatementFilter.all);

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  final ExpansionTileController _expansionTileController =
  ExpansionTileController();

  @override
  void initState() {
    super.initState();
    // பக்கம் திறந்தவுடன், எந்த தேடல் παραμέτρος-ம் இல்லாமல் தரவைப் பெறவும்
    Future.microtask(() {
      ref
          .read(statementViewModelProvider.notifier)
          .fetchStatements(StatementSearchParams());
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final lang = AppLocalizations.of(context);
    final statementState = ref.watch(statementViewModelProvider);
    final viewModel = ref.read(statementViewModelProvider.notifier);
    final activeFilter = ref.watch(statementFilterProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(lang.statementReport),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 1,
        scrolledUnderElevation: 2.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            // lib/presentation/statement/report_screen.dart
// ... (மற்ற குறியீடுகள்)
// lib/presentation/statement/report_screen.dart
// ... (மற்ற குறியீடுகள் அப்படியே)

// பிரிண்ட் பட்டனுக்கான onPressed செயல்பாடு
            onPressed: () {
              statementState.whenData((response) {
                if (response != null && response.statements.isNotEmpty) {
                  // PDF தலைப்பை அமைக்கவும்
                  String functionName = viewModel.functionController.text.isNotEmpty
                      ? viewModel.functionController.text
                      : "Statement Report"; // இயல்புநிலை தலைப்பு

                  // முதல் statement-இல் இருந்து ஒருவேளை function பெயர் கிடைத்தால் அதைப் பயன்படுத்தலாம்
                  // (உங்கள் API response-ஐப் பொறுத்து இதை மாற்றவும்)
                  // ఉదాహరణకు: final firstStatement = response.statements.first;
                  // if (firstStatement.functionName.isNotEmpty) {
                  //   functionName = firstStatement.functionName;
                  // }

                  PdfGenerator.generateAndPrintPdf(
                      response.statements, functionName);

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('No data available to print.')),
                  );
                }
              });
            },

// ... (மீதமுள்ள குறியீடுகள் அப்படியே)


          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (_expansionTileController.isExpanded) {
                _expansionTileController.collapse();
              } else {
                _expansionTileController.expand();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.fetchStatements(StatementSearchParams()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.fetchStatements(StatementSearchParams()),
        child: statementState.when(
          loading: () => ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) => const ShimmerListTile(),
          ),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (response) {
            if (response == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 60, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No data to display.'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () =>
                          viewModel.fetchStatements(StatementSearchParams()),
                      child: const Text('Fetch All Statements'),
                    )
                  ],
                ),
              );
            }
            if (response.statements.isEmpty) {
              return Column(
                children: [
                  _buildSearchPanel(context, viewModel, response.statements),
                  const Expanded(
                    child: Center(
                        child: Text('No statements found for your query.')),
                  ),
                ],
              );
            }

            final totalCollection = response.statements
                .where((s) => s.amount > 0)
                .fold(0.0, (sum, item) => sum + item.amount);

            final totalReturn = response.statements
                .where((s) => s.paidAmount > 0)
                .fold(0.0, (sum, item) => sum + item.paidAmount);

            final filteredStatements =
            _getFilteredStatements(response.statements, activeFilter);

            return ListView(
              children: [
                _buildSearchPanel(context, viewModel, response.statements),
                _buildStatsHeader(
                  context,
                  totalEntries: response.total,
                  totalCollection: totalCollection,
                  totalReturn: totalReturn,
                  netAmount: totalCollection - totalReturn,
                ),
                _buildFilterChips(context, ref),
                ...filteredStatements
                    .map((statement) =>
                    _buildStatementTile(context, statement, activeFilter))
                    .toList(),
              ],
            );
          },
        ),
      ),
    );
  }

  List<StatementModel> _getFilteredStatements(
      List<StatementModel> statements, StatementFilter filter) {
    switch (filter) {
      case StatementFilter.collection:
        return statements.where((s) => s.amount > 0).toList();
      case StatementFilter.returned:
        return statements.where((s) => s.paidAmount > 0).toList();
      case StatementFilter.all:
      default:
        return statements;
    }
  }

  Widget _buildSearchPanel(BuildContext context, StatementViewModel viewModel,
      List<StatementModel> statements) {
    final colorScheme = Theme.of(context).colorScheme;
    final uniqueCities = statements.map((s) => s.city).toSet().toList();

    return Material(
      color: colorScheme.surface,
      child: ExpansionTile(
        controller: _expansionTileController,
        title: const Text('Advanced Search',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.filter_list),
        backgroundColor: colorScheme.surface,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'City Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  value: viewModel.cityController.text.isEmpty
                      ? null
                      : viewModel.cityController.text,
                  items: uniqueCities.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    viewModel.cityController.text = newValue ?? '';
                  },
                ),
                const SizedBox(height: 12),
                Visibility(
                  visible: false,
                  child: TextFormField(
                    controller: viewModel.functionController,
                    decoration: InputDecoration(
                      labelText: 'Function Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                TextFormField(
                  controller: viewModel.memberController,
                  decoration: InputDecoration(
                    labelText: 'Member Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                    onPressed: () {
                      viewModel.search();
                      _expansionTileController.collapse();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(BuildContext context,
      {required int totalEntries,
        required double totalCollection,
        required double totalReturn,
        required double netAmount}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        // ✨ முக்கிய மாற்றம்: childAspectRatio-இன் மதிப்பு சரிசெய்யப்பட்டது
        childAspectRatio: 1.6,
        children: [
          _buildStatCard(context,
              label: 'Total Entries',
              amount: totalEntries.toDouble(),
              color: Colors.blueGrey,
              icon: Icons.list_alt),
          _buildStatCard(context,
              label: 'Total Amount',
              amount: totalCollection,
              color: Colors.green.shade600,
              icon: Icons.arrow_downward_rounded),
          _buildStatCard(context,
              label: 'Total Return',
              amount: totalReturn,
              color: Colors.red.shade600,
              icon: Icons.arrow_upward_rounded),
          _buildStatCard(context,
              label: 'Net Balance',
              amount: netAmount,
              color: Theme.of(context).colorScheme.primary,
              icon: Icons.account_balance_wallet_outlined)
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context,
      {required String label,
        required double amount,
        required Color color,
        required IconData icon}) {
    final bool isInteger = amount == amount.truncate();
    final formatCurrency = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: isInteger ? 0 : 2,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label == 'Total Entries'
                ? amount.toInt().toString()
                : formatCurrency.format(amount),
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: color.withOpacity(0.8))),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(statementFilterProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: activeFilter == StatementFilter.all,
            onSelected: (selected) {
              if (selected) {
                ref.read(statementFilterProvider.notifier).state =
                    StatementFilter.all;
              }
            },
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Collections'),
            selected: activeFilter == StatementFilter.collection,
            onSelected: (selected) {
              if (selected) {
                ref.read(statementFilterProvider.notifier).state =
                    StatementFilter.collection;
              }
            },
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Returns'),
            selected: activeFilter == StatementFilter.returned,
            onSelected: (selected) {
              if (selected) {
                ref.read(statementFilterProvider.notifier).state =
                    StatementFilter.returned;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatementTile(
      BuildContext context, StatementModel statement, StatementFilter activeFilter) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    bool isCollection;
    if (activeFilter == StatementFilter.collection) {
      isCollection = true;
    } else if (activeFilter == StatementFilter.returned) {
      isCollection = false;
    } else {
      // In "All" mode, prioritize showing collection if both exist, 
      // otherwise show return if it exists.
      isCollection = statement.amount > 0;
    }

    final Color amountColor =
    isCollection ? Colors.green.shade700 : Colors.red.shade700;
    final IconData amountIcon =
    isCollection ? Icons.arrow_downward : Icons.arrow_upward;
    final int displayAmount =
    isCollection ? statement.amount : statement.paidAmount;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      elevation: 0.5,
      color: colorScheme.background,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: amountColor.withOpacity(0.1),
          child: Icon(amountIcon, color: amountColor),
        ),
        title: Text(
          statement.description,
          style:
          textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(statement.city,
            style: textTheme.bodyMedium
                ?.copyWith(color: Colors.grey.shade600)),
        trailing: Text(
          '₹${displayAmount.abs()}',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: amountColor,
          ),
        ),
      ),
    );
  }
}
