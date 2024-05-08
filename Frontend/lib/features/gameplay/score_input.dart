import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:backend/src/dart_game_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScoreInput extends StatefulWidget {
  final String matchId;
  final String currentLegId;
  final String currentSetId;
  final String currentPlayerId;

  const ScoreInput({
    super.key,
    required this.matchId,
    required this.currentLegId,
    required this.currentSetId,
    required this.currentPlayerId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ScoreInputState createState() => _ScoreInputState();
}

class _ScoreInputState extends State<ScoreInput> {
  final TextEditingController _controller = TextEditingController();
  late final DartGameService gameService;

  @override
  void initState() {
    super.initState();
    gameService = DartGameService(Supabase.instance.client);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: _removeLastInput,
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
                onSubmitted: (score) => _submitScore(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: _submitScore,
            ),
          ],
        ),
        _buildNumPad(),
      ],
    );
  }

  Widget _buildNumPad() {
    final labels = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'T', '0', 'D'];
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2,
      ),
      itemCount: labels.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return ScoreButton(
          label: labels[index],
          onTap: () => _handleNumPadInput(labels[index]),
          backgroundColor: const Color(0xFFCD0612),
        );
      },
    );
  }

  void _handleNumPadInput(String input) {
    setState(() {
      _controller.text += input;
    });
  }

  void _removeLastInput() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _controller.text = _controller.text.substring(0, _controller.text.length - 1);
      }
    });
  }

  void _submitScore() async {
    String scoreInput = _controller.text.trim();
    if (scoreInput.isNotEmpty && _isNumeric(scoreInput)) {
      try {
        await gameService.enterScore(
          legId: widget.currentLegId,
          playerId: widget.currentPlayerId,
          scoreInput: scoreInput,
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Score entered successfully')),
        );
        _controller.clear();
      } on DartGameException catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid score')),
      );
    }
  }

  bool _isNumeric(String str) {
    return double.tryParse(str) != null;
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
