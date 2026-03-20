import 'package:flutter/material.dart';
import 'package:mart_erp/common/constants/shared_constant.dart';
import 'package:mart_erp/common/widgets/custom_profile.dart';
import 'package:mart_erp/config/routes/routes.dart';
import 'package:mart_erp/config/theme/app_colors.dart';
import 'package:mart_erp/features/notification/views/notification_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Flipkart-inspired elegant drawer menu.
class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({
    super.key,
    required this.theme,
    required this.onNavigate,
  });

  final ThemeData theme;
  final void Function(int index) onNavigate;

  static Future<void> _performLogout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(SharedConstant.accessToken);
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteHelper.signinView,
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DrawerHeader(theme: theme),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _SectionLabel(theme: theme, label: 'SHOPPING'),
                  _DrawerTile(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(0);
                    },
                    theme: theme,
                  ),
                  _DrawerTile(
                    icon: Icons.category_outlined,
                    label: 'Categories',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RouteHelper.categories);
                    },
                    theme: theme,
                  ),
                  _DrawerTile(
                    icon: Icons.shopping_bag_outlined,
                    label: 'My Orders',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(1);
                    },
                    theme: theme,
                  ),
                  _DrawerTile(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, NotificationView.routeName);
                    },
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  _SectionLabel(theme: theme, label: 'REWARDS'),
                  _DrawerTile(
                    icon: Icons.card_giftcard_outlined,
                    label: 'Rewards & Points',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RouteHelper.rewardsHub);
                    },
                    theme: theme,
                  ),
                  _DrawerTile(
                    icon: Icons.leaderboard_outlined,
                    label: 'Leaderboard',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RouteHelper.leaderboard);
                    },
                    theme: theme,
                  ),
                  _DrawerTile(
                    icon: Icons.workspace_premium_outlined,
                    label: 'Tier Status',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RouteHelper.tierStatus);
                    },
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  _SectionLabel(theme: theme, label: 'ACCOUNT'),
                  _DrawerTile(
                    icon: Icons.person_outline_rounded,
                    label: 'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(2);
                    },
                    theme: theme,
                  ),
                  _DrawerTile(
                    icon: Icons.logout_rounded,
                    label: 'Logout',
                    onTap: () {
                      Navigator.pop(context);
                      DashboardDrawer._performLogout(context);
                    },
                    theme: theme,
                    isLogout: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.theme, required this.label});

  final ThemeData theme;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 12, bottom: 4),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _DrawerHeader extends StatefulWidget {
  const _DrawerHeader({required this.theme});

  final ThemeData theme;

  @override
  State<_DrawerHeader> createState() => _DrawerHeaderState();
}

class _DrawerHeaderState extends State<_DrawerHeader> {
  String _userName = '';
  String _userImage = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString(SharedConstant.userName) ?? 'User';
      _userImage = prefs.getString(SharedConstant.userImage) ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = widget.theme.colorScheme;
    final rewardColor = AppColors.reward;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomProfileIcon(
                size: 52,
                theme: widget.theme,
                photoPath: _userImage.isNotEmpty
                    ? _userImage
                    : 'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      style: widget.theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: rewardColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Premium Member',
                        style: widget.theme.textTheme.labelSmall?.copyWith(
                          color: rewardColor,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.theme,
    this.isLogout = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ThemeData theme;
  final bool isLogout;

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: isLogout ? colorScheme.error : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isLogout ? colorScheme.error : colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colorScheme.outline.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
