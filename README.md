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
