import 'package:flutter/foundation.dart'; // Use foundation for ChangeNotifier
import 'package:portfolio_core/models/project.dart';
import 'package:portfolio_core/models/skill.dart';
import 'package:portfolio_core/models/user_info.dart'; // Import UserInfo model
import 'package:portfolio_core/services/portfolio_service.dart'; // Import the service

class PortfolioData extends ChangeNotifier {
  final PortfolioService _portfolioService = PortfolioService();

  // Private fields to store fetched data
  List<Skill> _skills = [];
  List<Project> _projects = [];
  UserInfo? _userInfo; // Changed from Map<String, dynamic> to UserInfo?
  bool _isLoading = false;
  String? _error; // Optional: field to store error messages

  // Public getters
  List<Skill> get skills => _skills;
  List<Project> get projects => _projects;
  UserInfo? get userInfo => _userInfo; // Changed getter
  bool get isLoading => _isLoading;
  String? get error => _error; // Optional: getter for error

  // Specific getters for personal info for convenience - access via UserInfo?
  String get name => _userInfo?.name ?? 'Your Name';
  String get title => _userInfo?.title ?? 'Your Title';
  String get email => _userInfo?.contactEmail ?? '';
  String get github => _userInfo?.githubUrl ?? '';
  String get linkedin => _userInfo?.linkedinUrl ?? '';
  String get bio => _userInfo?.bio ?? 'Your bio goes here...';
  String get profileImageUrl => _userInfo?.profilePictureUrl ?? '';

  // Method to load data from Firestore
  Future<void> loadPortfolioData() async {
    if (_isLoading) return; // Prevent concurrent loads

    _isLoading = true;
    _error = null; // Clear previous errors
    notifyListeners();

    try {
      // First ensure all collections have default values for null fields
      await _portfolioService.ensureDefaultValues();

      // Fetch data concurrently
      final results = await Future.wait([
        _portfolioService.getProjects(),
        _portfolioService.getSkills(),
        _portfolioService.getUserInfo(), // Changed method name
      ]);

      // Assign fetched data - Ensure type safety
      _projects = results[0] as List<Project>;
      _skills = results[1] as List<Skill>;
      _userInfo = results[2] as UserInfo?; // Changed type and assignment
    } catch (e) {
      print('Error loading portfolio data: $e');
      _error =
          'Failed to load portfolio data. Please try again later.'; // Set error message
      // Optionally clear data on error or keep stale data
      // _projects = [];
      // _skills = [];
      _userInfo = null; // Clear user info on error
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners regardless of success or failure
    }
  }
}
