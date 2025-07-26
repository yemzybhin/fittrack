import 'package:fittrack/core/utils/dimensions.dart';
import 'package:fittrack/core/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibration/vibration.dart';
import '../../../../core/utils/fonts.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/custom_chart.dart';
import '../widgets/stats_cards.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fabController;

  @override
  void initState() {
    _fabController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _onRefresh();
    super.initState();
  }

  Future<void> _onRefresh() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50);
    }
    context.read<DashboardCubit>().refreshStats();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              displacement: 60,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: PaddingConstant),
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: 100,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.black,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          'Dashboard',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: CustomFonts.Montserrat_Black,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _buildContent(state),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: AnimatedIconFAB(controller: _fabController),
        );
      },
    );
  }

  Widget _buildContent(DashboardState state) {
    if (state is DashboardLoading) {
      return const Center(child: CircularProgressIndicator(
        color: Colors.white,
      ));
    } else if (state is DashboardError) {
      return Center(child: Text(state.message));
    } else if (state is DashboardLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.75,
                children: [
                  AnimatedStatCard(
                      unit: ' Steps',
                      value: state.stats.steps.toDouble(),
                      text: 'The total steps you have taken',
                      icon: CustomIcons.steps),
                  AnimatedStatCard(
                      unit: ' Calories',
                      value: state.stats.calories.toDouble(),
                      text: 'The total calories you have burnt',
                      icon: CustomIcons.calories),
                  AnimatedStatCard(
                      unit: ' km',
                      value: state.stats.distanceKm,
                      text: 'The total distance covered',
                      icon: CustomIcons.distance),
                  AnimatedStatCard(
                      unit: ' min',
                      value: state.stats.activeMinutes.toDouble(),
                      text: 'The total active minutes spent',
                      icon: CustomIcons.clock),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Weekly Progress',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          CustomChart(
            thisWeekSteps: state.stats.steps.toDouble(),
            thisWeekCalories: state.stats.calories.toDouble(),
            thisWeekDistance: state.stats.distanceKm,
          ),
          const SizedBox(height: 50)
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class AnimatedIconFAB extends StatelessWidget {
  final AnimationController controller;

  const AnimatedIconFAB({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (controller.isCompleted) {
          controller.reverse();
        } else {
          controller.forward();
        }
        HapticFeedback.lightImpact();
      },
      backgroundColor: Colors.white10,
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: controller,
      ),
    );
  }
}
