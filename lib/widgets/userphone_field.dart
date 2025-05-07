import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/login_bloc/login_event.dart';
import '../bloc/login_bloc/login_state.dart';

class UsernameField extends StatelessWidget {
  const UsernameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          decoration: InputDecoration(
            hintText: "Email",
            hintStyle: TextStyle(color: Colors.red),
            errorText: state.isValidPhoneNumber?null:"Enter Valid mail",
            prefixIcon: Icon(Icons.mail, color: Colors.red),
            filled: true,
            fillColor: Colors.red[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) =>
              context.read<LoginBloc>().add(LoginPhoneChanged(phone: value)),
        );
      },
    );
  }
}
