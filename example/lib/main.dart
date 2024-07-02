import 'package:flutter/material.dart';
import 'package:voice_search/voice_search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Search Examples',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ExampleSelector(),
    );
  }
}

class ExampleSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voice Search Examples')),
      body: ListView(
        children: [
          _buildExampleTile(context, 'Basic Usage', BasicUsageExample()),
          _buildExampleTile(context, 'Customized Widget', CustomizedWidgetExample()),
          _buildExampleTile(context, 'Searchable List', SearchableListExample()),
          _buildExampleTile(context, 'Combined Search', CombinedSearchExample()),
          _buildExampleTile(context, 'Multi-language', MultiLanguageExample()),
        ],
      ),
    );
  }

  Widget _buildExampleTile(BuildContext context, String title, Widget example) {
    return ListTile(
      title: Text(title),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => example),
      ),
    );
  }
}

class BasicUsageExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Basic Usage')),
      body: Center(
        child: VoiceSearchWidget(
          onResult: (String result) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You said: $result')),
            );
          },
        ),
      ),
    );
  }
}

class CustomizedWidgetExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customized Widget')),
      body: Center(
        child: VoiceSearchWidget(
          activeWidgetColor: Colors.red,
          inactiveWidgetColor: Colors.grey,
          activeIcon: Icons.mic,
          inactiveIcon: Icons.mic_none,
          elevation: 4.0,
          borderColor: Colors.black,
          animationDuration: Duration(milliseconds: 500),
          animationCurve: Curves.bounceOut,
          onResult: (String result) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You said: $result')),
            );
          },
        ),
      ),
    );
  }
}

class SearchableListExample extends StatefulWidget {
  @override
  _SearchableListExampleState createState() => _SearchableListExampleState();
}

class _SearchableListExampleState extends State<SearchableListExample> {
  List<String> allItems = ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry', 'Fig', 'Grape'];
  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = allItems;
  }

  void _filterList(String query) {
    setState(() {
      filteredItems = allItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Searchable List'),
        actions: [
          VoiceSearchWidget(
            onResult: _filterList,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(filteredItems[index]));
        },
      ),
    );
  }
}

class CombinedSearchExample extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Combined Search')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                VoiceSearchWidget(
                  onResult: (String result) {
                    _controller.text = result;
                    // Perform search with result
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Searching for: $result')),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Voice search result will appear in the text field above.'),
          ],
        ),
      ),
    );
  }
}

class MultiLanguageExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Multi-language Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Try speaking in different languages:'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLanguageWidget(context, 'en_US', 'English'),
                _buildLanguageWidget(context, 'es_ES', 'Español'),
                _buildLanguageWidget(context, 'fr_FR', 'Français'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageWidget(BuildContext context, String localeCode, String language) {
    return Column(
      children: [
        Text(language),
        SizedBox(height: 10),
        VoiceSearchWidget(
          localeCode: localeCode,
          onResult: (String result) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$language result: $result')),
            );
          },
        ),
      ],
    );
  }
}