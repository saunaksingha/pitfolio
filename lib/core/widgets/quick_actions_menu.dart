import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

enum QuickAction {
  updateOdometer,
  addFuel,
  addReminder,
  addExpense,
  addMaintenance,
  uploadDocument,
  addNote,
}

class QuickActionsMenu extends StatefulWidget {
  const QuickActionsMenu({super.key, required this.onActionSelected});

  final ValueChanged<QuickAction> onActionSelected;

  @override
  State<QuickActionsMenu> createState() => _QuickActionsMenuState();
}

class _QuickActionsMenuState extends State<QuickActionsMenu>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  late final AnimationController _menuController;

  static const List<_QuickActionItem> _actions = [
    _QuickActionItem(
      action: QuickAction.updateOdometer,
      label: 'Update odometer',
      icon: Icons.speed_outlined,
    ),
    _QuickActionItem(
      action: QuickAction.addFuel,
      label: 'Add fuel entry',
      icon: Icons.local_gas_station_outlined,
    ),
    _QuickActionItem(
      action: QuickAction.addReminder,
      label: 'Add reminder',
      icon: Icons.notifications_none_outlined,
    ),
    _QuickActionItem(
      action: QuickAction.addExpense,
      label: 'Add expense',
      icon: Icons.receipt_long_outlined,
    ),
    _QuickActionItem(
      action: QuickAction.addMaintenance,
      label: 'Add maintenance',
      icon: Icons.build_outlined,
    ),
    _QuickActionItem(
      action: QuickAction.uploadDocument,
      label: 'Upload document',
      icon: Icons.description_outlined,
    ),
    _QuickActionItem(
      action: QuickAction.addNote,
      label: 'Add note',
      icon: Icons.edit_note_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _menuController.forward();
    } else {
      _menuController.reverse();
    }
  }

  void _selectAction(QuickAction action) {
    _menuController.reverse();

    setState(() {
      _isExpanded = false;
    });

    widget.onActionSelected(action);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Dim the dashboard when the menu is expanded.
          IgnorePointer(
            ignoring: !_isExpanded,
            child: AnimatedOpacity(
              opacity: _isExpanded ? 0.38 : 0,
              duration: const Duration(milliseconds: 200),
              child: GestureDetector(
                onTap: _toggleMenu,
                child: Container(color: const Color(0xFF20232B)),
              ),
            ),
          ),

          // Staggered upward quick-action animation.
          Positioned(
            right: AppDimensions.pageHorizontalPadding.w,
            bottom: 80.h,
            child: IgnorePointer(
              ignoring: !_isExpanded,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (int index = 0; index < _actions.length; index++) ...[
                    _buildAnimatedAction(index),
                    SizedBox(height: AppDimensions.space8.h),
                  ],
                ],
              ),
            ),
          ),

          // Floating orange toggle button.
          Positioned(
            right: AppDimensions.pageHorizontalPadding.w,
            bottom: AppDimensions.space16.h,
            child: Material(
              color: AppColors.primary,
              elevation: 4,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: _toggleMenu,
                customBorder: const CircleBorder(),
                child: SizedBox(
                  width: 52.w,
                  height: 52.w,
                  child: AnimatedRotation(
                    turns: _isExpanded ? 0.125 : 0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    child: Icon(
                      _isExpanded ? Icons.close : Icons.add,
                      color: Colors.white,
                      size: 29.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedAction(int index) {
    // Reverse the stagger order so the action nearest the + button
    // appears first, followed by the actions above it.
    final int staggerIndex = _actions.length - 1 - index;

    final double start = staggerIndex * 0.07;
    final double end = (start + 0.45).clamp(0.0, 1.0);

    final animation = CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        start.clamp(0.0, 0.99),
        end > start ? end : 1.0,
        curve: Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final value = animation.value;

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 36.h * (1 - value)),
            child: Transform.scale(
              scale: 0.88 + (0.12 * value),
              alignment: Alignment.bottomCenter,
              child: child,
            ),
          ),
        );
      },
      child: _QuickActionRow(
        item: _actions[index],
        onTap: () => _selectAction(_actions[index].action),
      ),
    );
  }
}

class _QuickActionRow extends StatelessWidget {
  const _QuickActionRow({required this.item, required this.onTap});

  final _QuickActionItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          elevation: 2,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.space12.w,
                vertical: AppDimensions.space8.h,
              ),
              child: Text(
                item.label,
                style: AppTextStyles.body.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppDimensions.space12.w),
        Material(
          color: AppColors.surface,
          shape: const CircleBorder(),
          elevation: 2,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 40.w,
              height: 40.w,
              child: Icon(item.icon, color: AppColors.primary, size: 21.sp),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActionItem {
  const _QuickActionItem({
    required this.action,
    required this.label,
    required this.icon,
  });

  final QuickAction action;
  final String label;
  final IconData icon;
}
