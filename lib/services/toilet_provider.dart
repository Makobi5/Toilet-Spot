import '../models/toilet.dart';

class ToiletProvider {
  static List<Toilet> _toilets = [
    Toilet(
      id: '1',
      name: 'City Mall Public Toilet',
      latitude: 37.7749,
      longitude: -122.4194,
      rating: 4.5,
      isAccessible: true,
      description: 'Clean toilet with multiple stalls'
    ),
    Toilet(
      id: '2', 
      name: 'Park Restroom',
      latitude: 37.7750,
      longitude: -122.4200,
      rating: 3.0,
      isAccessible: false,
      description: 'Basic facilities, maintained regularly'
    )
  ];

  static List<Toilet> getAllToilets() => _toilets;

  static void addToilet(Toilet toilet) {
    _toilets.add(toilet);
  }

  static List<Toilet> searchToilets(String query) {
    return _toilets.where((toilet) => 
      toilet.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}