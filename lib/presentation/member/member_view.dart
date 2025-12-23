// lib/presentation/member/member_view.dart

import 'package:bneeds_moi/core/utils/app_localizations.dart'; // ✨ படி 1: மொழிபெயர்ப்பு கோப்பை import செய்யவும்
import 'package:bneeds_moi/presentation/new_entry/new_entry_view.dart';
import 'package:bneeds_moi/presentation/return_entry/return_entry_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/shared_prefrences_helper.dart';
import '../../core/utils/tamil_search_utils.dart';
import '../../data/models/collection_model.dart';
import 'member_viewmodel.dart';
import '../widgets/shimmer_loading.dart';

class MemberScreen extends ConsumerStatefulWidget {
  const MemberScreen({super.key});

  @override
  ConsumerState<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends ConsumerState<MemberScreen> {
  List<CollectionModel> allMembers = [];
  late List<CollectionModel> filteredMembers;
  String? selectedCity;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredMembers = [];

    // ✨ படி 2: initState-இல் cloudId-ஐப் பயன்படுத்தவும்
    Future.microtask(() {
      // SharedPreferences-லிருந்து cloudId-ஐப் பெறுகிறோம்
      final cloudId = SharedPrefsHelper.getCloudId();

      // cloudId இருந்தால் மட்டும் தரவை fetch செய்கிறோம்
      if (cloudId != null && cloudId.isNotEmpty) {
        ref.read(memberViewModelProvider.notifier).fetchCollectionDetails(cloudId);
      } else {
        // ஒருவேளை cloudId கிடைக்கவில்லை என்றால், கன்சோலில் அச்சிடலாம்.
        print("Member Screen: Cloud ID not found in SharedPreferences!");
      }
    });

    _searchController.addListener(() {
      if (allMembers.isNotEmpty) {
        _searchMembers(_searchController.text);
      }
    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMembers(String? city) {
    setState(() {
      selectedCity = city;
      _searchMembers(_searchController.text);
    });
  }

  void _searchMembers(String query) {
    setState(() {
      List<CollectionModel> membersToSearch;
      if (selectedCity != null) {
        membersToSearch =
            allMembers.where((member) => member.cityName == selectedCity).toList();
      } else {
        membersToSearch = allMembers;
      }

      if (query.isEmpty) {
        filteredMembers = membersToSearch;
      } else {
        filteredMembers = membersToSearch
            .where((member) =>
                TamilSearchUtils.searchInFields(query, [
                  member.memName,
                  member.memSpouse,
                  member.cityName,
                  member.memWork,
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
    final memberState = ref.watch(memberViewModelProvider);
    // ✨ படி 2: மொழிபெயர்ப்பு instance-ஐப் பெறவும்
    final lang = AppLocalizations.of(context);

    AppBar buildAppBarWithData(List<CollectionModel> members) {
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
              // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
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
              onPressed: () {
                if (_searchController.text.isEmpty) {
                  _toggleSearch();
                } else {
                  _searchController.clear();
                }
              },
            ),
          ],
        );
      } else {
        final cities =
        members.map((e) => e.cityName).where((c) => c.isNotEmpty).toSet().toList();

        final Map<String, int> cityCounts = {};
        for (var member in members) {
          if (member.cityName.isNotEmpty) {
            cityCounts[member.cityName] = (cityCounts[member.cityName] ?? 0) + 1;
          }
        }

        return AppBar(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
          title: Text(lang.memberList),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.2),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _toggleSearch,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Container(
              color: colorScheme.primary,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    _buildFilterChip('All', selectedCity == null,
                            () => _filterMembers(null),
                        count: members.length),
                    const SizedBox(width: 8),
                    ...cities.map((city) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildFilterChip(
                        city,
                        selectedCity == city,
                            () => _filterMembers(city),
                        count: cityCounts[city],
                      ),
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
      appBar: memberState.maybeWhen(
        data: (members) => buildAppBarWithData(members),
        orElse: () => AppBar(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
          title: Text(lang.memberList),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const NewEntryScreen()));
        },
        backgroundColor: colorScheme.secondary,
        icon: Icon(Icons.add, color: colorScheme.onSecondary),
        // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
        label: Text(lang.addCollection,
            style: TextStyle(
                color: colorScheme.onSecondary, fontWeight: FontWeight.bold)),
      ),
      body: memberState.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: 8,
          itemBuilder: (context, index) => const ShimmerMemberCard(),
        ),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (members) {
          if (allMembers.isEmpty && members.isNotEmpty) {
            allMembers = members;
            filteredMembers = allMembers;
          }

          if (filteredMembers.isEmpty) {
            return Center(
              child: Text(
                _searchController.text.isNotEmpty
                    ? 'No members found.'
                    : 'No members found for this city.',
                style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
            itemCount: filteredMembers.length,
            itemBuilder: (context, index) {
              final member = filteredMembers[index];
              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + (index % 10 * 80)),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                      opacity: value,
                      child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)), child: child));
                },
                child: _buildMemberCard(member, colorScheme),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap,
      {int? count}) {
    final colorScheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count != null)
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onPrimary.withOpacity(0.7),
                ),
              ),
            ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) => onTap(),
      backgroundColor: colorScheme.primaryContainer.withOpacity(0.4),
      selectedColor: colorScheme.surface,
      labelStyle: TextStyle(
        color: isSelected ? colorScheme.primary : colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onPrimary.withOpacity(0.5),
        ),
      ),
      elevation: isSelected ? 2 : 0,
      shadowColor: colorScheme.shadow,
    );
  }

  Widget _buildMemberCard(CollectionModel member, ColorScheme colorScheme) {
    final lang = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Theme.of(context).shadowColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surface,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              member.memName.isNotEmpty ? member.memName[0].toUpperCase() : '?',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            '${member.memIni} ${member.memName}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                fontSize: 18),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('W/o: ${member.memSpouse}',
                  style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      height: 1.4),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              Text(member.cityName,
                  style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.4),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              Text('Edu: ${member.memEdu}',
                  style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      height: 1.4),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '₹${member.amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: const SizedBox.shrink(), // 👈 இதுதான் அம்புக்குறியை (Arrow) மறைக்கும்
        children: [
          const Divider(height: 1, indent: 16, endIndent: 16, thickness: 0.5),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: Column(
              children: [
                _buildDetailRow(
                    Icons.work_outline, 'Occupation', member.memWork, colorScheme),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewEntryScreen(initialData: member),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        label: Text(lang.addCollection),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primaryContainer,
                          foregroundColor: colorScheme.onPrimaryContainer,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReturnEntryScreen(initialData: member),
                            ),
                          );
                        },
                        icon: const Icon(Icons.keyboard_return, size: 20),
                        label: Text(lang.addReturn),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      IconData icon, String label, String value, ColorScheme colorScheme) {
    // ✨ மொழிபெயர்ப்பைப் பயன்படுத்த இந்த முறையையும் மாற்றலாம்
    final lang = AppLocalizations.of(context);
    String displayLabel = label;
    if (label == 'Occupation') {
      displayLabel = lang.occupation;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.onSurface.withOpacity(0.7), size: 20),
          const SizedBox(width: 16),
          Text(
            '$displayLabel: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
