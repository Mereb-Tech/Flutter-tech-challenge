// ignore_for_file: use_build_context_synchronously

part of auth_view;

@RoutePage()
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  FormGroup buildForm() => fb.group(<String, Object>{
        'userName': FormControl<String>(
          validators: [Validators.required],
        ),
        'email': FormControl<String>(
          validators: [Validators.required, Validators.email],
        ),
        'password': FormControl<String>(
          validators: [Validators.required],
        ),
        'confirmPassword': FormControl<String>(
          validators: [Validators.required],
        ),
      }, [
        Validators.mustMatch('password', 'confirmPassword')
      ]);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, theme.colorScheme.secondary],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Create Your\nAccount',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: ReactiveForm(
                  formGroup: buildForm(),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const ReactiveExtendedTextField(
                            formControlName: 'userName',
                            label: 'User Name',
                            hint: 'Enter your user name',
                          ),
                          const SizedBox(height: 20),
                          const ReactiveExtendedTextField(
                            formControlName: 'email',
                            label: 'Gmail',
                            hint: 'Enter your Gmail',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),
                          const ReactiveExtendedTextField(
                            formControlName: 'password',
                            label: 'Password',
                            hint: 'Enter your password',
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          const ReactiveExtendedTextField(
                            formControlName: 'confirmPassword',
                            label: 'Confirm Password',
                            hint: 'Re-enter your password',
                            obscureText: true,
                          ),
                          const SizedBox(height: 70),
                          Consumer<AuthViewModel>(
                              builder: (context, watch, child) {
                            return ReactiveFormConsumer(
                              builder: (context, form, child) {
                                final isInvalid = form.invalid;
                                return watch.isBusy
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: isInvalid
                                            ? null
                                            : () async {
                                                final email = form
                                                    .control('email')
                                                    .value as String;
                                                final password = form
                                                    .control('password')
                                                    .value as String;
                                                final username = form
                                                    .control('userName')
                                                    .value as String;
                                                final res = await context
                                                    .read<AuthViewModel>()
                                                    .registerWithEmailPassword(
                                                      email: email,
                                                      password: password,
                                                      username: username,
                                                    );
                                                if (res) {
                                                  context.router.replaceAll([
                                                     HomeRoute(),
                                                  ]);
                                                }
                                              },
                                        child: Container(
                                          height: 55,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            gradient: isInvalid
                                                ? const LinearGradient(colors: [
                                                    Colors.grey,
                                                    Colors.grey,
                                                  ])
                                                : LinearGradient(
                                                    colors: [
                                                      theme.primaryColor,
                                                      theme
                                                          .colorScheme.secondary
                                                    ],
                                                  ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'SIGN UP',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                              },
                            );
                          }),
                          const SizedBox(height: 80),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () {
                                context.pushRoute(const LoginRoute());
                              },
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Already have an account?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "Sign in",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
