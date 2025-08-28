import 'package:flutter/material.dart';

import '../../../common/widgets/custom_profile.dart';

class PointsSummaryCard extends StatefulWidget {
  const PointsSummaryCard({
    required this.theme,
    this.includeHeading = true,
    super.key,
  });

  final ThemeData theme;
  final bool includeHeading;

  @override
  State<PointsSummaryCard> createState() => _PointsSummaryCard();
}

class _PointsSummaryCard extends State<PointsSummaryCard>
    with SingleTickerProviderStateMixin {
  final _isHide = ValueNotifier<bool>(false);
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _isHide.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},

      // => Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const PointsDetailsScreen(),
      //   ),
      // ),
      child: Container(
        // margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // color: widget.theme.primaryColor,
          color: widget.theme.cardColor,
          // gradient: LinearGradient(
          //   colors: [
          //     widget.theme.colorScheme.onInverseSurface,
          //     widget.theme.secondaryHeaderColor,
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withValues(alpha: 0.5),
          //     blurRadius: 10,
          //     offset: const Offset(0, 4),
          //   ),
          // ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Card header with customer name and points label
              if (widget.includeHeading) ...[
                Row(
                  spacing: 10,
                  children: [
                    CustomProfileIcon(
                      size: 40,
                      theme: widget.theme,
                      photoPath:
                          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?_gl=1*1my73ni*_ga*MTM4ODc2NDAzMS4xNzU1NDk1NTU4*_ga_8JE65Q40S6*czE3NTU2NzUyMTQkbzIkZzEkdDE3NTU2NzUyMjUkajQ5JGwwJGgw',
                    ),
                    Text(
                      "Rohan Shrestha",
                      style: widget.theme.textTheme.titleSmall?.copyWith(
                        // color: widget.theme.brightness != Brightness.light
                        //     ? Colors.white
                        //     : Colors.black,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       const Row(
                //         spacing: 10,
                //         children: [
                //           Icon(Icons.logo_dev, color: Colors.white),
                //           Text(
                //             'Points Card',
                //             style: TextStyle(
                //               fontSize: 18,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.white,
                //             ),
                //           ),
                //         ],
                //       ),
                //       Icon(Icons.star, color: Colors.yellow.shade600, size: 24),
                //     ],
                //   ),
                //   const SizedBox(height: 16),
              ],
              // Points balance
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Text(
                  'Total Points',
                  style: widget.theme.textTheme.titleMedium?.copyWith(
                    // color: widget.theme.brightness != Brightness.light
                    //     ? Colors.white.withValues(alpha: 0.5)
                    //     : Colors.black.withValues(alpha: 0.5),
                    color: Colors.white,
                  ),
                ),
                subtitle: ValueListenableBuilder(
                  valueListenable: _isHide,
                  builder: (context, value, child) {
                    return Text.rich(
                      TextSpan(
                        text: value ? 'XXX ' : "${0} ",
                        style: widget.theme.textTheme.titleLarge?.copyWith(
                          // color: widget.theme.brightness != Brightness.light
                          //     ? Colors.white
                          //     : Colors.black,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text: "points",
                            style: widget.theme.textTheme.bodyLarge?.copyWith(
                              // color: widget.theme.brightness != Brightness.light
                              //     ? Colors.white
                              //     : Colors.black,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                trailing: IconButton(
                  icon: ValueListenableBuilder(
                    valueListenable: _isHide,
                    builder: (context, value, child) {
                      return Icon(
                        value ? Icons.visibility : Icons.visibility_off,
                        // color: widget.theme.brightness != Brightness.light
                        //     ? Colors.white
                        //     : Colors.black,
                        color: Colors.white,
                      );
                    },
                  ),
                  onPressed: () {
                    _isHide.value = !_isHide.value;
                  },
                ),
              ),

              Divider(
                height: 1,

                // color: widget.theme.brightness != Brightness.light
                //     ? Colors.white
                //     : Colors.black,
                color: Colors.white,
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Remaining:  ',
                        style: widget.theme.textTheme.bodyMedium?.copyWith(
                          // color: widget.theme.brightness != Brightness.light
                          //     ? Colors.white.withValues(alpha: 0.5)
                          //     : Colors.black.withValues(alpha: 0.5),
                          color: Colors.white,
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _isHide,
                        builder: (context, value, child) {
                          return Text(
                            value ? 'xxx' : '${0}',
                            style: widget.theme.textTheme.titleSmall?.copyWith(
                              // color: widget.theme.brightness != Brightness.light
                              //     ? Colors.white
                              //     : Colors.black,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Redeemed:  ',
                        style: widget.theme.textTheme.bodyMedium?.copyWith(
                          // color: widget.theme.brightness != Brightness.light
                          //     ? Colors.white.withValues(alpha: 0.5)
                          //     : Colors.black.withValues(alpha: 0.5),
                          color: Colors.white,
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _isHide,
                        builder: (context, value, child) {
                          return Text(
                            value ? 'xxx' : '${0}',
                            style: widget.theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              // color: widget.theme.brightness != Brightness.light
                              //     ? Colors.white
                              //     : Colors.black,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (!mounted) return;
                      _controller.forward();
                      await Future.delayed(const Duration(seconds: 1));
                      if (!mounted) return;
                      _controller.reset();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.theme.colorScheme.surface.withValues(
                          alpha: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RotationTransition(
                        turns:
                            Tween<double>(
                                  begin: 0,
                                  end: -1,
                                ) // negative for clockwise
                                .animate(_controller),
                        child: Icon(
                          Icons.sync_outlined,
                          // color: widget.theme.brightness != Brightness.light
                          //     ? Colors.white
                          //     : Colors.black,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
