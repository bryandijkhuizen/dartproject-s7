import 'package:flutter/material.dart';

class ScoreInput extends StatefulWidget {
  final Function(int) onScoreEntered;
  final Function() onLegFinished;
  final Function() onUndo;

  const ScoreInput({
    super.key,
    required this.onScoreEntered,
    required this.onLegFinished,
    required this.onUndo,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ScoreInputState createState() => _ScoreInputState();
}

class _ScoreInputState extends State<ScoreInput> {
  final TextEditingController _controller = TextEditingController();
  String scorePrefix = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF060606),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.undo, color: Colors.white),
                onPressed: widget.onUndo,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Score',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.check, color: Colors.white),
                onPressed: () {
                  final int? score = int.tryParse(_controller.text);
                  if (score != null) {
                    widget.onScoreEntered(score);
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2,
            ),
            itemCount: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final labels = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'T', '0', 'D'];
              final color = labels[index] == 'T' || labels[index] == 'D'
                  ? const Color(0xFF921B22)
                  : const Color(0xFFCD0612);

              return ScoreButton(
                label: labels[index],
                onTap: () => _quickScore(labels[index]),
                backgroundColor: labels[index] == '0' ? const Color(0xFFCD0612) : color,
              );
            },
          ),
        ],
      ),
    );
  }

  void _quickScore(String score) {
    if ('TD'.contains(score) && !scorePrefix.contains(score)) {
      scorePrefix = score;
    } else {
      final currentText = _controller.text;
      _controller.text = currentText + score;
    }
  }
}

class ScoreButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;

  const ScoreButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
