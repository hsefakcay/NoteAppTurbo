import 'package:easy_localization/easy_localization.dart';
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
                      Text('auth.loginTitle'.tr(), style: theme.textTheme.displayMedium),
                      context.sized.emptySizedHeightBoxLow3x,
                      Text(
                        'auth.login'.tr(),
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: context.general.colorScheme.primary,
                        ),
                      ),
                      context.sized.emptySizedHeightBoxNormal,

                      // Email Field
                      Text('auth.email'.tr(), style: theme.textTheme.titleLarge),
                      context.sized.emptySizedHeightBoxLow,

                      CustomTextField.email(
                        controller: _emailCtrl,
                        hintText: 'auth.emailHint'.tr(),
                      ),

                      context.sized.emptySizedHeightBoxLow3x,

                      // Password Field
                      Text('auth.password'.tr(), style: theme.textTheme.titleLarge),

                      context.sized.emptySizedHeightBoxLow,

                      CustomTextField.password(
                        controller: _passwordCtrl,
                        hintText: 'auth.passwordHint'.tr(),
                      ),

                      context.sized.emptySizedHeightBoxLow,

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implement forgot password
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text('auth.forgotPasswordSoon'.tr())));
                          },
                          child: Text('auth.forgotPassword'.tr()),
                        ),
                      ),
                      context.sized.emptySizedHeightBoxNormal,

                      // Login Button
                      GradientButton(
                        text: 'auth.login'.tr(),
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
                            Text(
                              'auth.noAccount'.tr(),
                              style: context.general.textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () => Navigator.of(
                                context,
                              ).pushReplacementNamed(AppConstants.routeRegister),
                              child: Text(
                                'auth.register'.tr(),
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
