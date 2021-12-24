import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:berikan/common/constant.dart';

void main(){
  group('login test', (){
    late FlutterDriver driver;
    final keys = {
      'home_page': 'homePageLoginButton',
      'email' : 'emailTextField',
      'password' : 'passwordTextField',
      'login_page' : 'loginPageLoginButton',
      
      //keys for main_page test
      'firstCard' : 'mainCard0',
    };

    isPresent(SerializableFinder byValueKey, FlutterDriver driver, {Duration timeout = const Duration(seconds: 1)}) async {
      try {
        await driver.waitFor(byValueKey,timeout: timeout);
        return true;
      } catch(exception) {
        return false;
      }
    }


    setUpAll(() async{
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async{
     await driver.close();
    });
    
    test('Login test', () async{

      //expect homepage to load properly with our app description
      expect(await driver.getText(find.text(berikanDescription)), berikanDescription);

      await driver.tap(find.byValueKey(keys['home_page']));

      //expect we are loaded into login page with 'MASUK' text
      expect(await driver.getText(find.text('MASUK')), 'MASUK');

      //error test when there are empty fields
      await driver.tap(find.byValueKey(keys['email']));
      await driver.enterText('wrongemailadress.com');
      await driver.tap(find.byValueKey(keys['login_page']));
      driver.waitFor(find.byType('SnackBar'));
      expect(await driver.getText(find.text('Email address/Password field can\'t be empty')), 'Email address/Password field can\'t be empty');

      //error test when email address format is wrong
      await driver.tap(find.byValueKey(keys['email']));
      await driver.enterText('wrongemailformat');
      await driver.tap(find.byValueKey(keys['password']));
      await driver.enterText('dummyPassword');
      await driver.tap(find.byValueKey(keys['login_page']));
      driver.waitFor(find.byType('SnackBar'));
      expect(await driver.getText(find.text('Please input a proper email address.')), 'Please input a proper email address.');


      //error test when no email found
      await driver.tap(find.byValueKey(keys['email']));
      await driver.enterText('wrongcredentials@gmail.com');
      await driver.tap(find.byValueKey(keys['password']));
      await driver.enterText('dummyPassword');
      await driver.tap(find.byValueKey(keys['login_page']));
      driver.waitFor(find.byType('SnackBar'));
      expect(await driver.getText(find.text('No user found with that email')), 'No user found with that email');


      //error test when email = correct, but wrong password
      await driver.tap(find.byValueKey(keys['email']));
      await driver.enterText('maharta2@gmail.com');
      await driver.tap(find.byValueKey(keys['password']));
      await driver.enterText('wrongPassword');
      await driver.tap(find.byValueKey(keys['login_page']));
      driver.waitFor(find.byType('SnackBar'));
      expect(await driver.getText(find.text('Wrong Password')), 'Wrong Password');

      //test login with correct credentials
      await driver.tap(find.byValueKey(keys['email']));
      await driver.enterText('maharta2@gmail.com');
      await driver.tap(find.byValueKey(keys['password']));
      await driver.enterText('gede123');


      await driver.tap(find.byValueKey(keys['login_page']));

      await driver.waitFor(find.byType('CircularProgressIndicator'));
      expect(await driver.getText(find.text('REKOMENDASI')), 'REKOMENDASI');
    });

    test('main page test', () async{
      await driver.waitFor(find.byType('MainGridView'));
      await driver.tap(find.byValueKey(keys['firstCard']));
      await driver.waitFor(find.byType('ListView'));
      await driver.scrollUntilVisible(find.byType('ListView'), find.text('CHAT PENJUAL'));
      //check if widget is present
      final isExist = await isPresent(find.text('CHAT PENJUAL'), driver);
      if(isExist == true){
        print('widget found, main_page test success.');
      } else {
        print('widget not found, main page test failed');
      }
    });
  });
}