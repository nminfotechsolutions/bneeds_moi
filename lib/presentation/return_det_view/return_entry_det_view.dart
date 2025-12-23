// lib/presentation/return_det_view/return_entry_det_view.dart

import 'package:bneeds_moi/core/utils/app_localizations.dart';
import 'package:bneeds_moi/presentation/return_entry/return_entry_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/shared_prefrences_helper.dart';
import '../../core/utils/tamil_search_utils.dart';
import '../../data/models/return_details_model.dart';
import 'return_det_viewmodel.dart';
import '../widgets/shimmer_loading.dart';

class ReturnEntryDetScreen extends ConsumerStatefulWidget {
  const ReturnEntryDetScreen({super.key});

  @override
  ConsumerState<ReturnEntryDetScreen> createState() => _ReturnEntryDetScreenState();
}

class _ReturnEntryDetScreenState extends ConsumerState<ReturnEntryDetScreen> {
  List<ReturnDetailsModel> allReturns = [];
  late List<ReturnDetailsModel> filteredReturns;
  String? selectedCity;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredReturns = [];

    // ✨ படி 2: initState-இல் cloudId-ஐப் பயன்படுத்தவும்
    Future.microtask(() {
      // SharedPreferences-லிருந்து cloudId-ஐப் பெறுகிறோம்
      final cloudId = SharedPrefsHelper.getCloudId();

      // cloudId இருந்தால் மட்டும் தரவை fetch செய்கிறோம்
      if (cloudId != null && cloudId.isNotEmpty) {
        ref.read(returnDetViewModelProvider.notifier).fetchReturnDetails(cloudId);
      } else {
        // ஒருவேளை cloudId கிடைக்கவில்லை என்றால், கன்சோலில் அச்சிடலாம்.
        print("Return Details Screen: Cloud ID not found in SharedPreferences!");
      }
    });

    _searchController.addListener(() {
      if (allReturns.isNotEmpty) {
        _searchReturns(_searchController.text);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterReturns(String? city) {
    setState(() {
      selectedCity = city;
      _searchReturns(_searchController.text);
    });
  }

  void _searchReturns(String query) {
    setState(() {
      List<ReturnDetailsModel> returnsToSearch;
      if (selectedCity != null) {
        returnsToSearch =
            allReturns.where((item) => item.cityName == selectedCity).toList();
      } else {
        returnsToSearch = allReturns;
      }

      if (query.isEmpty) {
        filteredReturns = returnsToSearch;
      } else {
        filteredReturns = returnsToSearch
            .where((item) =>
                TamilSearchUtils.searchInFields(query, [
                  item.memName,
                  item.memSpouse,
                  item.cityName,
                ]))
            .toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final returnState = ref.watch(returnDetViewModelProvider);
    final lang = AppLocalizations.of(context);

    AppBar buildAppBarWithData(List<ReturnDetailsModel> returns) {
      if (_isSearching) {
        return AppBar(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _toggleSearch,
          ),
          title: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: lang.searchByName,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintStyle:
              TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
            ),
            style: TextStyle(color: colorScheme.onSurface, fontSize: 18),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _searchController.clear(),
            ),
          ],
        );
      } else {
        final cities =
        returns.map((e) => e.cityName).where((c) => c.isNotEmpty).toSet().toList();

        return AppBar(
          backgroundColor: colorScheme.secondary, // Secondary color for returns
          foregroundColor: colorScheme.onSecondary,
          title: Text(lang.returnList), // lang key தேவை
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _toggleSearch,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Container(
              color: colorScheme.secondary,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    _buildFilterChip('All', selectedCity == null,
                            () => _filterReturns(null)),
                    const SizedBox(width: 8),
                    ...cities.map((city) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildFilterChip(
                          city, selectedCity == city, () => _filterReturns(city)),
                    )),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: returnState.maybeWhen(
        data: (returns) => buildAppBarWithData(returns),
        orElse: () => AppBar(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          title: Text(lang.returnList), // lang key தேவை
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ReturnEntryScreen()));
        },
        backgroundColor: colorScheme.secondary,
        icon: Icon(Icons.add, color: colorScheme.onSecondary),
        label: Text(lang.addReturn,
            style: TextStyle(
                color: colorScheme.onSecondary, fontWeight: FontWeight.bold)),
      ),
      body: returnState.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: 8,
          itemBuilder: (context, index) => const ShimmerMemberCard(),
        ),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (returns) {
          if (allReturns.isEmpty && returns.isNotEmpty) {
            allReturns = returns;
            filteredReturns = allReturns;
          }

          if (filteredReturns.isEmpty) {
            return Center(
              child: Text(
                'No return entries found.',
                style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6), fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
            itemCount: filteredReturns.length,
            itemBuilder: (context, index) {
              final item = filteredReturns[index];
              return _buildReturnCard(item, colorScheme);
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onTap(),
      backgroundColor: colorScheme.secondary.withOpacity(0.2),
      selectedColor: colorScheme.surface,
      labelStyle: TextStyle(
        color: isSelected ? colorScheme.secondary : colorScheme.onSecondary,
        fontWeight: FontWeight.bold,
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: isSelected
              ? colorScheme.secondary
              : colorScheme.onSecondary.withOpacity(0.5),
        ),
      ),
    );
  }

  // ... (மற்ற குறியீடுகள்)

  Widget _buildReturnCard(ReturnDetailsModel item, ColorScheme colorScheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Theme.of(context).shadowColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        // ✨ முக்கிய மாற்றம்: tilePadding-ஐ contentPadding-ஆக மாற்றவும்
        contentPadding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              item.memName.isNotEmpty ? item.memName[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            '${item.memIni} ${item.memName}',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('W/o: ${item.memSpouse}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text(item.cityName,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.4),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '- ₹${item.amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        // trailing: ... (Amount moved to subtitle)
      ),
    );
  }
}


