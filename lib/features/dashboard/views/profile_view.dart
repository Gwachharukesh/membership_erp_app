import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mart_erp/common/constants/shared_constant.dart';
import 'package:mart_erp/config/routes/routes.dart';
import 'package:mart_erp/config/theme/app_colors.dart';
import 'package:mart_erp/config/theme/view_model/theme_notifier.dart';
import 'package:mart_erp/features/customer/models/user_detail_model.dart';
import 'package:mart_erp/features/customer/service/user_detail_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  UserDetailModel? _user;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userIdStr = prefs.getString(SharedConstant.userId);
      final userId = int.tryParse(userIdStr ?? '') ?? 0;

      final response = await UserDetailService.getUserDetail(userId: userId);

      if (!mounted) return;

      if (response.isSuccess == true && response.userData is UserDetailModel) {
        setState(() {
          _user = response.userData as UserDetailModel;
          _loading = false;
        });
      } else {
        setState(() {
          _error = response.responseMSG ?? 'Failed to load profile';
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Something went wrong';
        _loading = false;
      });
    }
  }

  Future<void> _performLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Logout')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedConstant.accessToken);
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteHelper.signinView,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final gapColor = isDark ? colors.surfaceContainerHighest : const Color(0xFFF1F1F1);
    final cardBg = isDark ? colors.surface : Colors.white;

    if (_loading) return _ProfileShimmer(isDark: isDark, cardBg: cardBg, gapColor: gapColor);

    if (_error != null) {
      return _ErrorState(error: _error!, onRetry: _fetchUser);
    }

    final user = _user!;

    return RefreshIndicator(
      onRefresh: _fetchUser,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ── Profile Header ──
          SliverToBoxAdapter(
            child: Container(
              color: cardBg,
              child: _ProfileHeader(user: user, theme: theme),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 8, child: ColoredBox(color: gapColor))),

          // ── Quick Actions ──
          SliverToBoxAdapter(
            child: Container(
              color: cardBg,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  _QuickAction(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Orders',
                    color: colors.primary,
                    onTap: () {},
                  ),
                  _QuickAction(
                    icon: Icons.card_giftcard_outlined,
                    label: 'Rewards',
                    color: AppColors.reward,
                    onTap: () => Navigator.pushNamed(context, RouteHelper.rewardsHub),
                  ),
                  _QuickAction(
                    icon: Icons.favorite_border_rounded,
                    label: 'Wishlist',
                    color: AppColors.errorColor,
                    onTap: () {},
                  ),
                  _QuickAction(
                    icon: Icons.headset_mic_outlined,
                    label: 'Support',
                    color: AppColors.successColor,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 8, child: ColoredBox(color: gapColor))),

          // ── Account Info Card ──
          SliverToBoxAdapter(
            child: Container(
              color: cardBg,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Information',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  _InfoTile(icon: Icons.person_outline_rounded, label: 'Name', value: user.name),
                  _InfoTile(icon: Icons.alternate_email_rounded, label: 'Username', value: user.userName),
                  _InfoTile(icon: Icons.email_outlined, label: 'Email', value: user.emailId),
                  _InfoTile(icon: Icons.phone_outlined, label: 'Mobile', value: user.mobileNo),
                  _InfoTile(icon: Icons.location_on_outlined, label: 'Address', value: user.address),
                  _InfoTile(icon: Icons.badge_outlined, label: 'Designation', value: user.designation),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 8, child: ColoredBox(color: gapColor))),

          // ── Company Info Card ──
          if (user.companyName != null || user.companyAddress != null || user.branch != null) ...[
            SliverToBoxAdapter(
              child: Container(
                color: cardBg,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company Details',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    _InfoTile(icon: Icons.business_rounded, label: 'Company', value: user.companyName),
                    _InfoTile(icon: Icons.location_city_rounded, label: 'Company Address', value: user.companyAddress),
                    _InfoTile(icon: Icons.store_outlined, label: 'Branch', value: user.branch),
                    _InfoTile(icon: Icons.groups_outlined, label: 'Group', value: user.groupName),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 8, child: ColoredBox(color: gapColor))),
          ],

          // ── Settings Section ──
          SliverToBoxAdapter(
            child: Container(
              color: cardBg,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    label: 'Dark Mode',
                    trailing: ValueListenableBuilder<ThemeMode>(
                      valueListenable: ThemeNotifier.themeNotifier,
                      builder: (_, mode, __) => Switch(
                        value: mode == ThemeMode.dark,
                        onChanged: (_) => ThemeNotifier.toggleTheme(),
                      ),
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    label: 'Change Password',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.language_rounded,
                    label: 'Language',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.description_outlined,
                    label: 'Privacy Policy',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    label: 'About',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 8, child: ColoredBox(color: gapColor))),

          // ── Logout ──
          SliverToBoxAdapter(
            child: Container(
              color: cardBg,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _performLogout,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded, size: 22, color: colors.error),
                        const SizedBox(width: 16),
                        Text(
                          'Logout',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              color: gapColor,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'App Version 1.0.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Profile Header ──────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user, required this.theme});

  final UserDetailModel user;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.primary.withValues(alpha: 0.3), width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.1),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: (user.photoPath != null && user.photoPath!.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: user.photoPath!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => _avatarFallback(colors),
                      errorWidget: (_, __, ___) => _avatarFallback(colors),
                    )
                  : _avatarFallback(colors),
            ),
          ),
          const SizedBox(width: 18),
          // Name + details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? user.userName ?? 'User',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (user.emailId != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    user.emailId!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (user.designation != null || user.groupName != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.designation ?? user.groupName ?? '',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Edit button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit_outlined, size: 18, color: colors.primary),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback(ColorScheme colors) {
    final initials = _getInitials();
    return Container(
      color: colors.primary.withValues(alpha: 0.1),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: colors.primary,
        ),
      ),
    );
  }

  String _getInitials() {
    final name = user.name ?? user.userName ?? 'U';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : 'U';
  }
}

// ─── Quick Action ────────────────────────────────────────────────────────────

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Info Tile ───────────────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    this.value,
  });

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: colors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colors.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Settings Tile ───────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 22, color: colors.onSurface.withValues(alpha: 0.7)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: colors.outline.withValues(alpha: 0.5),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Error State ─────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.cloud_off_rounded, size: 40, color: colors.error),
            ),
            const SizedBox(height: 20),
            Text(
              'Failed to load profile',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 140,
              height: 44,
              child: FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Loading Shimmer ─────────────────────────────────────────────────────────

class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer({
    required this.isDark,
    required this.cardBg,
    required this.gapColor,
  });

  final bool isDark;
  final Color cardBg;
  final Color gapColor;

  @override
  Widget build(BuildContext context) {
    final base = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final highlight = isDark ? Colors.grey[600]! : Colors.grey[50]!;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header shimmer
          Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Shimmer.fromColors(
              baseColor: base,
              highlightColor: highlight,
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: cardBg),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(cardBg, 160, 20),
                        const SizedBox(height: 8),
                        _box(cardBg, 200, 14),
                        const SizedBox(height: 8),
                        _box(cardBg, 80, 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8, child: ColoredBox(color: gapColor)),

          // Quick actions shimmer
          Container(
            color: cardBg,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Shimmer.fromColors(
              baseColor: base,
              highlightColor: highlight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (_) => Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _box(cardBg, 40, 10),
                  ],
                )),
              ),
            ),
          ),
          SizedBox(height: 8, child: ColoredBox(color: gapColor)),

          // Info tiles shimmer
          Container(
            color: cardBg,
            padding: const EdgeInsets.all(16),
            child: Shimmer.fromColors(
              baseColor: base,
              highlightColor: highlight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(cardBg, 150, 16),
                  const SizedBox(height: 20),
                  ...List.generate(5, (_) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _box(cardBg, 60, 10),
                              const SizedBox(height: 6),
                              _box(cardBg, double.infinity, 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _box(Color color, double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
