import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({super.key, this.controller, this.onSearch});

  final TextEditingController? controller;
  final void Function()? onSearch;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  Widget? _getSearchButton() {
    ThemeData theme = Theme.of(context);

    return IconButton.filled(
      onPressed: widget.onSearch,
      icon: const Icon(
        Icons.search,
      ),
      style: const ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onSubmitted: (val) => widget.onSearch?.call(),
      decoration: InputDecoration(
        hintText: 'Café op de hoek',
        suffixIcon: _getSearchButton(),
      ),
    );
  }
}
