import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/course.dart';
import 'package:myapp/providers/course_provider.dart';
import 'package:myapp/widgets/add_course_form.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isListView = true;
  String _filter = 'Todos'; // Todos, Activos, Pausados

  void _showCourseForm(BuildContext context, {Course? course}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddCourseForm(
            course: course,
            onSave: (newCourse) async {
              final provider = Provider.of<CourseProvider>(context, listen: false);
              if (course == null) {
                await provider.addCourse(newCourse);
              } else {
                await provider.updateCourse(course, newCourse);
              }
            },
          ),
        );
      },
    );
  }

  List<Course> _getFilteredCourses(CourseProvider provider) {
    switch (_filter) {
      case 'Activos':
        return provider.activeCourses;
      case 'Pausados':
        return provider.pausedCourses;
      default:
        return provider.courses;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CourseProvider>(
        builder: (context, courseProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildSummaryCards(context, courseProvider),
                const SizedBox(height: 24),
                _buildCoursesForToday(context, courseProvider),
                const SizedBox(height: 24),
                _buildViewToggle(context),
                const SizedBox(height: 16),
                if (_isListView) ...[
                  _buildFilters(context),
                  const SizedBox(height: 16),
                  _buildListView(context, courseProvider),
                ] else
                  _buildCalendarView(context, courseProvider),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCourseForm(context),
        child: const Icon(Icons.add),
        tooltip: 'Nuevo Curso',
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Cursos & Educación',
          style: GoogleFonts.oswald(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(BuildContext context, CourseProvider provider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 768 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildSummaryCard(
              'Cursos Activos',
              provider.activeCourses.length.toString(),
              Colors.purple,
              Icons.school,
            ),
            _buildSummaryCard(
              'Pausados',
              provider.pausedCourses.length.toString(),
              Colors.orange,
              Icons.pause_circle,
            ),
            _buildSummaryCard(
              'Para Hoy',
              provider.coursesForToday.length.toString(),
              Colors.blue,
              Icons.today,
            ),
            _buildSummaryCard(
              'Progreso Promedio',
              '${provider.averageProgress.toStringAsFixed(0)}%',
              Colors.green,
              Icons.trending_up,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.oswald(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesForToday(BuildContext context, CourseProvider provider) {
    final coursesForToday = provider.coursesForToday;
    
    if (coursesForToday.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cursos para Hoy',
          style: GoogleFonts.oswald(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: coursesForToday.length,
            itemBuilder: (context, index) {
              return _buildTodayCourseCard(context, coursesForToday[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTodayCourseCard(BuildContext context, Course course) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.name,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                course.platform,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              if (course.startTime != null) ...[
                const SizedBox(height: 4),
                Text(
                  '🕐 ${course.startTime}',
                  style: GoogleFonts.roboto(fontSize: 12, color: Colors.white70),
                ),
              ],
              if (course.durationMinutes != null) ...[
                const SizedBox(height: 4),
                Text(
                  '⏱️ ${course.durationMinutes} min',
                  style: GoogleFonts.roboto(fontSize: 12, color: Colors.white70),
                ),
              ],
              const Spacer(),
              LinearProgressIndicator(
                value: course.progress / 100,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
              const SizedBox(height: 4),
              Text(
                '${course.progress}%',
                style: GoogleFonts.roboto(fontSize: 10, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewToggle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _isListView = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isListView ? Colors.purple : Colors.grey,
            ),
            child: Text('Lista', style: GoogleFonts.roboto()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _isListView = false),
            style: ElevatedButton.styleFrom(
              backgroundColor: !_isListView ? Colors.purple : Colors.grey,
            ),
            child: Text('Calendario', style: GoogleFonts.roboto()),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Todos', label: Text('Todos')),
              ButtonSegment(value: 'Activos', label: Text('Activos')),
              ButtonSegment(value: 'Pausados', label: Text('Pausados')),
            ],
            selected: {_filter},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _filter = newSelection.first;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListView(BuildContext context, CourseProvider provider) {
    final filteredCourses = _getFilteredCourses(provider);

    if (filteredCourses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'No hay cursos ${_filter == 'Todos' ? '' : _filter.toLowerCase()}.',
            style: GoogleFonts.roboto(fontSize: 18, color: Colors.white70),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 768
            ? 3
            : constraints.maxWidth > 640
                ? 2
                : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: filteredCourses.length,
          itemBuilder: (context, index) {
            return _buildCourseCard(context, filteredCourses[index], provider);
          },
        );
      },
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course, CourseProvider provider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    course.name,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!course.isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Pausado',
                      style: GoogleFonts.roboto(fontSize: 10, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              course.platform,
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: course.progress / 100,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
            const SizedBox(height: 4),
            Text(
              '${course.progress}%',
              style: GoogleFonts.roboto(fontSize: 10, color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 4,
              children: [
                for (int i = 0; i < 7; i++)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: course.studyDays.contains(i)
                          ? Colors.purple
                          : Colors.white24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        Course.getDayName(i),
                        style: GoogleFonts.roboto(
                          fontSize: 10,
                          color: course.studyDays.contains(i)
                              ? Colors.white
                              : Colors.white54,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (course.startTime != null || course.durationMinutes != null) ...[
              const SizedBox(height: 8),
              if (course.startTime != null)
                Text(
                  '🕐 ${course.startTime}',
                  style: GoogleFonts.roboto(fontSize: 11, color: Colors.white70),
                ),
              if (course.durationMinutes != null)
                Text(
                  '⏱️ ${course.durationMinutes} min',
                  style: GoogleFonts.roboto(fontSize: 11, color: Colors.white70),
                ),
            ],
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    course.isActive ? Icons.pause : Icons.play_arrow,
                    size: 20,
                  ),
                  onPressed: () async {
                    await provider.toggleActive(course);
                  },
                  tooltip: course.isActive ? 'Pausar' : 'Activar',
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showCourseForm(context, course: course),
                  tooltip: 'Editar',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Eliminar Curso', style: GoogleFonts.oswald()),
                        content: Text(
                          '¿Estás seguro de eliminar este curso?',
                          style: GoogleFonts.roboto(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Cancelar', style: GoogleFonts.roboto()),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: Text('Eliminar', style: GoogleFonts.roboto()),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await provider.deleteCourse(course);
                    }
                  },
                  tooltip: 'Eliminar',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarView(BuildContext context, CourseProvider provider) {
    final now = DateTime.now();
    final today = now.weekday % 7; // 0=Domingo, 1=Lunes, etc.

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '💡 Tip TDAH',
                  style: GoogleFonts.oswald(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Usa la técnica Pomodoro: estudia 25 minutos, descansa 5 minutos. Esto ayuda a mantener el enfoque.',
                  style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.6,
          ),
          itemCount: 7,
          itemBuilder: (context, index) {
            final isToday = index == today;
            final dayName = Course.getDayFullName(index);
            final coursesForDay = provider.getCoursesForDay(index);

            return Card(
              elevation: isToday ? 4 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: isToday
                    ? const BorderSide(color: Colors.purple, width: 2)
                    : BorderSide.none,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isToday ? Colors.purple.withOpacity(0.2) : null,
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayName,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        color: isToday ? Colors.purple : Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: coursesForDay.isEmpty
                          ? Center(
                              child: Text(
                                'Sin cursos',
                                style: GoogleFonts.roboto(
                                  fontSize: 10,
                                  color: Colors.white38,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: coursesForDay.length,
                              itemBuilder: (context, i) {
                                final course = coursesForDay[i];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.name,
                                        style: GoogleFonts.roboto(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        course.platform,
                                        style: GoogleFonts.roboto(
                                          fontSize: 8,
                                          color: Colors.white70,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (course.startTime != null)
                                        Text(
                                          course.startTime!,
                                          style: GoogleFonts.roboto(
                                            fontSize: 8,
                                            color: Colors.white70,
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

