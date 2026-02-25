import 'package:flight_app/models/company.dart';
import 'package:flight_app/models/user.dart';
import 'package:flight_app/constants/img_api.dart';

User userDummy = User(
  id: '1',
  name: 'John Doe',
  title: 'Mr',
  avatar: ImgApi.avatar[10],
  idCard: '0123456789',
  dateOfBirth: 'Jan 12, 1994',
  phone: '+628940391122',
  email: 'john_doe@mail.com',
  country: 'Mexico',
);

// Content
class ContentApi {
  static const title = 'Lorem ipsum';
  static const subtitle = 'Ut a lorem eu odio cursus laoreet.';
  static const sentences = 'Donec lacus sem, scelerisque sed ligula nec, iaculis porttitor mauris.';
  static const paragraph = 'Sed rutrum augue libero, id faucibus quam aliquet sed. Phasellus interdum orci quam, volutpat ornare eros rhoncus sed. Donec vestibulum leo a auctor convallis. In dignissim consectetur molestie. Vivamus interdum tempor dui, nec posuere augue consequat sit amet. Suspendisse quis semper quam. Nullam nec neque sem.';
  static const date = '19 Sep 2024';
}

// Project
Company branding = Company(
  id: '1',
  name: 'Flight App',
  logo: '',
  title: 'Find the best deals on flights',
  desc: 'Your journey begins here. Book flights, plan trips, and explore like never before',
  version: '1.0',
  prefix: 'bmf',
  footerText: 'Find the best deals on flights',
  year: 2025,
  logoText: 'Flight App',
  url: 'bookmyflight.indisains.com'
);
