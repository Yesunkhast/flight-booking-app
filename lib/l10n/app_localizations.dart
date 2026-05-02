import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_mn.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('mn')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'eChina.mn'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @bookFlight.
  ///
  /// In en, this message translates to:
  /// **'Book Flight'**
  String get bookFlight;

  /// No description provided for @domesticFlight.
  ///
  /// In en, this message translates to:
  /// **'China Domestic Flight'**
  String get domesticFlight;

  /// No description provided for @internationalFlight.
  ///
  /// In en, this message translates to:
  /// **'International Flight'**
  String get internationalFlight;

  /// No description provided for @searchFlight.
  ///
  /// In en, this message translates to:
  /// **'Search Flight'**
  String get searchFlight;

  /// No description provided for @oneWay.
  ///
  /// In en, this message translates to:
  /// **'One-way'**
  String get oneWay;

  /// No description provided for @roundTrip.
  ///
  /// In en, this message translates to:
  /// **'Round-trip'**
  String get roundTrip;

  /// No description provided for @flyingFrom.
  ///
  /// In en, this message translates to:
  /// **'Flying From'**
  String get flyingFrom;

  /// No description provided for @flyingTo.
  ///
  /// In en, this message translates to:
  /// **'Flying To'**
  String get flyingTo;

  /// No description provided for @departureDate.
  ///
  /// In en, this message translates to:
  /// **'Departure Date'**
  String get departureDate;

  /// No description provided for @returnDate.
  ///
  /// In en, this message translates to:
  /// **'Return Date'**
  String get returnDate;

  /// No description provided for @adult.
  ///
  /// In en, this message translates to:
  /// **'adult'**
  String get adult;

  /// No description provided for @child.
  ///
  /// In en, this message translates to:
  /// **'child'**
  String get child;

  /// No description provided for @infant.
  ///
  /// In en, this message translates to:
  /// **'infant'**
  String get infant;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get orders;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @passenger.
  ///
  /// In en, this message translates to:
  /// **'Passenger'**
  String get passenger;

  /// No description provided for @yourPoint.
  ///
  /// In en, this message translates to:
  /// **'Your Point'**
  String get yourPoint;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help and Support'**
  String get helpAndSupport;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welome to'**
  String get welcomeTo;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have account'**
  String get alreadyHaveAccount;

  /// No description provided for @infantAge.
  ///
  /// In en, this message translates to:
  /// **'Below Age 2'**
  String get infantAge;

  /// No description provided for @childrenAge.
  ///
  /// In en, this message translates to:
  /// **'Age 2-11'**
  String get childrenAge;

  /// No description provided for @adultAge.
  ///
  /// In en, this message translates to:
  /// **'Age 12 and over'**
  String get adultAge;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'user name'**
  String get userName;

  /// No description provided for @emailOrPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone Number'**
  String get emailOrPhoneNumber;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @repeatPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat Password'**
  String get repeatPassword;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @agreewithOurTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Agree with our terms and condtions'**
  String get agreewithOurTermsAndConditions;

  /// No description provided for @pleaseFillYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseFillYourName;

  /// No description provided for @incorrectEmailOrPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or phone number'**
  String get incorrectEmailOrPhoneNumber;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordDoesNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordDoesNotMatch;

  /// No description provided for @passwordNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordNotMatch;

  /// No description provided for @acceptTermsError.
  ///
  /// In en, this message translates to:
  /// **'You must accept the terms and conditions to continue'**
  String get acceptTermsError;

  /// No description provided for @checkYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Check your phone'**
  String get checkYourPhone;

  /// No description provided for @weHaveSentCode.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a code to your phone'**
  String get weHaveSentCode;

  /// No description provided for @pinIncorrect.
  ///
  /// In en, this message translates to:
  /// **'The PIN is incorrect'**
  String get pinIncorrect;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @sendAgain.
  ///
  /// In en, this message translates to:
  /// **'Send again'**
  String get sendAgain;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get pleaseWait;

  /// No description provided for @toSendAgain.
  ///
  /// In en, this message translates to:
  /// **'to send again'**
  String get toSendAgain;

  /// No description provided for @helpAndSup.
  ///
  /// In en, this message translates to:
  /// **'Help and support'**
  String get helpAndSup;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @availableSeats.
  ///
  /// In en, this message translates to:
  /// **'Available seats'**
  String get availableSeats;

  /// No description provided for @whereToGo.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to go?'**
  String get whereToGo;

  /// No description provided for @flightDetail.
  ///
  /// In en, this message translates to:
  /// **'Flight Detail'**
  String get flightDetail;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get notFound;

  /// No description provided for @searchAnotherDestination.
  ///
  /// In en, this message translates to:
  /// **'Search Another Destination'**
  String get searchAnotherDestination;

  /// No description provided for @flightWarning.
  ///
  /// In en, this message translates to:
  /// **'(Note: If the first flight schedule changes, it will not affect the second flight)'**
  String get flightWarning;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @inTheCity.
  ///
  /// In en, this message translates to:
  /// **'city'**
  String get inTheCity;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get min;

  /// No description provided for @wait.
  ///
  /// In en, this message translates to:
  /// **'wait'**
  String get wait;

  /// No description provided for @searchHistory.
  ///
  /// In en, this message translates to:
  /// **'Search History'**
  String get searchHistory;

  /// No description provided for @trendingSearch.
  ///
  /// In en, this message translates to:
  /// **'Trending Search'**
  String get trendingSearch;

  /// No description provided for @chinaPopularCities.
  ///
  /// In en, this message translates to:
  /// **'China\'s Popular Cities'**
  String get chinaPopularCities;

  /// No description provided for @selectedFlight.
  ///
  /// In en, this message translates to:
  /// **'Selected flight'**
  String get selectedFlight;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departure;

  /// No description provided for @returnword.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnword;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

  /// No description provided for @directFlight.
  ///
  /// In en, this message translates to:
  /// **'Direct flight'**
  String get directFlight;

  /// No description provided for @indirectFlight.
  ///
  /// In en, this message translates to:
  /// **'Indirect flight'**
  String get indirectFlight;

  /// No description provided for @proposal.
  ///
  /// In en, this message translates to:
  /// **'Proposal'**
  String get proposal;

  /// No description provided for @cheapest.
  ///
  /// In en, this message translates to:
  /// **'cheapest'**
  String get cheapest;

  /// No description provided for @flightIsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Flight is not available for booking'**
  String get flightIsNotAvailable;

  /// No description provided for @refund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get refund;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @changeDate.
  ///
  /// In en, this message translates to:
  /// **'Change date'**
  String get changeDate;

  /// No description provided for @seat.
  ///
  /// In en, this message translates to:
  /// **'Seat'**
  String get seat;

  /// No description provided for @manySeats.
  ///
  /// In en, this message translates to:
  /// **'Multiple seats available'**
  String get manySeats;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @withFee.
  ///
  /// In en, this message translates to:
  /// **'With fee'**
  String get withFee;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInfo;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @changeProfile.
  ///
  /// In en, this message translates to:
  /// **'Change Profile'**
  String get changeProfile;

  /// No description provided for @choosePassenger.
  ///
  /// In en, this message translates to:
  /// **'Choose Passenger'**
  String get choosePassenger;

  /// No description provided for @contactDetail.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactDetail;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @sameAsContactDetails.
  ///
  /// In en, this message translates to:
  /// **'Same as contact details'**
  String get sameAsContactDetails;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @passengerInfo.
  ///
  /// In en, this message translates to:
  /// **'Passenger Information'**
  String get passengerInfo;

  /// No description provided for @idNumber.
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get idNumber;

  /// No description provided for @newPassenger.
  ///
  /// In en, this message translates to:
  /// **'New Passenger'**
  String get newPassenger;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @passengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get passengers;

  /// No description provided for @facilities.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilities;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @addNewPassengger.
  ///
  /// In en, this message translates to:
  /// **'Add New Passengger'**
  String get addNewPassengger;

  /// No description provided for @passportID.
  ///
  /// In en, this message translates to:
  /// **'Passport number'**
  String get passportID;

  /// No description provided for @passportValidDate.
  ///
  /// In en, this message translates to:
  /// **'Passport Valid Date'**
  String get passportValidDate;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @chooseGender.
  ///
  /// In en, this message translates to:
  /// **'Choose Gender'**
  String get chooseGender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @enterThePassengerCorrectInfo.
  ///
  /// In en, this message translates to:
  /// **'Please enter accurate passenger information!'**
  String get enterThePassengerCorrectInfo;

  /// No description provided for @noPassengers.
  ///
  /// In en, this message translates to:
  /// **'No Passengers'**
  String get noPassengers;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Quest User'**
  String get guestUser;

  /// No description provided for @loginFormPrag.
  ///
  /// In en, this message translates to:
  /// **'✨ Welcome back! Please login to your account.'**
  String get loginFormPrag;

  /// No description provided for @registerFormPrag.
  ///
  /// In en, this message translates to:
  /// **'👋 Very nice to meet you! Create new account for free.'**
  String get registerFormPrag;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsTitle;

  /// No description provided for @agreeTerms.
  ///
  /// In en, this message translates to:
  /// **'AGREE TERMS & CONDITIONS'**
  String get agreeTerms;

  /// No description provided for @termsContent.
  ///
  /// In en, this message translates to:
  /// **'These Exoscale Services Terms and Conditions govern the Order(s) entered into between Client and Supplier for the provision of IaaS Cloud Computing Services. Supplier and Client are hereinafter referred to individually as a \"**Party**\" and collectively, as the \"**Parties**\".\n\nApplicable starting January 16th, 2026\n[Previous version](https://github.com/exoscale/terms/blob/master/terms-previous.markdown)\n[Compare](https://github.com/exoscale/terms/commits/master)\n\n## 1. Definitions\n\n\"**Agreement**\" means any Order and these Terms and Conditions collectively.\n\n\"**Affiliate**\" means an entity that, now or in the future, directly or indirectly Controls, is Controlled by or is under common Control with a Party. For purposes of the foregoing, \"**Control**\" shall mean the ownership of more than fifty percent (50%) of the (i) voting rights of said entity or (ii) ownership interest in said entity.\n\n## 2. The Services\n\n*Client may* submit the Order(s) via the Website (after having accepted on the Website to be bound by these Terms and Conditions) or by executing the Order and these Terms and Conditions and returning them to the Supplier by mail, fax or email. The submission of that certain Order(s) shall constitute an offer to buy the Services. Supplier may accept that offer at its sole discretion (at which time both Client and Supplier are legally bound) by way of (i) a message sent via the Website or by mail, fax or email, thereby acknowledging receipt and acceptance of the Order; or (ii) delivery of the Services.\n\n## 3. Fees and Payment Modalities\n\n### 3.1 Service Fees\n\nSupplier shall charge the Services Fees to Client as detailed in the Order(s). Supplier shall be *entitled* to increase its Service Fees upon a forty-five (45) day prior written notice to Client.\n\n### 3.2 Invoicing and Payment\n\nUnless otherwise agreed between the Parties in writing, billing for the Services shall *commence on* the Service Commencement Time. Supplier shall invoice all Service Fees in accordance with the frequency, method, payment terms and currency set out in the Order and in any case in advance except for charges that are dependent on usage which shall be billed in arrears. In the case of period billing any partial period shall be pro-rated except otherwise noted on order.\n\n### 3.3 Overdue Charges\n\nAny amount due but not received by Supplier will accrue interest from thirty (30) days after the date of invoice to the date of payment at the Interest Rate (pro-rated on a daily basis). Furthermore, Supplier shall have the right to set-off any amounts due hereunder which are not paid when due against any amounts owed to Client by Supplier pursuant to these Terms and Conditions or any other agreement between the Parties. In case any amount due is not received by Supplier within sixty (60) days after the date of invoice, the Supplier shall be entitled to stop providing the Services to the Client.\n\n## 4. Service Level Agreement (SLA)\n\n### 4.1 Service Availability Targets\n\nSupplier shall use commercially reasonable efforts to make the Services available 24 hours a day, 7 days a week, with an overall 99.95% annual availability for the virtual machine (i.e. 365 days minus 4hours20min), except for:\n\n- Planned downtime and maintenance events;\n- Force Majeure Events;\n- Unavailability of the Website;\n- Failures or malfunctions in any Client software, equipment or technology; and/or\n- If Client is in breach of these Terms and Conditions, including but not limited to its payment obligations and the use of Services.\n\n### 4.2 Incident Management Service Levels\n\nSupplier targets to respond to incidents within the maximum following time frame as of receipt of notice of incident within fifteen (15) minutes.'**
  String get termsContent;

  /// No description provided for @introCheapTitle.
  ///
  /// In en, this message translates to:
  /// **'Best Price!'**
  String get introCheapTitle;

  /// No description provided for @introCheapDesc.
  ///
  /// In en, this message translates to:
  /// **'Book domestic and international flights in China at the lowest prices.'**
  String get introCheapDesc;

  /// No description provided for @introEasyTitle.
  ///
  /// In en, this message translates to:
  /// **'Easy Booking'**
  String get introEasyTitle;

  /// No description provided for @introEasyDesc.
  ///
  /// In en, this message translates to:
  /// **'Search → Select → Pay — done in seconds.'**
  String get introEasyDesc;

  /// No description provided for @introSafeTitle.
  ///
  /// In en, this message translates to:
  /// **'Reliable Service'**
  String get introSafeTitle;

  /// No description provided for @introSafeDesc.
  ///
  /// In en, this message translates to:
  /// **'24/7 customer support, secure payments, guaranteed booking.'**
  String get introSafeDesc;

  /// No description provided for @enterPassengerInfo.
  ///
  /// In en, this message translates to:
  /// **'Please enter passenger information'**
  String get enterPassengerInfo;

  /// No description provided for @monthJan.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJan;

  /// No description provided for @monthFeb.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get monthFeb;

  /// No description provided for @monthMar.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMar;

  /// No description provided for @monthApr.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApr;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJun.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJun;

  /// No description provided for @monthJul.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJul;

  /// No description provided for @monthAug.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get monthAug;

  /// No description provided for @monthSep.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get monthSep;

  /// No description provided for @monthOct.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get monthOct;

  /// No description provided for @monthNov.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get monthNov;

  /// No description provided for @monthDec.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get monthDec;

  /// No description provided for @paymentInfo.
  ///
  /// In en, this message translates to:
  /// **'Payment Information'**
  String get paymentInfo;

  /// No description provided for @serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Echina.mn Service Fee'**
  String get serviceFee;

  /// No description provided for @nightFee.
  ///
  /// In en, this message translates to:
  /// **'Night Surcharge'**
  String get nightFee;

  /// No description provided for @bankFee.
  ///
  /// In en, this message translates to:
  /// **'Bank Transaction Fee'**
  String get bankFee;

  /// No description provided for @totalPayment.
  ///
  /// In en, this message translates to:
  /// **'Total Payment'**
  String get totalPayment;

  /// No description provided for @carryOn.
  ///
  /// In en, this message translates to:
  /// **'Carry-on Baggage'**
  String get carryOn;

  /// No description provided for @checkedBaggage.
  ///
  /// In en, this message translates to:
  /// **'Checked Baggage'**
  String get checkedBaggage;

  /// No description provided for @infantBaggage.
  ///
  /// In en, this message translates to:
  /// **'Infant Baggage'**
  String get infantBaggage;

  /// No description provided for @refundFeePerTicket.
  ///
  /// In en, this message translates to:
  /// **'Fee per ticket (Refund)'**
  String get refundFeePerTicket;

  /// No description provided for @changeFeePerTicket.
  ///
  /// In en, this message translates to:
  /// **'Fee per ticket\n(Change)'**
  String get changeFeePerTicket;

  /// No description provided for @checkInfo.
  ///
  /// In en, this message translates to:
  /// **'Check Information'**
  String get checkInfo;

  /// No description provided for @checkoutTerms.
  ///
  /// In en, this message translates to:
  /// **'## IMPORTANT NOTICE\n\nPassport information: Passengers must carefully verify their personal information. Please ensure that the passport number, surname, given name, and gender are entered correctly.\n\nPlease note that if any information is entered incorrectly or a name change is required later, the booking cannot be corrected afterward, and the passenger shall bear all risks arising from such errors.\n\nTicket confirmation: Ticket booking is processed through an automated system. Once payment has been completed and the ticket is confirmed, a notification will be sent to your registered email address and phone number. If no confirmation is received, the booking may not be confirmed and you must contact us for a refund.\n\nMissing the flight: Passengers must arrive at the airport at least 3 hours before departure in order to complete ticket verification, baggage check-in, and passport control.\n\nAny consequences resulting from missing the flight shall be the sole responsibility of the passenger.\n\nTransit flights: If you are traveling on a connecting flight, a visa may be required for the destination country or transit city. Please check in advance. Additional visa information can be obtained from the Ministry of Foreign Affairs website. Some transit journeys may require changing airports, so please contact 96961414 or 90901550 for detailed information.\n\nSchedule changes: Please note that any changes to the flight schedule will be sent to the mobile phone number and email address registered in our system.\n\nFlight cancellation and delays: Tickets must be used in the sequence stated in the travel itinerary. If the ticket sequence is changed, the ticket may be canceled and the passenger will bear any resulting risks.\n\nFlight changes: The airline operating the flight has the right to cancel or delay flights due to weather conditions or other force majeure circumstances. In such cases, ECHINA.MN shall not be held responsible for any resulting consequences.\n\nRisk notice: We do not provide travel insurance services. For your safety, we strongly recommend purchasing your own travel insurance before departure.\n\n---\n\n## GENERAL TERMS\n\n### Service terms\nThese terms constitute an agreement regulating the rights, obligations, and responsibilities between the customer and the ticket-selling company in relation to online ticket purchases.\n\n### Service ownership\nEchina.mn is the property of China Booking LLC, and these service terms govern all activities related to purchasing tickets through Echina.mn.\n\n### Validity of terms\nBy accessing Echina.mn and purchasing a ticket, the customer is considered to have fully accepted these terms and conditions.\n\n### Intellectual property\nAll content published on the website, including text, images, and logos, is protected under Mongolian and international intellectual property laws.\n\n---\n\n## Customer rights\n\n- Right to receive information\n- Right to review bookings\n- Right to change or refund tickets\n- Right to protect personal information\n- Right to receive accurate flight information\n\n---\n\n## Customer responsibilities\n\n- Provide accurate information\n- Ensure passport validity\n- Follow flight rules\n- Comply with baggage requirements\n- Arrive on time\n- Meet visa and document requirements\n- Complete payment on time\n\n---\n\n## Payment terms\n\n- Payment must be completed within 20 minutes\n- Exchange rates may change\n- Additional service fees may apply\n- We are not responsible for internet or banking interruptions\n\n---\n\n## Ticket refunds\n\n- Refund requests must be sent via Facebook page or to 90901550\n- Refunds are processed within 1–7 business days\n- Refund fees may be deducted\n\n---\n\n## Dispute resolution\n\nIn the event of a dispute, both parties shall first attempt to resolve the matter through mutual negotiation. If no agreement can be reached, the dispute shall be resolved in accordance with the laws of Mongolia.'**
  String get checkoutTerms;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @warningInvalid.
  ///
  /// In en, this message translates to:
  /// **'If incorrect, it cannot be used!!!!'**
  String get warningInvalid;

  /// No description provided for @passportInfo.
  ///
  /// In en, this message translates to:
  /// **'Based on passport information'**
  String get passportInfo;

  /// No description provided for @passportFields.
  ///
  /// In en, this message translates to:
  /// **'Letters, numbers, gender'**
  String get passportFields;

  /// No description provided for @passport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get passport;

  /// No description provided for @flightTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Flight Ticket Booking Terms and Conditions'**
  String get flightTermsTitle;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get birthDate;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay bills'**
  String get pay;

  /// No description provided for @flightNotFoundOrCheckInternet.
  ///
  /// In en, this message translates to:
  /// **'Flight not found or check internet connection'**
  String get flightNotFoundOrCheckInternet;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHome;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'mn'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'mn':
      return AppLocalizationsMn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
