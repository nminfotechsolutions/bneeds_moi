// lib/presentation/home/home_state.dart
import '../../data/models/function_model.dart';
import '../../data/models/collection_model.dart';

class HomeState {
  final FunctionModel? functionDetails;
  final List<CollectionModel> topContributors;
  final double totalReturn; // ✨ படி 1: இந்த வரியைச் சேர்க்கவும்

  HomeState({
    this.functionDetails,
    this.topContributors = const [],
    this.totalReturn = 0.0, // ✨ படி 2: Constructor-இல் சேர்க்கவும்
  });

  HomeState copyWith({
    FunctionModel? functionDetails,
    List<CollectionModel>? topContributors,
    double? totalReturn, // ✨ படி 3: copyWith-இல் சேர்க்கவும்
  }) {
    return HomeState(
      functionDetails: functionDetails ?? this.functionDetails,
      topContributors: topContributors ?? this.topContributors,
      totalReturn: totalReturn ?? this.totalReturn, // ✨ படி 4: ഇവിടെയും ചേർക്കുക
    );
  }
}
