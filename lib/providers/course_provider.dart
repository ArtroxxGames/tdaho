import 'package:flutter/material.dart';
import 'package:myapp/models/course.dart';
import 'package:myapp/services/storage_service.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];

  CourseProvider() {
    _loadCourses();
  }

  List<Course> get courses => _courses;

  // Cursos activos
  List<Course> get activeCourses => _courses.where((c) => c.isActive).toList();

  // Cursos pausados
  List<Course> get pausedCourses => _courses.where((c) => !c.isActive).toList();

  // Cursos para hoy
  List<Course> get coursesForToday {
    final today = DateTime.now();
    final dayOfWeek = today.weekday % 7; // 0=Domingo, 1=Lunes, etc.
    return activeCourses.where((course) => course.isAssignedForDay(dayOfWeek)).toList()
      ..sort((a, b) {
        // Ordenar por hora de inicio si tienen
        if (a.startTime != null && b.startTime != null) {
          return a.startTime!.compareTo(b.startTime!);
        }
        if (a.startTime != null) return -1;
        if (b.startTime != null) return 1;
        return 0;
      });
  }

  // Progreso promedio
  double get averageProgress {
    if (_courses.isEmpty) return 0.0;
    final total = _courses.fold(0, (sum, course) => sum + course.progress);
    return total / _courses.length;
  }

  void _loadCourses() {
    _courses = StorageService.loadList<Course>(
      StorageService.coursesBox,
      (json) => Course.fromJson(json),
    );
  }

  Future<void> _saveCourses() async {
    await StorageService.saveList(StorageService.coursesBox, _courses);
    notifyListeners();
  }

  Future<void> addCourse(Course course) async {
    _courses.add(course);
    await _saveCourses();
  }

  Future<void> updateCourse(Course oldCourse, Course newCourse) async {
    final index = _courses.indexOf(oldCourse);
    if (index != -1) {
      _courses[index] = newCourse.copyWith(updatedAt: DateTime.now());
      await _saveCourses();
    }
  }

  Future<void> deleteCourse(Course course) async {
    _courses.remove(course);
    await _saveCourses();
  }

  Future<void> toggleActive(Course course) async {
    final index = _courses.indexOf(course);
    if (index != -1) {
      _courses[index] = course.copyWith(
        isActive: !course.isActive,
        updatedAt: DateTime.now(),
      );
      await _saveCourses();
    }
  }

  Future<void> updateProgress(Course course, int progress) async {
    final index = _courses.indexOf(course);
    if (index != -1) {
      _courses[index] = course.copyWith(
        progress: progress.clamp(0, 100),
        updatedAt: DateTime.now(),
      );
      await _saveCourses();
    }
  }

  // Obtener cursos para un día específico
  List<Course> getCoursesForDay(int dayOfWeek) {
    return activeCourses.where((course) => course.isAssignedForDay(dayOfWeek)).toList()
      ..sort((a, b) {
        if (a.startTime != null && b.startTime != null) {
          return a.startTime!.compareTo(b.startTime!);
        }
        if (a.startTime != null) return -1;
        if (b.startTime != null) return 1;
        return 0;
      });
  }

  Future<void> deleteAll() async {
    _courses.clear();
    await _saveCourses();
  }
}

