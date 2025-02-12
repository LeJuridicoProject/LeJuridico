import 'package:flutter/material.dart';

class ProcessScreen extends StatefulWidget {
  @override
  _ProcessScreenState createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  bool _showRecommendations = false;

  void _searchProcess() {
    setState(() {
      _showRecommendations = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Por favor, informe o número do processo"),
            SizedBox(height: 15),
            Container(
              width: 400,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Digite o número do processo",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.black),
                    onPressed: _searchProcess,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Exibir recomendações após pesquisa
            if (_showRecommendations) ...[
              Text(
                "Recomendamos 3 modelos que acreditamos que se encaixam com sua petição inicial:",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              _buildRecommendationButton("Petição inicial"),
              _buildRecommendationButton("Petição inicial"),
              _buildRecommendationButton("Petição inicial"),
              SizedBox(height: 10),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.black),
                onPressed: _searchProcess,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationButton(String title) {
    return Container(
      width: 300,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(title),
      ),
    );
  }
}
