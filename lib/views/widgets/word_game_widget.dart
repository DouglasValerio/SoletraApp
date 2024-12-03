import 'package:flutter/material.dart';

import 'dart:math' as math;

class WordGameUI extends StatefulWidget {
  const WordGameUI({super.key});

  @override
  State<WordGameUI> createState() => _WordGameUIState();
}
class _WordGameUIState extends State<WordGameUI> {
  final _controller = TextEditingController();

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              // Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.help_outline)),
          actions: const [
            Icon(Icons.more_vert),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            const Spacer(),
            Center(
              child: TextField(
                readOnly: true,
                showCursor: true,
                controller: _controller,
                focusNode: _focusNode,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),

            const SizedBox(
              height: 36,
            ),

            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circle for the center letter
                  GestureDetector(
                    onTap: () {
                      _controller.text = '${_controller.text}X';
                    },
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.teal,
                      child: Text(
                        'X',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Surrounding letters
                  ..._buildOuterLetters([
                    'A',
                    'R',
                    'P',
                    'O',
                    'M',
                    'I',
                  ], context, (value) {
                    _controller.text = '${_controller.text}$value';
                  }),
                ],
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _controller.text = _controller.text
                          .substring(0, _controller.text.length - 1);
                    }
                  },
                  onLongPress: () {
                    _controller.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Apagar',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Confirmar', ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Iniciante',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          const Text(
                            '0',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: 0.2,
                              backgroundColor: Colors.grey.shade300,
                              color: Colors.teal,
                            ),
                          ),
                          
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Palavras já encontradas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.1,
                  child: GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .5,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: 9, // Adjust according to your word count
                    itemBuilder: (context, index) {
                      return Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${(index % 3) + 4} letras',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 16),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
          
        ),
        drawer: Placeholder(),
      ),
    );
  }

  // Helper method to build surrounding letters
  List<Widget> _buildOuterLetters(
      List<String> letters, BuildContext context, Function(String) onTap) {
    const double radius = 75;
    final double angleIncrement = (2 * math.pi) / letters.length;
    const double avatarRadius = 28;
    return List.generate(letters.length, (index) {
      final angle = angleIncrement * index;
      final double dx = radius * math.cos(angle);
      final double dy = radius * math.sin(angle);

      return Positioned(
        left: ((MediaQuery.sizeOf(context).width * 0.5) - avatarRadius) + dx,
        top: ((MediaQuery.sizeOf(context).height * 0.1) - avatarRadius) + dy,
        child: GestureDetector(
          onTap: () {
            onTap(letters[index]);
          },
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundColor: const Color(0xFFE4E7EC),
            child: Text(
              letters[index],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    });
  }
}
