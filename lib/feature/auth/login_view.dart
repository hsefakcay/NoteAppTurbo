import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

import '../../product/constants/app_constants.dart';
import '../../product/widgets/index.dart';
import 'bloc/auth_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isAuthenticated) {
            Navigator.of(context).pushReplacementNamed(AppConstants.routeHome);
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: context.padding.medium,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo veya App İsmi
                      Center(
                        child: Container(
                          width: context.sized.dynamicWidth(0.2),
                          height: context.sized.dynamicWidth(0.2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                context.general.colorScheme.primary,
                                context.general.colorScheme.primary.withOpacity(0.7),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.note_alt_outlined,
                            size: context.sized.dynamicWidth(0.1),
                            color: context.general.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      context.sized.emptySizedHeightBoxNormal,

                      // Başlık
                      Text('Üretkenliğe hazır mısınız?', style: theme.textTheme.displayMedium),
                      context.sized.emptySizedHeightBoxLow3x,
                      Text(
                        'Giriş Yapın',
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: context.general.colorScheme.primary,
                        ),
                      ),
                      context.sized.emptySizedHeightBoxNormal,

                      // Email Field
                      Text('Email', style: theme.textTheme.titleLarge),
                      context.sized.emptySizedHeightBoxLow,

                      CustomTextField.email(controller: _emailCtrl, hintText: 'Email adresiniz'),

                      context.sized.emptySizedHeightBoxLow3x,

                      // Password Field
                      Text('Şifre', style: theme.textTheme.titleLarge),

                      context.sized.emptySizedHeightBoxLow,

                      CustomTextField.password(controller: _passwordCtrl, hintText: 'Şifreniz'),

                      context.sized.emptySizedHeightBoxLow,

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implement forgot password
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Şifre sıfırlama yakında eklenecek')),
                            );
                          },
                          child: const Text('Şifremi Unuttum?'),
                        ),
                      ),
                      context.sized.emptySizedHeightBoxNormal,

                      // Login Button
                      GradientButton(
                        text: 'Giriş Yap',
                        isLoading: state.isLoading,
                        onPressed: state.isLoading
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  context.read<AuthCubit>().signIn(
                                    _emailCtrl.text,
                                    _passwordCtrl.text,
                                  );
                                }
                              },
                      ),
                      context.sized.emptySizedHeightBoxNormal,

                      // Sign Up Link
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text('Hesabınız yok mu? ', style: context.general.textTheme.bodyMedium),
                            InkWell(
                              onTap: () => Navigator.of(
                                context,
                              ).pushReplacementNamed(AppConstants.routeRegister),
                              child: Text(
                                'Kayıt Ol',
                                style: context.general.textTheme.bodyMedium?.copyWith(
                                  color: context.general.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      context.sized.emptySizedHeightBoxNormal,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
