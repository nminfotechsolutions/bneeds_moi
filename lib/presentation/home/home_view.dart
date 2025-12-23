// lib/presentation/home/home_view.dartimport 'dart:ui';
import 'dart:ui';

import 'package:bneeds_moi/data/models/collection_model.dart';
import 'package:bneeds_moi/presentation/home/home_state.dart';
import 'package:bneeds_moi/presentation/home/home_viewmodel.dart';
import 'package:bneeds_moi/presentation/member/member_view.dart';
import 'package:bneeds_moi/presentation/new_entry/new_entry_view.dart';
import 'package:bneeds_moi/presentation/return_entry/return_entry_view.dart';
import 'package:bneeds_moi/presentation/screens/SettingsScreen.dart';
import 'package:bneeds_moi/presentation/statement/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// ✨ படி 1: மொழிபெயர்ப்பு கோப்பை import செய்யவும்
import 'package:bneeds_moi/core/utils/app_localizations.dart';

import '../../core/utils/shared_prefrences_helper.dart';
import '../ledger/ledger_view.dart';
import '../profile/profile_screen.dart';
import '../return_det_view/return_entry_det_view.dart';
import '../widgets/shimmer_loading.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
    void initState() {
      super.initState();
      Future.microtask(() {
        final cloudId = SharedPrefsHelper.getCloudId();
        if (cloudId != null && cloudId.isNotEmpty) {
          ref.read(homeViewModelProvider.notifier).fetchHomeData(cloudId);
        } else {
          print("Home Screen: Cloud ID not found in SharedPreferences!");
        }
      });
    }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final homeDataState = ref.watch(homeViewModelProvider);
    // ✨ படி 2: மொழிபெயர்ப்பு instance-ஐப் பெறவும்
    final lang = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: homeDataState.when(
        loading: () => _buildHomeShimmer(),
        error: (error, stackTrace) =>
            Center(child: Text('Failed to load data: $error')),
        data: (homeData) {
          final functionData = homeData.functionDetails;
          final topContributors = homeData.topContributors;

          if (functionData == null) {
            return const Center(child: Text('No Function Details Found.'));
          }

          final formattedDate = functionData.funcDate.isNotEmpty
              ? DateFormat('dd MMM yyyy')
              .format(DateTime.parse(functionData.funcDate))
              : 'N/A';
          final formattedTime = functionData.funcTime.isNotEmpty
              ? DateFormat('hh:mm a')
              .format(DateTime.parse(functionData.funcTime))
              : 'N/A';

          return CustomScrollView(
            slivers: [
              _buildGrandAppBar(context, functionData, lang), // lang-ஐ அனுப்பவும்
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _grandStatsRow(
                          context, formattedDate, formattedTime, functionData),
                      const SizedBox(height: 24),
                      // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
                      _buildSectionHeader(context, lang.quickActions),
                      const SizedBox(height: 12),
                      _buildQuickActions(context, lang), // lang-ஐ அனுப்பவும்
                      const SizedBox(height: 24),
                      // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
                      _buildSectionHeader(context, lang.topContributors),
                      const SizedBox(height: 12),
                      if (topContributors.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child:
                          Center(child: Text('No contributors data found.')),
                        )
                      else
                        Column(
                          children: topContributors.map((contributor) {
                            int rank =
                                topContributors.indexOf(contributor) + 1;
                            return _buildTopContributorCard(
                                context, contributor, rank);
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      // ✨ PopupMenuButton-இல் மொழிபெயர்ப்பைப் பயன்படுத்தவும்
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Show a menu with "Add Collection" and "Add Return"
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.library_add_outlined),
                      title: Text(lang.addCollection), // ✨ மொழிபெயர்ப்பு
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const NewEntryScreen()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.keyboard_return_outlined),
                      title: Text(lang.addReturn), // ✨ மொழிபெயர்ப்பு
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ReturnEntryScreen()));
                      },
                    ),
                  ],
                );
              });
        },
        backgroundColor: colorScheme.secondary,
        icon: Icon(Icons.add, color: colorScheme.onSecondary),
        label: Text(lang.newEntry, // ✨ மொழிபெயர்ப்பு
            style: TextStyle(
                color: colorScheme.onSecondary, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildGrandAppBar(
      BuildContext context, dynamic functionData, AppLocalizations lang) {
    final String personName = functionData.personName ?? '';
    final String userInitials = personName.length >= 2
        ? personName.substring(0, 2).toUpperCase()
        : (personName.isNotEmpty ? personName[0].toUpperCase() : 'B');

    return SliverAppBar(
      expandedHeight: 180.0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      pinned: true,
      stretch: true,

      title: Text(
        functionData.funcHead,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle
        ],
        background: _grandFunctionCard(context, functionData),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()));
          },
        ),
      ],
    );
  }





// lib/presentation/home/home_view.dart

// ... (மற்ற குறியீடுகள்)

  // ✨ lang-ஐ παραμέτρος-ஆகப் பெறவும்
  Widget _buildQuickActions(BuildContext context, AppLocalizations lang) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        // 1. Report
        _quickActionItem(context,
            icon: Icons.receipt_long_outlined,
            label: lang.report,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const ReportScreen()));
            }),
        // 2. Members
        _quickActionItem(context,
            icon: Icons.people_alt_outlined,
            label: lang.members,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MemberScreen()));
            }),
        // 3. Add Collection (இது Floating Action Button-இல் இருப்பதால், இங்கே தேவையில்லை என்றால் அகற்றலாம்)
        _quickActionItem(context,
            icon: Icons.library_add_outlined,
            label: lang.addCollection,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NewEntryScreen()));
            }),
        _quickActionItem(context,
            icon: Icons.account_balance_wallet_outlined, // பொருத்தமான ஐகான்
            label: lang.ledger, // அல்லது lang.ledger என மொழிபெயர்ப்பில் சேர்க்கவும்
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const LedgerScreen()));
            }),

        _quickActionItem(context,
            icon: Icons.keyboard_return_outlined, // புதிய ஐகான்
            label: lang.returnList,       // சரியான பெயர்
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ReturnEntryScreen()));
            }),

        _quickActionItem(context,
            icon: Icons.menu_book_outlined, // புதிய ஐகான்
            label: lang.returnDetails,       // சரியான பெயர்
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ReturnEntryDetScreen()));
            }),
      ],
    );
  }


  Widget _buildTopContributorCard(
      BuildContext context, CollectionModel contributor, int rank) {
    final colorScheme = Theme.of(context).colorScheme;
    final rankDetails = {
      1: {'icon': Icons.emoji_events, 'color': Colors.amber.shade600},
      2: {'icon': Icons.military_tech, 'color': Colors.grey.shade400},
      3: {'icon': Icons.workspace_premium, 'color': Colors.brown.shade400},
    };
    final details =
        rankDetails[rank] ?? {'icon': Icons.star, 'color': colorScheme.primary};
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shadowColor: colorScheme.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: rank == 1
            ? BorderSide(color: details['color'] as Color, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(details['icon'] as IconData,
                color: details['color'] as Color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contributor.memName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  if (contributor.cityName.isNotEmpty)
                    Text(
                      contributor.cityName,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text('₹${contributor.amount}',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary)),
          ],
        ),
      ),
    );
  }

  Widget _grandFunctionCard(BuildContext context, dynamic functionData) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;

    final formattedDate = functionData.funcDate.isNotEmpty
        ? DateFormat('dd MMM yyyy')
        .format(DateTime.parse(functionData.funcDate))
        : 'N/A';
    final formattedTime = functionData.funcTime.isNotEmpty
        ? DateFormat('hh:mm a')
        .format(DateTime.parse(functionData.funcTime))
        : 'N/A';
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double top = constraints.biggest.height;
        final double opacity =
            (top - kToolbarHeight) / (220.0 - kToolbarHeight).clamp(0.0, 1.0);
        return Container(
          decoration: BoxDecoration(
            borderRadius:
            const BorderRadius.vertical(bottom: Radius.circular(32)),
            gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            boxShadow: [
              BoxShadow(
                  color: primaryColor.withOpacity(0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 10))
            ],
          ),
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: kToolbarHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flexible(
                  //     child: Text(functionData.funcHead,
                  //         style: const TextStyle(
                  //             fontSize: 28,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.white,
                  //             letterSpacing: 0.8))),
                  const SizedBox(height: 8),
                  _infoRow(Icons.person_outline, functionData.personName),
                  const SizedBox(height: 8),
                  _infoRow(Icons.date_range, '$formattedDate  $formattedTime'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _grandStatsRow(
      BuildContext context, String date, String time, dynamic functionData) {
    final int totalMembers = int.tryParse(functionData.billNo ?? '0') ?? 0;
    final double totalAmount = functionData.totalCollection.toDouble();
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
              child: _statGlassCard(context,
                  icon: Icons.group_rounded,
                  title: 'Total Members',
                  value: totalMembers.toString(),
                  color: Theme.of(context).colorScheme.primary)),
          const SizedBox(width: 16),
          Expanded(
              child: _statGlassCard(context,
                  icon: Icons.currency_rupee,
                  title: "Total Amount",
                  value: totalAmount.toString(),
                  color: Theme.of(context).colorScheme.secondary)),
        ],
      ),
    );
  }

  // lib/presentation/home/home_view.dart

// ... (மற்ற குறியீடுகள்)

  Widget _quickActionItem(BuildContext context,
      {required IconData icon,
        required String label,
        required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 4))
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
            const SizedBox(height: 8),

            // ✨ முக்கிய மாற்றம்: Text விட்ஜெட்டை FittedBox-க்குள் வைத்தல்
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0), // ஓரங்களில் சிறிய இடைவெளி
              child: FittedBox(
                fit: BoxFit.scaleDown, // உரை பெரிதாக இருந்தால், அளவைக் குறை
                child: Text(
                  label,
                  textAlign: TextAlign.center, // உரையை மையப்படுத்துதல்
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 12), // இயல்புநிலை fontSize
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// ... (மீதமுள்ள குறியீடுகள்)


  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground)),
    );
  }

  Widget _statGlassCard(BuildContext context,
      {required IconData icon,
        required String title,
        required String value,
        required Color color}) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.8),
              border: Border.all(color: Colors.white.withOpacity(0.2))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 12),
              Text(value,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(title,
                  style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode
                          ? Colors.white70
                          : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                      fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.white.withOpacity(0.85)),
        const SizedBox(width: 12),
        Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500))),
      ],
    );
  }

  Widget _buildHomeShimmer() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AppBar Shimmer
          const ShimmerBox(width: double.infinity, height: 180, borderRadius: 0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Stats Row Shimmer
                Row(
                  children: [
                    Expanded(child: const ShimmerBox(width: double.infinity, height: 100, borderRadius: 22)),
                    const SizedBox(width: 16),
                    Expanded(child: const ShimmerBox(width: double.infinity, height: 100, borderRadius: 22)),
                  ],
                ),
                const SizedBox(height: 24),
                // Section Header
                const ShimmerBox(width: 150, height: 24),
                const SizedBox(height: 12),
                // Quick Actions Grid Shimmer
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: List.generate(6, (index) => const ShimmerBox(width: double.infinity, height: 100, borderRadius: 20)),
                ),
                const SizedBox(height: 24),
                // Section Header
                const ShimmerBox(width: 150, height: 24),
                const SizedBox(height: 12),
                // Top Contributor Cards Shimmer
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: const ShimmerBox(width: double.infinity, height: 80, borderRadius: 16),
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
