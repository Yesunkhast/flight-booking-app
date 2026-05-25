import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/title/title_basic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class TicketSettingsPopup extends StatelessWidget {
  const TicketSettingsPopup({
    super.key,
    this.whiteIcon = false,
    this.onDownload,
    this.onShare,
  });

  final bool whiteIcon;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz,
          size: 32,
          color:
              whiteIcon ? Colors.white : colorScheme(context).onSurfaceVariant),
      elevation: 5,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.5)),
      ),
      onSelected: (value) {
        switch (value) {
          case 'share':
            onShare?.call();
            break;
          case 'download':
            onDownload?.call();
            break;
          case 'print':
            break;
          case 'support':
            break;
          case 'reschedule':
            break;
          case 'refund':
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'share',
          child: ListTile(
            leading: Transform.flip(
                flipX: true,
                child: Icon(Icons.reply, color: colorScheme(context).primary)),
            title: const Text('Share'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'download',
          child: ListTile(
            leading: Icon(Icons.download, color: colorScheme(context).primary),
            title: const Text('Download'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'print',
          child: ListTile(
            leading: Icon(Icons.print, color: colorScheme(context).primary),
            title: const Text('Print'),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'support',
          child: ListTile(
            leading: Icon(CupertinoIcons.question_circle,
                color: colorScheme(context).primary),
            title: const Text('Ask for supports'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'reschedule',
          child: ListTile(
            leading:
                Icon(CupertinoIcons.time, color: colorScheme(context).primary),
            title: const Text('Reschedule'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'refund',
          child: ListTile(
            leading: Icon(CupertinoIcons.arrow_uturn_left,
                color: colorScheme(context).primary),
            title: const Text('Request for refund'),
          ),
        ),
      ],
    );
  }
}
