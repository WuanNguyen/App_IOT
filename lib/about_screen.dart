import 'package:flutter/material.dart';

class BenifitScreen extends StatelessWidget {
  const BenifitScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lợi ích Ứng Dụng IoT'),
      ),
      body: ListView(
        children: const [
          IntroductionItem(
            title: 'Quản Lý Thiết Bị Thông Minh',
            description:'Ứng dụng giúp bạn dễ dàng quản lý và kiểm soát các thiết bị thông minh trong nhà của bạn.',
            imagePath: 'assets/img/ql_home1.jpg',
          ),
          IntroductionItem(
            title: 'Điều Khiển Từ Xa',
            description:
                'Điều khiển các thiết bị từ xa thông qua ứng dụng, giúp bạn tiết kiệm thời gian và năng lượng.',
            imagePath: 'assets/img/ql_home.jpg',
          ),
          IntroductionItem(
            title: 'Bảo Mật Cao',
            description:
                'Chúng tôi chú trọng vào bảo mật, đảm bảo an toàn cho dữ liệu và thông tin cá nhân của bạn.',
            imagePath: 'assets/img/baomat.png',
          ),
          IntroductionItem(
            title: 'Tích Hợp Thông Minh',
            description:
                'Ứng dụng được tích hợp với nhiều thiết bị thông minh khác nhau, tạo ra một hệ sinh thái đa dạng.',
            imagePath: 'assets/img/dadang.jpg',
          ),
          
        ],
      ),
    );
  }
}

class IntroductionItem extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const IntroductionItem({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            height: 220,
           
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


