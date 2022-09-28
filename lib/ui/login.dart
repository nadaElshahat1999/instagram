

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/bussiness_logic/login/login_cubit.dart';
import 'package:instagram/components/component.dart';
import 'package:instagram/ui/home.dart';
import 'package:instagram/ui/register.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController passwordController=TextEditingController();

  TextEditingController emailController=TextEditingController();

  var loginFormkey=GlobalKey<FormState>();
  bool isPasswordVisible=true;
  late LoginCubit cubit;
  @override
  Widget build(BuildContext context) {
    cubit=BlocProvider.of<LoginCubit>(context);
    //cubit=context.read<LoginCubit>();//other way to initialize cubit
    return BlocListener<LoginCubit, LoginStates>(
  listener: (context, state) {
    if(state is LoginSuccessState){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen()));
    }
    else if (state is LoginFailState){
      print(state.errorMessege);
      SnackBar snackBar=SnackBar(content: Text(state.errorMessege),
      action: SnackBarAction(label: 'ok',onPressed: (){},),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  },
  child: Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10.sp),
          child: Form(
            key:loginFormkey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('LOGIN',style: TextStyle(
                      fontSize: 30.sp,fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 15.sp,),
                  Text('Login now to browse our hot offers',style: TextStyle(
                    fontSize: 17.sp,color: Colors.grey[500],fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 25.sp,),
                  myTextFormField(controller: emailController, 
                      validator: (value)=>cubit.emailValidator(value.toString()),
                      label: 'Email Address', prefixIcon: Icons.email_outlined),

                  SizedBox(height: 15.sp,),

                  myTextFormField(controller: passwordController, 
                      validator: (value)=>cubit.passwordValidator(value.toString()),
                      label: 'Password', prefixIcon: Icons.lock_outline
                      ,suffixIcon: eyeIcon()),
                  SizedBox(height: 25.sp,),
                  MaterialButton(onPressed: (){
                    if (loginFormkey.currentState!.validate()) {
                      cubit.login(email: emailController.text,
                          password: passwordController.text);
                    }
                    },
                    child: Text('LOGIN',style: TextStyle(color: Colors.white,fontSize: 15.sp,),),
                    color: Colors.blue,height: 50,minWidth: double.infinity,),
                  SizedBox(height: 25.sp,),
                  SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an accont ??",style: TextStyle(
                          fontSize: 14.sp,
                        ),),
                        SizedBox(width: 5.sp,),
                        TextButton(onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> RegisterScreen()));
                        }, child:
                        Text('REGISTER',style: TextStyle(
                          fontSize: 15.sp,fontWeight: FontWeight.bold,
                        ),),)
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    ),
);


  }
  Widget eyeIcon(){
    return InkWell(
      onTap: (){
        isPasswordVisible=!isPasswordVisible;
        setState(() {});
      },
      child :(isPasswordVisible)?
    Icon(Icons.remove_red_eye_outlined,size: 20.sp,):
    Icon(Icons.visibility_off,size: 20.sp,)
    );
  }
}
