import 'package:flutter/material.dart';
import 'package:portfolio_core/models/project.dart';
import 'package:portfolio_core/models/skill.dart';

class PortfolioData extends ChangeNotifier {
  // Personal Information
  final String name = 'Ali';
  final String title = 'Neovim Enthusiast & Developer';
  final String email = 'ali@example.com';
  final String github = 'https://github.com/your-username';
  final String linkedin = 'https://linkedin.com/in/your-profile';

  // Bio with coding references
  final String bio =
      '''I'm a passionate developer and terminal enthusiast who lives by the keyboard. Vim motions are my second language, and I believe efficient code is beautiful code.

My development environment is carefully crafted with Neovim, tmux, and a custom set of dotfiles that I've been perfecting for years. When I'm not optimizing my workflow, I'm building applications with a focus on performance and clean architecture.''';

  // Skills
  final List<Skill> skills = [
    Skill(name: 'Neovim/Vim', level: 0.95),
    Skill(name: 'Flutter/Dart', level: 0.90),
    Skill(name: 'Lua', level: 0.85),
    Skill(name: 'TypeScript', level: 0.80),
    Skill(name: 'Rust', level: 0.75),
    Skill(name: 'Docker', level: 0.80),
    Skill(name: 'Linux/Shell', level: 0.90),
    Skill(name: 'Git', level: 0.85),
  ];

  // Projects
  final List<Project> projects = [
    Project(
      id: 'neovim-config-manager',
      title: 'Neovim Config Manager',
      description:
          'A plugin manager and configuration system for Neovim that allows for modular configuration and easy installation of plugins across multiple machines.',
      technologies: ['Lua', 'Neovim API', 'Shell'],
      imageUrl: 'assets/images/project1.png',
      githubUrl: 'https://github.com/your-username/nvim-config',
      liveUrl: 'https://your-nvim-config.com',
    ),
    Project(
      id: 'terminal-dashboard',
      title: 'Terminal Dashboard',
      description:
          'A Flutter-based dashboard that provides a coding-focused overview of your system resources, git repositories, and task management in a terminal aesthetic.',
      technologies: ['Flutter', 'Dart', 'System APIs'],
      imageUrl: 'assets/images/project2.png',
      githubUrl: 'https://github.com/your-username/term-dashboard',
      liveUrl: 'https://your-term-dashboard.com',
    ),
    Project(
      id: 'code-snippet-manager',
      title: 'Code Snippet Manager',
      description:
          'A cross-platform application for organizing and searching code snippets with syntax highlighting, tags, and keyboard-centric navigation.',
      technologies: ['Flutter', 'SQLite', 'Provider'],
      imageUrl: 'assets/images/project3.png',
      githubUrl: 'https://github.com/your-username/snippet-manager',
      liveUrl: 'https://your-snippet-manager.com',
    ),
    Project(
      id: 'dotfiles-orchestrator',
      title: 'Dotfiles Orchestrator',
      description:
          'A Rust-based tool that manages and synchronizes dotfiles across multiple machines, with automated installation and configuration of development tools.',
      technologies: ['Rust', 'TOML', 'Shell'],
      imageUrl: 'assets/images/project4.png',
      githubUrl: 'https://github.com/your-username/dotfiles-orch',
      liveUrl: 'https://your-dotfiles-tool.com',
    ),
  ];
}