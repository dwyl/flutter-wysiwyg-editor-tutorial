<div align="center">

# `Flutter` `WYSIWYG` editor tutorial

📱 📝 How to do WYSIWYG editing in Flutter in a few easy steps.

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/dwyl/flutter-wysiwyg-editor-tutorial/ci.yml?label=build&style=flat-square&branch=main)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/flutter-wysiwyg-editor-tutorial/master.svg?style=flat-square)](https://codecov.io/github/dwyl/flutter-wysiwyg-editor-tutorial?branch=master)
[![HitCount](https://hits.dwyl.com/dwyl/flutter-wysiwyg-editor-tutorial.svg?style=flat-square&show=unique)](https://hits.dwyl.com/dwyl/flutter-wysiwyg-editor-tutorial)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/flutter-wysiwyg-editor-tutorial/issues)


</div>
<br />

- [`Flutter` `WYSIWYG` editor tutorial](#flutter-wysiwyg-editor-tutorial)
- [Why? 🤷‍](#why-)
- [What? 💭](#what-)
- [Who? 👤](#who-)
- [_How_? 👩‍💻](#how-)
  - [Prerequisites? 📝](#prerequisites-)
  - [0. Project setup](#0-project-setup)
    - [\*\*Make sure your `flutter` is up-to-date!](#make-sure-your-flutter-is-up-to-date)
  - [1. Installing all the needed dependencies](#1-installing-all-the-needed-dependencies)
  - [2. Setting up the responsive framework](#2-setting-up-the-responsive-framework)
  - [3. Create `HomePage` with basic editor](#3-create-homepage-with-basic-editor)
  - [4. Adding the `Quill` editor](#4-adding-the-quill-editor)
    - [4.1 Instantiating `QuillEditor`](#41-instantiating-quilleditor)
    - [4.2 Defining triple click selection behaviour](#42-defining-triple-click-selection-behaviour)
    - [4.3 Reassigning `quillEditor` on web platforms](#43-reassigning-quilleditor-on-web-platforms)
      - [4.3.1 Creating web embeds](#431-creating-web-embeds)


# Why? 🤷‍

On our [`app`](https://github.com/dwyl/app),
people will add their todo items.
To do so, they *need* a capable editor
that is easy-to-use that also supports
customization
(new buttons).

# What? 💭

When typing text,
the person using should be able to edit/format it
to their heart's content 
and customize it to their liking.

This repo will showcase an introduction
of a `WYSIWYG` Rich Text editor 
that can be used on both mobile and web devices.
We want this editor to be *extensible*, 
meaning that we want to add specific features
and *introduce them* to the person
incrementally.


# Who? 👤

This quick demo is aimed at people in the @dwyl team
or anyone who is interested in learning 
more about building a `WYSIWYG` editor.

> [!WARNING]
> 
> Do take note that this guide is meant 
> **only for `mobile devices` and `web apps`**.
> It is **not** tailored to Flutter desktop applications.
> We'll be focusing on the web and mobile devices
> because it's more important *to us* 
> and because it's simpler to understand.
> Some implementation details will need to be changed
> if you want this to work on desktop applications.
> 
> If you need this,
> please check the
> [example app from `flutter-quill`](https://github.com/singerdmx/flutter-quill/tree/master/example),
> as they address this distinction.

# _How_? 👩‍💻

## Prerequisites? 📝

This demo assumes you have foundational knowledge of `Flutter`.
If this is your first time tinkering with `Flutter`,
we suggest you first take a look at 
https://github.com/dwyl/learn-flutter.

In the linked repo, you will learn 
how to install the needed dependencies
and how to debug your app on both an emulator
or a physical device.


## 0. Project setup

To create a new project in `Flutter`,
follow the steps in 
https://github.com/dwyl/learn-flutter#0-setting-up-a-new-project.

After completing these steps,
you should have a boilerplate `Flutter` project.

If you run the app, you should see the template Counter app.
The tests should also run correctly.
Executing `flutter test --coverage` should yield
this output on the terminal.

```sh
00:02 +1: All tests passed!   
```

This means everything is correctly set up!
We are ready to start implementing!

### **Make sure your `flutter` is up-to-date!

Make sure you are running the latest version of `Flutter`!
You can make a run-through of the versions by running:

```
flutter doctor
```

To make sure you're running the latest version,
run `flutter upgrade`.

This is needed when running the app against physical devices.
A *minimum `SDK` version* is needed to run the project with its dependencies
so you don't encounter this error:

```
uses-sdk:minSdkVersion XX cannot be smaller than version XX declared in library
```

If you are *still* encountering this problem on your physical device,
please follow the instructions in https://stackoverflow.com/questions/52060516/flutter-how-to-change-android-minsdkversion-in-flutter-project.
You will essentially need to change the `minSdkVersion` parameter
inside `android/app/build.gradle` file 
and bump it to a higher version (it is suggested in the error output).


## 1. Installing all the needed dependencies

To implement our application that runs `flutter_quill`, 
we are going to need install some dependencies 
that we're going to be using.

- [`flutter_quill`](https://github.com/singerdmx/flutter-quill), 
the main package with the text editor
with Delta capabilities.
- [`flutter_quill_extensions`](https://pub.dev/packages/flutter_quill_extensions), 
needed to use image and video embeds into the editor,.
- [`file_picker`](https://pub.dev/packages/file_picker),
so we're able to import files.
- [`universal_io`](https://pub.dev/packages/universal_io),
an extended version of `dart.io` that works on all platforms.
- [`universal_html`](https://pub.dev/packages/universal_html),
extended version of `dart.html` that is cross-platform.
- [`responsive_framework`](https://pub.dev/packages/responsive_framework),
package that will make it easier to make our `Flutter` app responsive.
- [`path`](https://pub.dev/packages/path)
and [`path_provider`](https://pub.dev/packages/path_provider),
needed to find the path of chosen images.

To install of these packages, 
head over to `pubspec.yaml`
and inside the `dependencies` section,
add the following lines:

```dart
  flutter_quill: ^7.3.3
  flutter_quill_extensions: ^0.4.0
  file_picker: ^5.3.3
  universal_io: ^2.2.2
  responsive_framework: ^1.1.0
  universal_html: ^2.2.3
  path: ^1.8.3
  path_provider: ^2.1.0
```

And run `flutter pub get` to download these dependencies.


## 2. Setting up the responsive framework

Now that we have all the dependencies we need,
let's start by setting up all the needed breakpoints
from the `responsive_framework`
to make our app responsive 
and *conditionally show elements*
according to the device size.

Head over to `main.dart`
and paste the following:

```dart
import 'package:app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App(
    platformService: PlatformService(),
  ),);
}

/// Entry gateway to the application.
/// Defining the MaterialApp attributes and Responsive Framework breakpoints.
class App extends StatelessWidget {
  const App({required this.platformService, super.key});

  final PlatformService platformService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Editor Demo',
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 425, name: MOBILE),
          const Breakpoint(start: 426, end: 768, name: TABLET),
          const Breakpoint(start: 769, end: 1440, name: DESKTOP),
          const Breakpoint(start: 1441, end: double.infinity, name: '4K'),
        ],
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: HomePage(platformService: platformService),
    );
  }
}

/// Platform service class that tells if the platform is web-based or not
class PlatformService {
  bool isWebPlatform() {
    return kIsWeb;
  }
}
```

Let's break this down!

- inside `main()`, we initialize the app 
by passing a `platformService`,
our own small [stubbable](https://en.wikipedia.org/wiki/Method_stub)
class that will allow us to check in tests whether the device
is mobile or desktop-based.
- our app is wrapped in `MaterialApp`.
In the `builder` parameter,
we define the `responsive_framework` breakpoints
to conditionally render widgets according to the device's size.
- we define the `HomePage` in the `home` parameter.
This `HomePage` class is not yet defined.

This will fail because `home_page.dart` is not defined.
Let's do that! 😀


## 3. Create `HomePage` with basic editor

In `lib`, create a file called `home_page.dart`
and paste the following code.

```dart
/// Importing all the needed imports so the README is easier to follow
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:app/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


/// Home page with the `flutter-quill` editor
class HomePage extends StatefulWidget {
  const HomePage({
    required this.platformService, super.key,
  });

  final PlatformService platformService;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  /// `flutter-quill` editor controller
  QuillController? _controller;

  /// Focus node used to obtain keyboard focus and events
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Loading widget if controller's not loaded
    if (_controller == null) {
      return const Scaffold(body: Center(child: Text('Loading...')));
    }

    /// Returning scaffold with editor as body
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Flutter Quill',
        ),
      ),
      body: Container(),
    );
  }
}
```

We are importing all the needed imports
right off the bat so we don't have to deal with those later 😉.

In this file, 
we are simply creating a basic **stateful widget** `HomePage`
that renders a `Scaffold` widget
with a `Container()` as its body.

You might have noticed we've defined a 
[**`QuillController`**](https://github.com/singerdmx/flutter-quill/blob/36d72c1987f0cb8d6c689c12542600364c07e20f/lib/src/widgets/controller.dart)
`_controller`.
This controller will keep track of the
**`deltas`** 
and the **text** that is written in the editor.

> [!NOTE]  
> `Deltas` is an object format that represents
> contents and changes in a readable way.
> To learn about them, we *highly suggest* visiting
> https://quilljs.com/docs/delta.

For the Quill Editor to properly function,
we are going to use this `_controller` parameter later on.
The `_focusNode` parameter is also needed in the next section.


## 4. Adding the `Quill` editor

Now here comes to fun part!
Let's instantiate the editor so it can be shown on screen!

Inside `HomePageState`, 
we are going to instantiate and define
our editor and render it on its body.
So, let's do that!

Inside the `build()` function,
change it to this:

```dart
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Flutter Quill',
        ),
      ),
      body: _buildEditor(),
    );
```

Now, inside `HomePageState`, 
let's create this `_buildEditor()` function,
which will return the **Quill Editor** widget! 🥳

```dart
  Widget _buildEditor(BuildContext context) {

  }
```

Now, let's start implementing our editor!


### 4.1 Instantiating `QuillEditor`

[`QuillEditor`](https://github.com/singerdmx/flutter-quill/blob/36d72c1987f0cb8d6c689c12542600364c07e20f/lib/src/widgets/editor.dart#L149)
is the main class in which we define the behaviour
we want from our editor.

In `_buildEditor`, add this:

```dart
    Widget quillEditor = QuillEditor(
      controller: _controller!,
      scrollController: ScrollController(),
      scrollable: true,
      focusNode: _focusNode,
      autoFocus: false,
      readOnly: false,
      placeholder: 'Write what\'s on your mind.',
      enableSelectionToolbar: isMobile(),
      expands: false,
      padding: EdgeInsets.zero,
      onTapUp: (details, p1) {
        return _onTripleClickSelection();
      },
      customStyles: DefaultStyles(
        h1: DefaultTextBlockStyle(
          const TextStyle(
            fontSize: 32,
            color: Colors.black,
            height: 1.15,
            fontWeight: FontWeight.w300,
          ),
          const VerticalSpacing(16, 0),
          const VerticalSpacing(0, 0),
          null,
        ),
        sizeSmall: const TextStyle(fontSize: 9),
        subscript: const TextStyle(
          fontFamily: 'SF-UI-Display',
          fontFeatures: [FontFeature.subscripts()],
        ),
        superscript: const TextStyle(
          fontFamily: 'SF-UI-Display',
          fontFeatures: [FontFeature.superscripts()],
        ),
      ),
      embedBuilders: [...FlutterQuillEmbeds.builders()],
    );
```

As you may see, the `QuillEditor` class 
can take a *lot* of parameters.

So let's go over them one by one!

- **`controller`** is where
we need to pass a `QuillController` object.
This field is mandatory.
- **`scrollController`** receives a 
[`ScrollController`](https://api.flutter.dev/flutter/widgets/ScrollController-class.html)
object.
This is used to properly scroll the editor vertically and horizontally.
- **`scrollable`** is a boolean
that defines if the editor is scrollable or not.
- **`focusNode`** parameter
receives a [`FocusNode`](https://api.flutter.dev/flutter/widgets/FocusNode-class.html)
object.
With this, we can control the events that come from the keyboard.
We've defined `_focusNode` in the previous section for this very purpose.
- **`autoFocus`** defines whether the editor 
should focus itself if nothing else is already focused.
If `true`, the keyboard will open as soon as the editor obtain focus.
Otherwise, the keyboard is only shown *after* the person taps the editor.
- **`readOnly`** defines whether the text in the editor is read-only.
- **`placeholder`** pertains
to an optional placeholder text the person can see when the editor is empty.
- **`enableSelectionToolbar`** defines whether to show 
the cut/copy/paste menu when selecting text.
We are only doing this on mobile devices
by using `flutter_quill`'s `isMobile()` function.
- **`expands`** pertains to
whether this editor's height will be sized to fill its parent.
- **`padding`** will configure the padding of the editor.
We've set it to `EdgeInsets.zero`, 
meaning there's no padding.
- **`customStyles`**,
which allows us to override the default styles applied to text.
The editor allows us to set different styles
of the text with the [`DefaultStyles`](https://github.com/singerdmx/flutter-quill/blob/36d72c1987f0cb8d6c689c12542600364c07e20f/lib/src/widgets/default_styles.dart#L139)
class.
For example, we can set how big a `h1` text is.
- **`embedBuilders`** receives [embed blocks](https://github.com/singerdmx/flutter-quill#embed-blocks).
These provide implementation details for rendering images/videos and other files
in the editor.
These are *not* provided by default as part of this package,
hence why we use the `flutter_quill_extensions` package
to get the default embeds.
- **`onTapUp`** defines a callback
when the person presses *up* from the editor.
This is useful to define behaviour of 
**text selection**.
We are going to implement the `_onTripleClickSelection()` 
in the next section.


### 4.2 Defining triple click selection behaviour

We can see the behaviour of triple clicking on text
and selecting different pieces of text everywhere on the internet.
If you use browsers like Chrome,
if you click on a word *two times*,
the word is selected.
If you click again (*three clicks*),
a whole paragraph is selected.

We can customize *what we select*
in the `onTapUp` parameter of `QuillEditor`.
This is what we're going to be doing in 
`_onTripleClickSelection()`.

Add the following line on top of the `home_page.dart` file,
under the imports.

```dart
enum _SelectionType {
  none,
  word,
}
```

This `_SelectionType` enum is going to be used inside
`_onTripleClickSelection()` to switch over the selections
as the person clicks on the text.

Now, inside `HomePageState` (outside `_buildEditor()` function),
let's create the `_onTripleClickSelection()` function.

```dart
  /// Callback called whenever the person taps on the text.
  /// It will select nothing, then the word if another tap is detected
  /// and then the whole text if another tap is detected (triple).
  bool _onTripleClickSelection() {
    final controller = _controller!;

    // If nothing is selected, selection type is `none`
    if (controller.selection.isCollapsed) {
      _selectionType = _SelectionType.none;
    }

    // If nothing is selected, selection type becomes `word
    if (_selectionType == _SelectionType.none) {
      _selectionType = _SelectionType.word;
      return false;
    }

    // If the word is selected, select all text
    if (_selectionType == _SelectionType.word) {
      final child = controller.document.queryChild(
        controller.selection.baseOffset,
      );
      final offset = child.node?.documentOffset ?? 0;
      final length = child.node?.length ?? 0;

      final selection = TextSelection(
        baseOffset: offset,
        extentOffset: offset + length,
      );

      // Select all text and make next selection to `none`
      controller.updateSelection(selection, ChangeSource.REMOTE);

      _selectionType = _SelectionType.none;

      return true;
    }

    return false;
  }
```

In this function,
we check the current state of the selection.
If there is no selection in the controller,
we set the `_SelectionType` to `none`.

On the second tap (meaning the current `_SelectionType` is `none`),
we set the `_SelectionType` to `word`.

On the third tap (meaning the current `_SelectionType` is `word`),
we select the *whole text in the editor*.
For this, we get the text offset from the `controller`
and use it to set the text selection to the whole text.
We then set the `_selectionType` back to `none`,
so on the next click,
the selection loops back to nothing.


### 4.3 Reassigning `quillEditor` on web platforms

In order for our editor to work on the web,
we need to make a few changes to the `quillEditor` variable.
Because of this, 
we are going to reassign a new `QuillEditor` instance
to it on web platforms.

Go back to `_buildEditor()` and continue where we left off.
Add the following line under the `quillEditor` variable instantiation.

```dart
    if (widget.platformService.isWebPlatform()) {
      quillEditor = QuillEditor(
        controller: _controller!,
        scrollController: ScrollController(),
        scrollable: true,
        focusNode: _focusNode,
        autoFocus: false,
        readOnly: false,
        placeholder: 'Add content',
        expands: false,
        padding: EdgeInsets.zero,
        onTapUp: (details, p1) {
          return _onTripleClickSelection();
        },
        customStyles: DefaultStyles(
          h1: DefaultTextBlockStyle(
            const TextStyle(
              fontSize: 32,
              color: Colors.black,
              height: 1.15,
              fontWeight: FontWeight.w300,
            ),
            const VerticalSpacing(16, 0),
            const VerticalSpacing(0, 0),
            null,
          ),
          sizeSmall: const TextStyle(fontSize: 9),
        ),
        embedBuilders: [...defaultEmbedBuildersWeb],
      );
    }
```

We are using the `platformService` we mentioned earlier
to check if the platform is **web** or not.

As you can see, the parameters are quite similar
to the previous assignment (meant only for mobile devices),
except the `embedBuilders` parameter,
which uses the `defaultEmbedBuildersWeb`.
This variable is not yet defined, so we shall do this right now!


#### 4.3.1 Creating web embeds

As noted in `flutter-quill`'s documentation
(https://github.com/singerdmx/flutter-quill/tree/master#web),
we need to define web embeds so Quill Editor works properly.



- toolbar next

