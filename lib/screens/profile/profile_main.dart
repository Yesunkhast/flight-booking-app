import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/widgets/settings/setting_list.dart';
import 'package:flight_app/widgets/profile/profile_banner_header.dart';

class ProfileMain extends StatefulWidget {
  const ProfileMain({super.key});

  @override
  State<ProfileMain> createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: ProfileBannerHeader(
            minExtent: topPadding + 130,
            maxExtent: topPadding + 300,
          ),
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints(maxWidth: ThemeSize.sm),
              child: SettingList()
            )
          ),
        ),
        SliverPadding(padding: EdgeInsets.only(bottom: spacingUnit(10)))
      ],
    );
  }
}