import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';

import '../data/models/story.dart';

class StoryScreen extends StatelessWidget {
  final controller =StoryController();
  late List<Story> storyDetails;
  StoryScreen(this.storyDetails, {Key? key}) : super(key: key);
  @override
   Widget build(BuildContext context) {
  //   List<StoryItem> storyItems=[
  //     StoryItem.pageImage(
  //       url: 'https://wirepicker.com/wp-content/uploads/2021/09/android-vs-ios_1200x675.jpg'
  //       , controller: controller),
  //     StoryItem.pageImage(
  //         url: 'https://www.neappoli.com/static/media/flutterImg.94b8139a.png'
  //         , controller: controller),
  //     StoryItem.pageImage(
  //       url: 'https://wirepicker.com/wp-content/uploads/2021/09/android-vs-ios_1200x675.jpg'
  //       , controller: controller),
  //     StoryItem.pageImage(
  //         url: 'https://www.neappoli.com/static/media/flutterImg.94b8139a.png'
  //         , controller: controller),
  //     StoryItem.pageImage(
  //         url: 'https://wirepicker.com/wp-content/uploads/2021/09/android-vs-ios_1200x675.jpg'
  //         , controller: controller),
  //     StoryItem.pageImage(
  //         url: 'https://www.neappoli.com/static/media/flutterImg.94b8139a.png'
  //         , controller: controller),
  //   ];
    List<StoryItem> stories=[];
    for (var element in storyDetails) {
      stories.add(StoryItem.pageImage(
          url: element.storyImageUrl!,
          controller: controller));
    }
    return StoryView(storyItems: stories,
        controller: controller,
      onComplete: (){
        Navigator.pop(context);
      },
      onStoryShow: (s) {
      //notifyServer(s)
      },
      repeat: true,
        onVerticalSwipeComplete: (direction) {
          if (direction == Direction.down) {
            Navigator.pop(context);
          }
        } , // To disable vertical swipe gesture

    );
  }
}
