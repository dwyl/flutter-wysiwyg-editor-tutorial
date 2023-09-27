<div align="center">

# `Flutter` `WYSIWYG` Editor Tutorial

📱 📝 How to do WYSIWYG ("What You See Is What You Get") editing 
in `Flutter` in a few easy steps.

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/dwyl/flutter-wysiwyg-editor-tutorial/ci.yml?label=build&style=flat-square&branch=main)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/flutter-wysiwyg-editor-tutorial/master.svg?style=flat-square)](https://codecov.io/github/dwyl/flutter-wysiwyg-editor-tutorial?branch=master)
[![HitCount](https://hits.dwyl.com/dwyl/flutter-wysiwyg-editor-tutorial.svg?style=flat-square&show=unique)](https://hits.dwyl.com/dwyl/flutter-wysiwyg-editor-tutorial)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/flutter-wysiwyg-editor-tutorial/issues)


![dwyl-wysiwyg-demo-optimized](https://github.com/dwyl/flutter-wysiwyg-editor-tutorial/assets/194400/08c6daff-33be-4f1a-9077-012cfd52b72c)


</div>
<br />

- [`Flutter` `WYSIWYG` Editor Tutorial](#flutter-wysiwyg-editor-tutorial)
- [Why? 🤷‍](#why-)
- [What? 💭](#what-)
- [Who? 👤](#who-)
- [_How_? 👩‍💻](#how-)
  - [Prerequisites? 📝](#prerequisites-)
  - [0. Project setup](#0-project-setup)
    - [Make sure your `Flutter` is up-to-date!](#make-sure-your-flutter-is-up-to-date)
  - [1. Installing all the needed dependencies](#1-installing-all-the-needed-dependencies)
  - [2. Setting up the responsive framework](#2-setting-up-the-responsive-framework)
  - [3. Create `HomePage` with basic editor](#3-create-homepage-with-basic-editor)
  - [4. Adding the `Quill` editor](#4-adding-the-quill-editor)
    - [4.1 Instantiating `QuillEditor`](#41-instantiating-quilleditor)
    - [4.2 Defining triple click selection behaviour](#42-defining-triple-click-selection-behaviour)
    - [4.3 Reassigning `quillEditor` on web platforms](#43-reassigning-quilleditor-on-web-platforms)
      - [4.3.1 Creating web embeds](#431-creating-web-embeds)
    - [4.4 Creating the toolbar](#44-creating-the-toolbar)
      - [4.4.1 Defining image embed callbacks](#441-defining-image-embed-callbacks)
    - [4.5 Finishing editor](#45-finishing-editor)
  - [5. Getting images to work on the web](#5-getting-images-to-work-on-the-web)
    - [5.1 Install the needed dependencies](#51-install-the-needed-dependencies)
    - [5.2 Change the `_webImagePickImpl` callback function](#52-change-the-_webimagepickimpl-callback-function)
    - [5.3 Change the `_onImagePickCallback` callback function](#53-change-the-_onimagepickcallback-callback-function)
  - [6. Give the app a whirl](#6-give-the-app-a-whirl)
  - [7. Extending our `toolbar`](#7-extending-our-toolbar)
    - [7.1 Header font sizes](#71-header-font-sizes)
    - [7.2 Adding emojis](#72-adding-emojis)
    - [7.3 Adding embeddable links](#73-adding-embeddable-links)
- [A note about testing 🧪](#a-note-about-testing-)
- [Alternative editors](#alternative-editors)
- [Found this useful?](#found-this-useful)


# Why? 🤷‍

Our 
[`app`](https://github.com/dwyl/app),
allows `people` to add `items` of `text`
which get _transformed_ into several types of `list`.
e.g: `Todo List`, `Shopping List`, `Exercises`, etc. 
We *need* a capable editor
that is easy-to-use
and supports customization
(new buttons)
to allow them to _easily_ 
transform their `plaintext` into `richtext` 
e.g: headings, bold, highlights, links and images!

# What? 💭

When typing text,
the person using should be able to edit/format it
to their heart's content 
and customize it to their liking.

This repo will showcase an introduction
of a `WYSIWYG` Rich Text Editor 
that can be used on both `Mobile` and `Web`.
We want this editor to be *extensible*, 
meaning that we want to add specific features
and *introduce them* to the person
incrementally.


# Who? 👤

This quick demo is aimed at people in the @dwyl team
or anyone who is interested in learning 
more about building a `WYSIWYG` editor.

> **Note**: this guide is meant 
> **only for `Mobile` devices and `Web` Apps**.
> It is ***not*** tailored to **`Desktop` apps**.
> We are focusing on the `Web` and `Mobile` devices
> because it's 
> [more important *to us*](https://github.com/dwyl/learn-flutter#mac-focussed-) 
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
[dwyl/learn-flutter](https://github.com/dwyl/learn-flutter)

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

### Make sure your `Flutter` is up-to-date!

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

If we want to embed an image on a web-based platform
and show it to the person,
we need to define our own embed.
For this, create a folder called `web_embeds` inside `lib`.
Create a file called `web_embeds.dart`
and paste the following code.

```dart

import 'package:app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_html/html.dart' as html;

// Conditionally importing the PlatformViewRegistry class according to the platform
import 'mobile_platform_registry.dart' if (dart.library.html) 'web_platform_registry.dart' as ui_instance;

/// Custom embed for images to work on the web.
class ImageEmbedBuilderWeb extends EmbedBuilder {
  @override
  String get key => BlockEmbed.imageType;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final imageUrl = node.value.data;
    if (isImageBase64(imageUrl)) {
      // TODO: handle imageUrl of base64
      return const SizedBox();
    }
    final size = MediaQuery.of(context).size;

    // This is needed for images to be correctly embedded on the web.
    ImageUniversalUI().platformViewRegistry.registerViewFactory(PlatformService(), imageUrl, (viewId) {
      return html.ImageElement()
        ..src = imageUrl
        ..style.height = 'auto'
        ..style.width = 'auto';
    });

    // Rendering responsive image
    return Padding(
      padding: EdgeInsets.only(
        right: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
            ? size.width * 0.5
            : (ResponsiveBreakpoints.of(context).equals('4K'))
                ? size.width * 0.75
                : size.width * 0.2,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: HtmlElementView(
          viewType: imageUrl,
        ),
      ),
    );
  }
}

/// List of default web embed builders.
List<EmbedBuilder> get defaultEmbedBuildersWeb => [
      ImageEmbedBuilderWeb(),
    ];

```

This is where we define `defaultEmbedBuildersWeb`
we're using in `_buildEditor()`.
This array variable uses the `ImageEmbedBuilderWeb`,
our custom web embed so images are shown in web platforms.
We technically can add more embeds 
(for example, to show videos). 
But for now, let's keep it simple and only allow the person to add images.

The `ImageEmbedBuilderWeb` class pertains 
to the web image embed, 
extending the [`EmbedBuilder`](https://github.com/singerdmx/flutter-quill/blob/36d72c1987f0cb8d6c689c12542600364c07e20f/lib/src/widgets/embeds.dart#L9)
class from `flutter-quill`.

Let's break it down.
We define the `key` of the class
of *what type of object the embed pertains to*.
In our case, it's an image.

```dart
  @override
  String get key => BlockEmbed.imageType;
```

In the `build` function, 
we render the widget we want in the screen.
In this case, we render an `ImageElement`
with the `imageURL` that is passed to the class.
We use `ResponsiveBreakpoints` from `responsive_framework`
to show properly show the image across different device sizes.

Inside the `build()` function, you may notice the following lines:

```dart
    ImageUniversalUI().platformViewRegistry.registerViewFactory(PlatformService(), imageUrl, (viewId) {
      return html.ImageElement()
        ..src = imageUrl
        ..style.height = 'auto'
        ..style.width = 'auto';
    });
```

We need to call `registerViewFactory` from `dart:ui_web`
so the image is properly shown in web devices.
If we do not do this, 
**build compilation fails**.
This is because the package it's called from doesn't compile
when we create a build for mobile devices.
This is why we create a `ImageUniversalUI` class
that conditionally imports the package
so it compiles on both type of devices.
For more information, 
check https://github.com/flutter/flutter/issues/41563#issuecomment-547923478.

For this to work,
in the same file,
add this piece of code:

```dart
/// Class used to conditionally register the view factory.
/// For more information, check https://github.com/flutter/flutter/issues/41563#issuecomment-547923478.
class PlatformViewRegistryFix {
  void registerViewFactory(PlatformService platformService, imageURL, dynamic cbFnc) {
    if (platformService.isWebPlatform()) {
      ui_instance.PlatformViewRegistry.registerViewFactory(
        imageURL,
        cbFnc,
      );
    }
  }
}

/// Class that conditionally registers the `platformViewRegistry`.
class ImageUniversalUI {
  PlatformViewRegistryFix platformViewRegistry = PlatformViewRegistryFix();
}
```

`PlatformViewRegistryFix` calls the `registerViewFactory`
only on web platforms.
It uses the `ui_instance` object, 
which is conditionally imported on top of the file.
This `ui_instance` variable uses the appropriate package
to call `registerViewFactory`.

> [!NOTE]
> Check https://github.com/flutter/flutter/issues/41563#issuecomment-547923478 
> for more information about `dart:ui` and `dart:web_ui`
> to better understand why we need to conditionally import them separately 
> so the application compiles to both target devices.

This is why we import the correct `ui_instance` 
so we can compile to both targets `web` and `mobile` devices.

```dart
import 'mobile_platform_registry.dart' if (dart.library.html) 'web_platform_registry.dart' as ui_instance;
```

Neither of these files are created.
So let's do that!
In the same folder `lib/web_embeds`,
create `mobile_platform_registry.dart`
and add:

```dart
/// Class used to `registerViewFactory` for mobile platforms.
/// 
/// Please check https://github.com/flutter/flutter/issues/41563#issuecomment-547923478 for more information.
class PlatformViewRegistry {
  static void registerViewFactory(String viewId, dynamic cb) {}
}
```

This is just a simple class with `registerViewFactory` function
that effectively does nothing.
We don't *need for it to do anything*
because we are implementing the embed **only for the web**.
So we just only need this to compile.

Now, in the same folder, create the file `web_platform_registry.dart`
and add:

```dart
import 'dart:ui_web' as web_ui;

/// Class used to `registerViewFactory` for web platforms.
/// 
/// Please check https://github.com/flutter/flutter/issues/41563#issuecomment-547923478 for more information.
class PlatformViewRegistry {
  static void registerViewFactory(String viewId, dynamic cb) {
    web_ui.platformViewRegistry.registerViewFactory(viewId, cb);
  }
}
```

In here, we are importing `dart:ui_web`
(which only compiles on web devices)
and performing the `registerViewFactory`.

And that's it!
We've successfully created a web embed
that embeds image on the web!

To recap:
- we export the `defaultEmbedBuildersWeb`
array variable with our custom web embed
`ImageEmbedBuilderWeb()`.
- `ImageEmbedBuilderWeb` class returns a widget
that shows an HTML image in the editor.
For this to work, we need to call `registerViewFactory` 
from the `dart:web_ui` package.
- because `dart:web_ui` only compiles for the web,
we need to import `dart:ui` and `dart:web_ui` 
separately from different files
that perform this register.
This will ensure the packages
are conditionally imported 
and compilation always work,
regardless of the target platform! 

To recap, here's how `lib/web_embeds/web_embeds.dart` should look like.

```dart
import 'package:app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_html/html.dart' as html;

// Conditionally importing the PlatformViewRegistry class according to the platform
import 'mobile_platform_registry.dart' if (dart.library.html) 'web_platform_registry.dart' as ui_instance;

/// Class used to conditionally register the view factory.
/// For more information, check https://github.com/flutter/flutter/issues/41563#issuecomment-547923478.
class PlatformViewRegistryFix {
  void registerViewFactory(PlatformService platformService, imageURL, dynamic cbFnc) {
    if (platformService.isWebPlatform()) {
      ui_instance.PlatformViewRegistry.registerViewFactory(
        imageURL,
        cbFnc,
      );
    }
  }
}

/// Class that conditionally registers the `platformViewRegistry`.
class ImageUniversalUI {
  PlatformViewRegistryFix platformViewRegistry = PlatformViewRegistryFix();
}

/// Custom embed for images to work on the web.
class ImageEmbedBuilderWeb extends EmbedBuilder {
  @override
  String get key => BlockEmbed.imageType;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final imageUrl = node.value.data;
    if (isImageBase64(imageUrl)) {
      // TODO: handle imageUrl of base64
      return const SizedBox();
    }
    final size = MediaQuery.of(context).size;

    // This is needed for images to be correctly embedded on the web.
    ImageUniversalUI().platformViewRegistry.registerViewFactory(PlatformService(), imageUrl, (viewId) {
      return html.ImageElement()
        ..src = imageUrl
        ..style.height = 'auto'
        ..style.width = 'auto';
    });

    // Rendering responsive image
    return Padding(
      padding: EdgeInsets.only(
        right: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
            ? size.width * 0.5
            : (ResponsiveBreakpoints.of(context).equals('4K'))
                ? size.width * 0.75
                : size.width * 0.2,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: HtmlElementView(
          viewType: imageUrl,
        ),
      ),
    );
  }
}

/// List of default web embed builders.
List<EmbedBuilder> get defaultEmbedBuildersWeb => [
      ImageEmbedBuilderWeb(),
    ];
```


### 4.4 Creating the toolbar

Now that we've defined the editor
and the appropriate web embeds so images work on web devices,
it's time to create **our toolbar**.

This toolbar will have some options for the person
to stylize the text (e.g make it bold or italic)
and add images 
(which make use of the embed we've just created for web devices).
We can add custom buttons if we want to.

To define our toolbar, 
we're going to be using 
[`QuillToolbar`](https://github.com/singerdmx/flutter-quill/blob/36d72c1987f0cb8d6c689c12542600364c07e20f/lib/src/widgets/toolbar.dart#L53).
This class has an option where one can define a toolbar easily,
using `QuillToolbar.basic()`.
This will render a myriad of features
that, for this example, we do not need.

Because we only want a handful of features,
we're going to define `QuillToolbar` normally.

Go back to `_buildEditor()`
and continue where you left off.
Let's instantiate our editor.

```dart
    // Toolbar definitions
    const toolbarIconSize = 18.0;
    final embedButtons = FlutterQuillEmbeds.buttons(
      // Showing only necessary default buttons
      showCameraButton: false,
      showFormulaButton: false,
      showVideoButton: false,
      showImageButton: true,

      // `onImagePickCallback` is called after image (from any platform) is picked
      onImagePickCallback: _onImagePickCallback,

      // `webImagePickImpl` is called after image (from web) is picked and then `onImagePickCallback` is called
      webImagePickImpl: _webImagePickImpl,

      // defining the selector (we only want to open the gallery whenever the person wants to upload an image)
      mediaPickSettingSelector: (context) {
        return Future.value(MediaPickSetting.Gallery);
      },
    );

    // Instantiating the toolbar
    final toolbar = QuillToolbar(
      afterButtonPressed: _focusNode.requestFocus,
      children: [
        HistoryButton(
          icon: Icons.undo_outlined,
          iconSize: toolbarIconSize,
          controller: _controller!,
          undo: true,
        ),
        HistoryButton(
          icon: Icons.redo_outlined,
          iconSize: toolbarIconSize,
          controller: _controller!,
          undo: false,
        ),
        ToggleStyleButton(
          attribute: Attribute.bold,
          icon: Icons.format_bold,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        ToggleStyleButton(
          attribute: Attribute.italic,
          icon: Icons.format_italic,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        ToggleStyleButton(
          attribute: Attribute.underline,
          icon: Icons.format_underline,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        ToggleStyleButton(
          attribute: Attribute.strikeThrough,
          icon: Icons.format_strikethrough,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        for (final builder in embedButtons) builder(_controller!, toolbarIconSize, null, null),
      ],
    );
```

Let's go over piece by piece 😃.

- **`embedButtons`** is a class
[`FlutterQuillEmbeds`](https://github.com/singerdmx/flutter-quill/blob/36d72c1987f0cb8d6c689c12542600364c07e20f/flutter_quill_extensions/lib/flutter_quill_extensions.dart#L22)
from the `flutter_quill_extensions` package.
With this class,
we can define the buttons pertaining
to embeds that are shown in the editor.
It has a few parameters that we can set.

  - `showCameraButton`, a boolean where we can set
if the camera button is shown.
  - `showFormulaButton`, a boolean where we can set
if the formula button is shown.
This allows mathematical expressions to be created.
  - `showVideoButton`, a boolean where we can set
if the video button is shown.
This will allow embedding videos.
**Remember that you'll need a video web embed similar to the image embed we've created for this to work on the web**.
You'll also need to implement the `onVideoPickCallback`
and `webVideoPickImpl` for this to work.
  - `showImageButton`, a boolean where we can set
if the image button is shown.
This will allow embedding images.
**Remember that you'll need an image web embed for this to work on the web.**.
You'll also need to implement the 
`onImagePickCallback` and `webImagePickImpl` for this to properly work.
  - `onImagePickCallback` is called after image (from any platform)
is picked.
  - `webImagePickImpl` is called after image is picked on web devices.
`onImagePickCallback` is called after this function.
  - `mediaPickSettingSelector` is where we can define
whether we want to show a modal asking the person
if they want to add media from the gallery or from a web link.
In our case, we just want to show the gallery.

This array of embed buttons are used
in the definition of the toolbar `QuillToolbar`,
which is made right afterwards.

- the `afterButtonPressed` parameter 
is used as callback to request *back* the focus
from the keyboard.
- the `children` will render buttons.
We've defined the embed buttons prior
and we are rendering them 
in `for (final builder in embedButtons) builder(_controller!, toolbarIconSize, null, null),`.
In addition to this, 
we are adding a few more buttons
to stylize text
and undo/redo text changes operations.
  - `HistoryButton` to undo/redo changes
made to the editor.
This is made because every change is tracked in the `Delta` document.
  - `ToggleStyleButton` is used to stylize text.
We can make text **bold**, *italic*,
<ins>underline</ins> and ~~strikethrough~~.


We've mentioned the functions 
`onImagePickCallback`
and `webImagePickImpl` when defining
the array of custom embed buttons.
However, we haven't yet defined them.
Let's do that!


#### 4.4.1 Defining image embed callbacks

In `HomePageState`, 
add the two needed functions.

```dart
  Future<String> _onImagePickCallback(File file) async {

    if (!widget.platformService.isWebPlatform()) {
      // Copies the picked file from temporary cache to applications directory
      final appDocDir = await getApplicationDocumentsDirectory();
      final copiedFile = await file.copy('${appDocDir.path}/${basename(file.path)}');
      return copiedFile.path.toString();
    } else {
      // TODO: This doesn't work on the web yet.
      // This is because Flutter on the web (browsers) does not have the path of local files.

      // But because of the web embeds we've created, we *know* this works.
      // You can try returning a link to see it working.

      //return "https://pbs.twimg.com/media/EzmJ_YBVgAEnoF2?format=jpg&name=large";

      return file.path;
    }
  }

  Future<String?> _webImagePickImpl(OnImagePickCallback onImagePickCallback) async {
    // Lets the user pick one file; files with any file extension can be selected
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    // The result will be null, if the user aborted the dialog
    if (result == null || result.files.isEmpty) {
      return null;
    }

    // Read file as bytes (https://github.com/miguelpruivo/flutter_file_picker/wiki/FAQ#q-how-do-i-access-the-path-on-web)
    final platformFile = result.files.first;
    final bytes = platformFile.bytes;

    if (bytes == null) {
      return null;
    }

    final file = File.fromRawPath(bytes);
    return onImagePickCallback(file);
  }
```

- **`_onImagePickCallback`** returns the path of the file
so it is correctly rendered on the editor.
We need to define the path for both mobile and web versions.
This is because the custom web embed we've created earlier 
`ImageEmbedBuilderWeb` **uses this file path to render the image**.
However, currently, this doesn't work on the web
because *paths aren't accessible from browsers*,
as they provide fake paths.
See https://stackoverflow.com/questions/66032845/get-file-path-from-system-directory-using-flutter-web-chrome-to-read-file-cont 
for more context.

- **`_webImagePickImpl`** is called after the person
picks an image in a browser.
We use this to open the gallery so the person
clicks on the image they want to embed
(by using [`file-picker`](https://pub.dev/packages/file_picker))
and returning the `File` object
and pass it to `onImagePickCallback()`.


### 4.5 Finishing editor

Now that we have the proper callback implemented,
all that's left is finish our `_buildEditor()` function! 😊

All we need to do is return the widget
that will render the editor on the page.

```dart
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 15,
            child: Container(
              key: quillEditorKey,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: quillEditor,
            ),
          ),
          Container(child: toolbar),
        ],
      ),
    );
```

As you can see, we are using the `quillEditor`
inside the `Expanded` widget to take all the space.
Below it, we render a `Container`
with the `toolbar` we've defined.

And that's it!

Your `lib/home_page.dart` file should now look like so:

```dart
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

import 'web_embeds/web_embeds.dart';

const quillEditorKey = Key('quillEditorKey');

/// Types of selection that person can make when triple clicking
enum _SelectionType {
  none,
  word,
}

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

  /// Selection types for triple clicking
  _SelectionType _selectionType = _SelectionType.none;

  @override
  void initState() {
    super.initState();
    _initializeText();
  }

  /// Initializing the [Delta](https://quilljs.com/docs/delta/) document with sample text.
  Future<void> _initializeText() async {
    // final doc = Document()..insert(0, 'Just a friendly empty text :)');
    final doc = Document();
    setState(() {
      _controller = QuillController(document: doc, selection: const TextSelection.collapsed(offset: 0));
    });
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
      body: _buildEditor(context),
    );
  }

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

  /// Build the `flutter-quill` editor to be shown on screen.
  Widget _buildEditor(BuildContext context) {
    // Default editor (for mobile devices)
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

    // Alternatively, the web editor version is shown  (with the web embeds)
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

    // Toolbar definitions
    const toolbarIconSize = 18.0;
    final embedButtons = FlutterQuillEmbeds.buttons(
      // Showing only necessary default buttons
      showCameraButton: false,
      showFormulaButton: false,
      showVideoButton: false,
      showImageButton: true,

      // `onImagePickCallback` is called after image (from any platform) is picked
      onImagePickCallback: _onImagePickCallback,

      // `webImagePickImpl` is called after image (from web) is picked and then `onImagePickCallback` is called
      webImagePickImpl: _webImagePickImpl,

      // defining the selector (we only want to open the gallery whenever the person wants to upload an image)
      mediaPickSettingSelector: (context) {
        return Future.value(MediaPickSetting.Gallery);
      },
    );

    // Instantiating the toolbar
    final toolbar = QuillToolbar(
      afterButtonPressed: _focusNode.requestFocus,
      children: [
        HistoryButton(
          icon: Icons.undo_outlined,
          iconSize: toolbarIconSize,
          controller: _controller!,
          undo: true,
        ),
        HistoryButton(
          icon: Icons.redo_outlined,
          iconSize: toolbarIconSize,
          controller: _controller!,
          undo: false,
        ),
        ToggleStyleButton(
          attribute: Attribute.bold,
          icon: Icons.format_bold,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        ToggleStyleButton(
          attribute: Attribute.italic,
          icon: Icons.format_italic,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        ToggleStyleButton(
          attribute: Attribute.underline,
          icon: Icons.format_underline,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        ToggleStyleButton(
          attribute: Attribute.strikeThrough,
          icon: Icons.format_strikethrough,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        for (final builder in embedButtons) builder(_controller!, toolbarIconSize, null, null),
      ],
    );

    // Rendering the final editor + toolbar
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 15,
            child: Container(
              key: quillEditorKey,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: quillEditor,
            ),
          ),
          Container(child: toolbar),
        ],
      ),
    );
  }

  // Renders the image picked by imagePicker from local file storage
  // You can also upload the picked image to any server (eg : AWS s3
  // or Firebase) and then return the uploaded image URL.
  Future<String> _onImagePickCallback(File file) async {
    //return "https://pbs.twimg.com/media/EzmJ_YBVgAEnoF2?format=jpg&name=large";
    if (!widget.platformService.isWebPlatform()) {
      // Copies the picked file from temporary cache to applications directory
      final appDocDir = await getApplicationDocumentsDirectory();
      final copiedFile = await file.copy('${appDocDir.path}/${basename(file.path)}');
      return copiedFile.path.toString();
    } else {
      // TODO: This will fail on web
      // Might have to upload to S3 or embed a canvas like https://stackoverflow.com/questions/71798042/flutter-how-do-i-write-a-file-to-local-directory-with-path-provider.

      return file.path;
    }
  }

  /// Callback that is called after an image is picked whilst on the web platform.
  Future<String?> _webImagePickImpl(OnImagePickCallback onImagePickCallback) async {
    // Lets the user pick one file; files with any file extension can be selected
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    // The result will be null, if the user aborted the dialog
    if (result == null || result.files.isEmpty) {
      return null;
    }

    // Read file as bytes (https://github.com/miguelpruivo/flutter_file_picker/wiki/FAQ#q-how-do-i-access-the-path-on-web)
    final platformFile = result.files.first;
    final bytes = platformFile.bytes;

    if (bytes == null) {
      return null;
    }

    final file = File.fromRawPath(bytes);

    return onImagePickCallback(file);
  }
}
```

Congratulations! 🥳

We just got ourselves a fancy editor working in our application!



## 5. Getting images to work on the web

As we've mentioned before,
we currently can't get the images
to correctly show in the editor
upon prompting the person to select an image.

As we've stated before,
the reason images don't show up on the web
is because we don't have the concept
of **local file paths**. 
So the browser is not able to render the image.

However, we can leverage [`dwyl-imgup`](https://github.com/dwyl/imgup)
to **upload the image**
and **render it according to the provided URL**
where the image is hosted.

Let's get to work!


### 5.1 Install the needed dependencies

Before doing this,
let's install some dependencies.
Add these lines to `pubspec.yaml`,
in the `dependencies` section.

```yaml
  http: ^0.13.6
  mime: ^1.0.4
  http_parser: ^4.0.2
```

- [**`http`**](https://pub.dev/packages/http): 
library to make HTTP requests.
- [**`mime`**](https://pub.dev/packages/mime): 
determines the MIME type definition of media types.
- [**`http_parser`**](https://pub.dev/packages/http_parser): 
library for parsing and serializing HTTP-related formats.
Will be used to parse the response from `imgup`.


### 5.2 Change the `_webImagePickImpl` callback function

The `_webImagePickImpl` callback
is invoked when the person picks an image
on the web platform.

Therefore, we are going to use the
**array of bytes**
and use it to get the MIME type of the file
and create a 
[`MultipartRequest`](https://pub.dev/documentation/http/latest/http/MultipartRequest-class.html)
to the `imgup` server.

```dart
  Future<String?> _webImagePickImpl(OnImagePickCallback onImagePickCallback) async {
    // Lets the user pick one file; files with any file extension can be selected
    final result = await ImageFilePicker().pickImage();

    // The result will be null, if the user aborted the dialog
    if (result == null || result.files.isEmpty) {
      return null;
    }

    // Read file as bytes (https://github.com/miguelpruivo/flutter_file_picker/wiki/FAQ#q-how-do-i-access-the-path-on-web)
    final platformFile = result.files.first;
    final bytes = platformFile.bytes;

    if (bytes == null) {
      return null;
    }

    // Make HTTP request to upload the image to the file
    const apiURL = 'https://imgup.fly.dev/api/images';
    final request = http.MultipartRequest('POST', Uri.parse(apiURL));

    final httpImage = http.MultipartFile.fromBytes('image', bytes,
        contentType: MediaType.parse(lookupMimeType('', headerBytes: bytes)!), filename: platformFile.name);
    request.files.add(httpImage);

    // Check the response and handle accordingly
    return http.Client().send(request).then((response) async {
      if (response.statusCode != 200) {
        return null;
      }

      final responseStream = await http.Response.fromStream(response);
      final responseData = json.decode(responseStream.body);
      return responseData['url'];
    });
  }

```

We receive the response from `imgup` and,
depending on whether the upload was successful or not,
we retrieve the `url` where the image is hosted.

If the upload fails,
we return `null`,
the same way we return `null` 
when the person cancels the upload.
Therefore, nothing happens.


### 5.3 Change the `_onImagePickCallback` callback function

Now that `_webImagePickImpl` isn't invoking `_onImagePickCallback`,
we don't need to conditionally check 
if the platform is web-based or not.

Therefore, change it to the following.

```dart
  Future<String> _onImagePickCallback(File file) async {
      final appDocDir = await getApplicationDocumentsDirectory();
      final copiedFile = await file.copy('${appDocDir.path}/${basename(file.path)}');
      return copiedFile.path.toString();
  }
```

Because the function is only called on mobile devices,
we know for sure that it will run correctly every time.



## 6. Give the app a whirl

Now let's see our app in action!
If you run the application, 
you should see something like this!

https://github.com/dwyl/flutter-wysiwyg-editor-tutorial/assets/17494745/e859328e-3ae4-4195-b9d6-54d3490cfba1

As you can see, 
the person can:

- triple select to toggle between 
none, word and paragraph.
- add images and resize them accordingly.
- add text, undo and redo operations.
- stylize the text accordingly.

There are *many* more options one can implement
using `flutter-quill`, 
including font-size,
indentation,
highlighting and many more!
Please check https://github.com/singerdmx/flutter-quill
for this.

> [!NOTE]
>
> If you are having trouble executing on an iPhone device,
> please follow the instructions in https://github.com/dwyl/learn-flutter#ios.
>
> In our case,
> we had to add the following lines 
> to `ios/Runner/Info.plist`.
>
> ```yaml
> <key>NSPhotoLibraryAddUsageDescription</key>
> <string>Needs gallery access to embed images</string>
> <key>NSPhotoLibraryUsageDescription</key>
> <string>Needs gallery access to embed images</string>
> <key>UIApplicationSupportsIndirectInputEvents</key>
> <true/>
> ```
>
> You need to do this through `XCode`. 
> Check the following image to add these lines through `XCode`.
> If you don't, Apple's binary decoder might have some trouble
> interpreting your changed `Info.plist` file.
>
> ![xcode](https://github.com/dwyl/flutter-wysiwyg-editor-tutorial/assets/17494745/49274c28-2e1a-4dca-9195-73160a6f936f)


## 7. Extending our `toolbar`

As it stands, our toolbar offers limited options.
We want it to do more! 
Let's add these features so the person using our app
is free to customize the text further 😊.


### 7.1 Header font sizes

Let's start by adding different **header font sizes**.
This will allow the person to better organize their items.
We will provide three different headers (`h1`, `h2` and `h3`),
each one with decreasing sizes and vertical spacings.

These subheadings will be toggleable from the toolbar.

Let's add the buttons to the toolbar.
Locate the `toolbar` variable (with type `QuillToolbar`)
inside the `_buildEditor()` function.

In the `children` parameter, 
add the [`SelectHeaderStyleButton`](https://github.com/singerdmx/flutter-quill/blob/09113cbc90117c7d9967ed865d132e832a219832/lib/src/widgets/toolbar/select_header_style_button.dart#L11)
after the `HistoryButton`s. 
Like so:

```dart
final toolbar = QuillToolbar(
  afterButtonPressed: _focusNode.requestFocus,
  children: [
    HistoryButton(
      icon: Icons.undo_outlined,
      iconSize: toolbarIconSize,
      controller: _controller!,
      undo: true,
    ),
    HistoryButton(
      icon: Icons.redo_outlined,
      iconSize: toolbarIconSize,
      controller: _controller!,
      undo: false,
    ),

    // Add this button
    SelectHeaderStyleButton(
      controller: _controller!,
      axis: Axis.horizontal,
      iconSize: toolbarIconSize,
      attributes: const [Attribute.h1, Attribute.h2, Attribute.h3],
    ),

    //  rest of the buttons
  ]
)
```

With this button, we will be able to define the subheadings
we want to make available to the person.
The `axis` parameter defines whether they should be sorted
horizontally or vertically.
The `attributes` field defines how many subheadings we want to add.
In our case, we'll just define three.

Now we need to **define the styling for the headings**.
For this, we need to change the `customStyles` field
of the `quillEditor` variable 
(from the [`QuillEditor`](https://github.com/singerdmx/flutter-quill/blob/09113cbc90117c7d9967ed865d132e832a219832/lib/src/widgets/editor.dart#L149) class )
inside `_buildEditor()`.

We are going to make these changes to both
mobile and web `quillEditor` variables.
Locate them at check the `customStyles` field.
Change it to the following:

```dart
customStyles: DefaultStyles(
        // Change these -------------
        h1: DefaultTextBlockStyle(
          const TextStyle(
            fontSize: 32,
            color: Colors.black,
            height: 1.15,
            fontWeight: FontWeight.w600,
          ),
          const VerticalSpacing(16, 0),
          const VerticalSpacing(0, 0),
          null,
        ),
        h2: DefaultTextBlockStyle(
          const TextStyle(
            fontSize: 24,
            color: Colors.black87,
            height: 1.15,
            fontWeight: FontWeight.w600,
          ),
          const VerticalSpacing(8, 0),
          const VerticalSpacing(0, 0),
          null,
        ),
        h3: DefaultTextBlockStyle(
          const TextStyle(
            fontSize: 20,
            color: Colors.black87,
            height: 1.25,
            fontWeight: FontWeight.w600,
          ),
          const VerticalSpacing(8, 0),
          const VerticalSpacing(0, 0),
          null,
        ),
        // Change these -------------
        // ....
),
```

We have changed the pre-existing `h1` field
and added the `h2` and `h3` fields as well,
specifying different font weights and sizes and colour
for each subheading.

And that's it!
That's all you need to do to change the subheadings!

Awesome job! 👏


### 7.2 Adding emojis

Let's add a button that will allow people to add emojis!
This is useful for both mobile and web platforms 
(it's more relevant on the latter,
as there is not a native emoji keyboard to choose from).

You might be wondering that, for mobile applications,
having a dedicated button to insert emojis is *redudant*,
because iOS and Android devices offer a native keyboard
in which you can select an emoji and insert it as text.

However, we're doing this for two purposes:
- the emoji button is meant to be introduced as a separate feature
and as a custom button to be shown.
See https://github.com/dwyl/app/issues/275#issuecomment-1646862277 for more context.
- showing the native keyboard emoji selection does not work on all platforms in Flutter.
If this was the case, we could have easily used a package
like [`keyboard_emoji_picker`](https://pub.dev/packages/keyboard_emoji_picker).

So let's do this!

First, let's install the package we'll use
to select emojis.
Simply run `flutter pub add emoji_picker_flutter` 
and all the dependencies will be installed.

Now that's done with, let's start by creating our emoji picker.
Let's first create our widget in a separate file.
Inside `lib`, 
create a file called `emoji_picker_widget.dart`.

```dart
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Emoji picker widget that is offstage.
/// Shows an emoji picker when [offstageEmojiPicker] is `false`.
class OffstageEmojiPicker extends StatefulWidget {
  /// `QuillController` controller that is passed so the controller document is changed when emojis are inserted.
  final QuillController? quillController;

  /// Determines if the emoji picker is offstage or not.
  final bool offstageEmojiPicker;

  const OffstageEmojiPicker({required this.offstageEmojiPicker, this.quillController, super.key});

  @override
  State<OffstageEmojiPicker> createState() => _OffstageEmojiPickerState();
}

class _OffstageEmojiPickerState extends State<OffstageEmojiPicker> {
  /// Returns the emoji picker configuration according to screen size.
  Config _buildEmojiPickerConfig(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)) {
      return const Config(emojiSizeMax: 32.0, columns: 7);
    }

    if (ResponsiveBreakpoints.of(context).equals(TABLET)) {
      return const Config(emojiSizeMax: 24.0, columns: 10);
    }

    if (ResponsiveBreakpoints.of(context).equals(DESKTOP)) {
      return const Config(emojiSizeMax: 16.0, columns: 15);
    }

    return const Config(emojiSizeMax: 16.0, columns: 30);
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: widget.offstageEmojiPicker,
      child: SizedBox(
        height: 250,
        child: EmojiPicker(
          onEmojiSelected: (category, emoji) {
            if (widget.quillController != null) {
              // Get pointer selection and insert emoji there
              final selection = widget.quillController?.selection;
              widget.quillController?.document.insert(selection!.end, emoji.emoji);

              // Update the pointer after the emoji we've just inserted
              widget.quillController?.updateSelection(TextSelection.collapsed(offset: selection!.end + emoji.emoji.length), ChangeSource.REMOTE);
            }
          },
          config: _buildEmojiPickerConfig(context),
        ),
      ),
    );
  }
}
```

Let's unpack what we've just implemented.
The widget we've create is a **stateful widget**
that receives two parameters:

- `quillController` pertains to the `QuillController` 
object related ot the editor.
This controller is used to access the document
so the emoji can be inserted.
- `offstageEmojiPicker` is a boolean
that determines if the widget is meant to be offstage (hidden)
or not.

In the `build()` function,
we use the [`Offstage`](https://api.flutter.dev/flutter/widgets/Offstage-class.html)
class to wrap the widget.
This will make it possible to show and hide the emoji picker accordingly.

We then use the `EmojiPicker` widget
from the package we've just downloaded.
In this widget, we define two parameters:

- `config`, pertaining to the emoji picker configuration.
We use the `_buildEmojiPickerConfig()` function
to conditionally change the emoji picker dimensions
according to the size of the screen.
- `onEmojiSelected`, which is called after an emoji is selected by the person.
In this, we use the passed `quillController` to get the position 
of the pointer and the document.
With these two, we add the selected emoji
and update the pointer to *after* the emoji that was inserted.
This will allow adding consecutive emojis properly
and maintain the pointer index aligned.

Now all that's left is to
**use our newly created widget** in our homepage!
Head over to `lib/home_page.dart`,
and add a new field inside `HomePageState`.

```dart
  /// Show emoji picker
  bool _offstageEmojiPickerOffstage = true;
```

In the same class,
we're going to create a callback function
that is to be called every time the person 
clicks on the emoji toolbar button 
(don't worry, we'll create this button in a minute).
This function will close the keyboard
and open the emoji picker widget we've just created.

```dart
  void _onEmojiButtonPressed(BuildContext context) {
    final isEmojiPickerShown = !_offstageEmojiPickerOffstage;

    // If emoji picker is being shown, we show the keyboard and hide the emoji picker.
    if (isEmojiPickerShown) {
      _focusNode.requestFocus();
      setState(() {
        _offstageEmojiPickerOffstage = true;
      });
    }

    // Otherwise, we do the inverse.
    else {
      // Unfocusing when the person clicks away. This is to hide the keyboard.
      // See https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
      // and https://www.youtube.com/watch?v=MKrEJtheGPk&t=40s&ab_channel=HeyFlutter%E2%80%A4com.
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      }

      setState(() {
        _offstageEmojiPickerOffstage = false;
      });
    }
  }
```

We are toggling the `_offstageEmojiPickerOffstage` field
by calling `setState()`, thus causing a re-render
and properly toggling the emoji picker.

Now all we need to do is
**add the button to the toolbar to toggle the emoji picker**
and **add the offstage emoji picker to the widget tree**.

Let's do the first one.
Locate `_buildEditor` and find the `toolbar` 
(class `QuillToolbar`) definition.
In the `children` parameter,
we're going to add a 
[`CustomButton`](https://github.com/singerdmx/flutter-quill/blob/09113cbc90117c7d9967ed865d132e832a219832/lib/src/widgets/toolbar/custom_button.dart#L6)
to these buttons.

```dart
final toolbar = QuillToolbar(
  afterButtonPressed: _focusNode.requestFocus,
  children: [
    CustomButton(
      onPressed: () => _onEmojiButtonPressed(context),
      icon: Icons.emoji_emotions,
      iconSize: toolbarIconSize,
    ),

    // Other buttons...
  ]
)
```

As you can see, we are calling the `_onEmojiButtonPressed` function
we've implemented every time the person taps on the emoji button.

At the end of the function, we're going to return
the editor with the `OffstageEmojiPicker` widget
we've initially created.

```dart
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 15,
            child: Container(
              key: quillEditorKey,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: quillEditor,
            ),
          ),
          Container(child: toolbar),

          // Add this ---
          OffstageEmojiPicker(
            offstageEmojiPicker: _offstageEmojiPickerOffstage,
            quillController: _controller,
          ),
        ],
      ),
    );
```

And that's it!
We've just successfully added an emoji picker
that is correctly toggled when clicking the appropriate button in the toolbar,
*and* adding the correct changes to the Delta document of the Quill editor.


<p align="center">
  <img width="300" src="https://github.com/dwyl/flutter-wysiwyg-editor-tutorial/assets/17494745/e5cc28fe-5ddf-43da-a820-e369a7622471" />
</p>


### 7.3 Adding embeddable links

This one's the easiest.
`flutter-quill` already provides a specific button
which we can invoke that'll do all the work for us,
including formatting, embedding the link
and properly adding the change to the controller's document.

Simply add the following snippet of code
to the `children` field of the `toolbar`
variable you've worked with earlier.

```dart
       // ....
       ToggleStyleButton(
          attribute: Attribute.strikeThrough,
          icon: Icons.format_strikethrough,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),

        // Add this button
        LinkStyleButton(
          controller: _controller!,
          iconSize: toolbarIconSize,
          linkRegExp: RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+'),
        ),

        for (final builder in embedButtons) builder(_controller!, toolbarIconSize, null, null),
```

And that's it! 
We're using the 
[`LinkStyleButton`](https://github.com/singerdmx/flutter-quill/blob/09113cbc90117c7d9967ed865d132e832a219832/lib/src/widgets/toolbar/link_style_button.dart#L13)
class with a regular expression that we've defined ourselves
that will only allow a link to be added if it's valid.


# A note about testing 🧪

We try to get tests covering 100% of the lines of code 
in every repository we make.
However, it is worth mentioning that,
due to lack of documentation 
and testing from `flutter-quill`,
it becomes difficult to do so in this project.

This is why the coverage is not at a 100% in this repo.
This is mainly because we aren't able to simulate
a person choosing an image when the gallery pops up
in `widgetTest`s. 

Because on mobile devices, 
`flutter-quill` uses [`image-picker`](https://pub.dev/packages/image_picker)
under the hood,
it is impossible to *[directly mock it](https://stackoverflow.com/questions/76586920/mocking-imagepicker-in-flutter-integration-tests-not-working)*.

In addition to this,
we have inclusively
tried overriding its behaviour with 
[platform channels](https://docs.flutter.dev/testing/plugins-in-tests#mock-the-platform-channel)
and using [`setMockMethodCallHandler`](https://stackoverflow.com/questions/52028969/testing-flutter-code-that-uses-a-plugin-and-platform-channel),
but to no avail.

We've opened an issue on `flutter-quill` about this.
You can visit it in https://github.com/singerdmx/flutter-quill/issues/1389
if you want more information about this issue.

Therefore, pieces of code related to image and video embeds
aren't being covered by the tests.
This includes functions like 
`_onImagePickCallback`
and `_webImagePickImpl`.
It also includes custom web embeds, 
which means the class `ImageEmbedBuilderWeb`
is also not covered.

# Alternative editors

There are a myriad of alternative editors that you can use in Flutter.
We've chosen this one because it offers us the option
to get [`Delta` files](https://quilljs.com/docs/delta/), 
which allows us to see text contents and changes throughout its lifetime.

However, there are other editors that you may consider:
- [`super_editor`](https://pub.dev/packages/super_editor)
- [`appflowy_editor`](https://github.com/AppFlowy-IO/appflowy-editor)
- [`visual-editor`](https://github.com/visual-space/visual-editor) (a fork of `flutter-quill`)

We've created a specific folder that will help you migrate
the code you've *just implemented* 
from `flutter-quill` to `visual-editor`.

You can check the finished migrated application
and the guide in [`alt_visual-editor`](./alt_visual_editor/).


# Found this useful?

If you found this example useful, 
please ⭐️ the GitHub repository
so we (_and others_) know you liked it!

Any questions or suggestions? Do not hesitate to 
[open new issues](https://github.com/dwyl/flutter-wysiwyg-editor-tutorial/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc)!

Thank you!

