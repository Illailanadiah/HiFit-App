class FitnessPlan {
  final String mood;
  final String energyLevel;
  final String medication;
  final List<String> recommendedWorkouts;

  FitnessPlan({
    required this.mood,
    required this.energyLevel,
    required this.medication,
    required this.recommendedWorkouts,
  });

  // Convert data to a Firestore-friendly format
  Map<String, dynamic> toMap() {
    return {
      'mood': mood,
      'energyLevel': energyLevel,
      'medication': medication,
      'recommendedWorkouts': recommendedWorkouts,
    };
  }

  // Create a FitnessPlan object from Firestore
  factory FitnessPlan.fromFirestore(Map<String, dynamic> data) {
    return FitnessPlan(
      mood: data['mood'],
      energyLevel: data['energyLevel'],
      medication: data['medication'],
      recommendedWorkouts: List<String>.from(data['recommendedWorkouts']),
    );
  }
}
