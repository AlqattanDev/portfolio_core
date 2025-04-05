import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_core/models/project.dart';
import 'package:portfolio_core/models/skill.dart';

part 'portfolio_data_provider.g.dart';

// Define a simple class to hold both projects and skills
class PortfolioData {
  final List<Project> projects;
  final List<Skill> skills;

  PortfolioData({required this.projects, required this.skills});

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    final projectsList = (json['projects'] as List<dynamic>?)
            ?.map((e) => Project.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    // Sort projects by order
    projectsList.sort((a, b) => (a.order ?? 999).compareTo(b.order ?? 999));

    final skillsList = (json['skills'] as List<dynamic>?)
            ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    // Sort skills by level (descending)
    skillsList.sort((a, b) => (b.level ?? 0).compareTo(a.level ?? 0));

    return PortfolioData(
      projects: projectsList,
      skills: skillsList,
    );
  }
}

// Provider to load the JSON data once
@Riverpod(keepAlive: true)
Future<PortfolioData> portfolioData(PortfolioDataRef ref) async {
  final jsonString =
      await rootBundle.loadString('assets/data/portfolio_data.json');
  final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
  return PortfolioData.fromJson(jsonMap);
}

// Provider to expose the list of projects from the loaded data
@riverpod
Future<List<Project>> projectsFromJson(ProjectsFromJsonRef ref) async {
  final data = await ref.watch(portfolioDataProvider.future);
  return data.projects;
}

// Provider to expose the list of skills from the loaded data
@riverpod
Future<List<Skill>> skillsFromJson(SkillsFromJsonRef ref) async {
  final data = await ref.watch(portfolioDataProvider.future);
  return data.skills;
}
