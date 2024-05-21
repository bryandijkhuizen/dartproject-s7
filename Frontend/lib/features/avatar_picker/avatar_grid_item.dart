import 'package:darts_application/models/avatar.dart';
import 'package:flutter/material.dart';

class AvatarGridItem extends StatelessWidget {
  final Avatar avatar;
  final bool selected;
  final Function(Avatar url) callback;

  const AvatarGridItem({
    super.key,
    required this.avatar,
    this.selected = false,
    required this.callback,
  });

  Widget getImage() => Image(
        image: NetworkImage(avatar.url),
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: loadingProgress.expectedTotalBytes != null
                    ? LinearProgressIndicator(
                        value: loadingProgress.expectedTotalBytes! /
                            loadingProgress.cumulativeBytesLoaded,
                      )
                    : const LinearProgressIndicator(),
              ),
            ),
          );
        },
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          return Center(child: child);
        },
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      color: Theme.of(context).colorScheme.secondary,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          callback.call(avatar);
        },
        child: Stack(
          children: [
            getImage(),
            if (selected)
              Container(
                color: Colors.black.withOpacity(0.4),
              ),
            if (selected)
              const Center(
                child: Text('Selected'),
              ),
          ],
        ),
      ),
    );
  }
}
