import 'dart:io';

import 'package:flutter/material.dart';

final bool isMobile = Platform.isAndroid || Platform.isIOS;

const Shadow textShadow = Shadow(
  offset: Offset(1, 2),
  blurRadius: 4.8,
  color: Color(0x8C000000),
);
