import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/main.dart';
import 'package:mynotes/services/phone_auth/bloc/phone_auth_bloc.dart';
import 'package:mynotes/views/login_view.dart';

class LoginPhoneNumberView extends StatelessWidget {
  const LoginPhoneNumberView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginView()));
            },
          ),
          title: const Text('Phone Login'),
        ),
        body: _PhoneAuthViewBuilder(),
      ),
    );
  }
}

class _PhoneAuthViewBuilder extends StatelessWidget {
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _codeNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthBloc, PhoneAuthState>(
      listener: (previous, current) {
        if (current is PhoneAuthCodeVerificationSuccess) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else if (current is PhoneAuthCodeVerficationFailure) {
          _showSnackBarWithText(context: context, textValue: current.message);
        } else if (current is PhoneAuthError) {
          _showSnackBarWithText(
              context: context, textValue: 'Uexpected error occurred.');
        } else if (current is PhoneAuthNumberVerficationFailure) {
          _showSnackBarWithText(context: context, textValue: current.message);
        } else if (current is PhoneAuthNumberVerificationSuccess) {
          _showSnackBarWithText(
              context: context,
              textValue: 'SMS code is sent to your mobile number.');
        } else if (current is PhoneAuthCodeAutoRetrevalTimeoutComplete) {
          _showSnackBarWithText(
              context: context, textValue: 'Time out for auto retrieval');
        }
      },
      builder: (context, state) {
        if (state is PhoneAuthInitial) {
          return _phoneNumberSubmitWidget(context);
        } else if (state is PhoneAuthNumberVerificationSuccess) {
          return _codeVerificationWidget(context, state.verificationId);
        } else if (state is PhoneAuthNumberVerficationFailure) {
          return _phoneNumberSubmitWidget(context);
        } else if (state is PhoneAuthCodeVerficationFailure) {
          return _codeVerificationWidget(
            context,
            state.verificationId,
          );
        } else if (state is PhoneAuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container();
      },
    );
  }

  Widget _phoneNumberSubmitWidget(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              child: TextField(
                controller: _countryCodeController,
                maxLength: 3,
                obscureText: false,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: '+',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 250,
              child: TextField(
                obscureText: false,
                controller: _phoneNumberController,
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        OutlinedButton(
          onPressed: () => _verifyPhoneNumber(context),
          child: const Text('Submit'),
        )
      ],
    );
  }

  Widget _codeVerificationWidget(context, verifcationId) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _codeNumberController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              hintText: 'Enter Code sent on phone',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () => _verifySMS(
            context,
            verifcationId,
          ),
          child: const Text('verify'),
        )
      ],
    );
  }

  void _verifyPhoneNumber(BuildContext context) {
    BlocProvider.of<PhoneAuthBloc>(context).add(PhoneAuthNumberVerified(
        phoneNumber:
            '+' + _countryCodeController.text + _phoneNumberController.text));
  }

  void _verifySMS(BuildContext context, String verificationCode) {
    BlocProvider.of<PhoneAuthBloc>(context).add(PhoneAuthCodeVerified(
        verificationId: verificationCode, smsCode: _codeNumberController.text));
  }

  void _showSnackBarWithText(
      {required BuildContext context, required String textValue}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(textValue)));
  }
}
