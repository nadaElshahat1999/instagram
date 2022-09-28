
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/bussiness_logic/register/register_cubit.dart';
import 'package:instagram/components/component.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'login.dart';

class RegisterScreen extends StatefulWidget {

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController=TextEditingController();

  TextEditingController passwordController=TextEditingController();

  TextEditingController nameController=TextEditingController();

  TextEditingController phoneController=TextEditingController();

  var formkey=GlobalKey<FormState>();
  late RegisterCubit cubit;
  XFile? xFile;

  @override
  Widget build(BuildContext context) {
    cubit=BlocProvider.of<RegisterCubit>(context);
    return BlocListener<RegisterCubit, RegisterStates>(
  listener: (context, state) {
    if(state is RegisterSuccessState){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen()
          ));
    }
    if (state is RegisterFailState){
      print(state.errorMessege);
      SnackBar snackBar=SnackBar(content: Text(state.errorMessege),
        action: SnackBarAction(label: 'ok',onPressed: (){},),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  },
  child: Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: (){
                        Navigator.of(context).pop();

                      },
                      child: Icon(Icons.arrow_back,)),

                  SizedBox(height: 25.sp,),
                  Text('REGISTER',style: TextStyle(
                      fontSize: 30.sp,fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 15.sp,),
                  Text('Register now to browse our hot offers',style: TextStyle(
                    fontSize: 17.sp,color: Colors.grey[400],fontWeight: FontWeight.bold,
                  ),),SizedBox(height: 25.sp,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildProfileImage(),
                    ],
                  ),

                  SizedBox(height: 25.sp,),
                  myTextFormField(controller: nameController, validator: (value)=>cubit.nameValidator(value.toString()),
                      label: 'Name', prefixIcon: Icons.person),
                  SizedBox(height: 15.sp,),
                  myTextFormField(controller: emailController, validator:(value)=> cubit.emailValidator(value.toString()),
                      label: 'Email Address', prefixIcon: Icons.email_outlined),

                  SizedBox(height: 15.sp,),

                  myTextFormField(controller: passwordController, validator: (value)=>
                    cubit.passwordValidator(value.toString())
                  , label: 'Password', prefixIcon: Icons.lock_outline
                      ,suffixIcon: Icon(Icons.remove_red_eye_outlined,size: 20.sp,)),
                  SizedBox(height: 15.sp,),

                  myTextFormField(controller: phoneController, validator: (value)=>cubit.phoneValidator(value.toString()),
                    label: 'Phone', prefixIcon: Icons.phone
                    ,),
                  SizedBox(height: 25.sp,),
                  MaterialButton(onPressed: (){
                    register();
                  },shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                    child: Text('REGISTER',style: TextStyle(color: Colors.white,fontSize: 15.sp),),
                    color: Colors.blue,height: 50,minWidth: double.infinity,),


                ],
              ),
            ),
          ),
        ),
      ),
    ),
);

  }

  void register(){
    if(xFile==null){
      SnackBar snackBar=SnackBar(content: Text('select image'),
        action: SnackBarAction(label: 'ok',onPressed: (){},),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else if(formkey.currentState!.validate()){
      cubit.register(email: emailController.text, password: passwordController.text
      ,userName: nameController.text,phone: phoneController.text,imageFile: File(xFile!.path));
    }
  }
  Widget buildProfileImage(){
    return InkWell(
      onTap: ()async{
        final ImagePicker _picker = ImagePicker();
        // Pick an image
        xFile=await _picker.pickImage(source: ImageSource.gallery);
        setState(() {

        });
      },
      child: (xFile==null)?
      CircleAvatar(child: Icon(Icons.person,color: Colors.white,
        size: 35.sp,)
        ,backgroundColor: Colors.blue,radius: 25.sp,):
          ClipRRect
            (
            borderRadius: BorderRadius.circular(35.sp),
            child: Image.file(File(xFile!.path),width: 35.sp,
            height: 35.sp,fit: BoxFit.cover,),
          ),
    );
  }
}
