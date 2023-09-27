# Migrating from `flutter-quill` to `visual-editor`

> [!WARNING]
>
> At the time of writing,
> `visual-editor` is still in development and **does not offer all the features `flutter-quill` does**.
> There are a few bugs that are noticeable (more specifically, text selection) 
> that do not work properly on mobile devices.
>
> We will use a **fork of `visual-editor`** - https://github.com/dwyl/visual-editor in this guide.
> This is because the PR that was opened to `visual-editor` has need yet been merged
> (https://github.com/visual-space/visual-editor/pull/237).
> Once it is merged, we'll update this dependency accordingly.
> If you see that this PR has been merged and this document has yet to be updated, 
> [please open an issue](https://github.com/dwyl/flutter-wysiwyg-editor-tutorial/issues/).


[`visual-editor`](https://github.com/visual-space/visual-editor) is a fork of `flutter-quill` that,
unlike the latter,
is actively maintained.
They've done a complete refactor of `flutter-quill`, 
documented the code and made it easier to contribute to.
Because it offers some new features that can be easily integrated into your app,
we've created this small migration guide so you can leverage this library 
from the app you've just implemented with `flutter-quill`.

> [!NOTE]
>
> `visual-editor` provides a migration guide.
> Check it in https://github.com/visual-space/visual-editor.


# 0. Pre-requisites

This guide builds upon the app that was created in 
[`README.md`](../README.md).
Make sure you have completed the tutorial first
until the [`6. Give the app a whirl`](README.md#6-give-the-app-a-whirl) chapter
and head back here so the code is in the same state.

If you've completed the rest of the chapters,
it's okay! 
There principles are still the same 🙂.


# 1. Install dependencies

Head over to `pubspec.yaml` 
and change the `dependencies` section to the following.

```yaml
dependencies:
  flutter:
    sdk: flutter

  file_picker: ^5.3.3
  universal_io: ^2.2.2
  responsive_framework: ^1.1.0
  universal_html: ^2.2.3
  path: ^1.8.3
  path_provider: ^2.1.0
  http: ^1.1.0
  mime: ^1.0.4
  http_parser: ^4.0.2

  visual_editor:
    git:
      url: https://github.com/dwyl/visual-editor
      ref: update_dependencies#236
```

- we've removed `flutter_quill` and `flutter_quill_extensions`.
- we've upgraded `http` to version `1.1.0`.
- we've installed `visual_editor` through the aforementioned fork.
Normally you'll follow the guidelines in [`visual_editor`](https://github.com/visual-space/visual-editor#getting-started).


# 2. Delete `web_embeds`

With `visual-editor`, we do not need to use separate web embeds
to make it work on the web.
So you can safely delete 🗑️
`mobile_platform_registry.dart`,
`web_embeds.dart`
and `web_platform_registry.dart`,
as they no longer will be needed.


# 3. Update import, rename classes and delete unnecessary code

The classes from `visual_editor`,
although similar to `flutter-quill`,
have different constructors and some will differ,
so renaming classes won't work sometimes.

But let's do that first! 
We'll deal with each issue along the way.
Let's start with replacing the imports.
Change the imports like so:

> `import 'package:flutter_quill/flutter_quill.dart';` -> `import 'package:visual_editor/visual-editor.dart';`

Add `import 'package:visual_editor/document/models/attributes/attributes.model.dart';`, as well.
We are going to need it.

You can now delete any `flutter_quill` and `flutter_quill_extensions` import.
You can also delete `import 'web_embeds/web_embeds.dart';`, 
since it no longer exists.

Now, it's time to rename some classes!
Follow the next steps.

> `QuillEditor` -> `VisualEditor`
> `QuillController` -> `EditorController`
> `QuillToolbar` -> `EditorToolbar`
> `DefaultTextBlockStyle` -> `TextBlockStyleM`
> `DefaultStyles` -> `EditorStylesM`
> `Document` -> `DeltaDocM`

Awesome!

The last thing we need to do is 
deleting our `_SelectionType` methods and classes.
We have used these to handle the triple click selection behaviour
on tap up.
We don't need this any more.

Therefore:
- delete the `_SelectionType` enum.
- delete `_SelectionType _selectionType = _SelectionType.none;` field from `HomePageState`.
- delete the `_onTripleClickSelection()` function inside `HomePageState`.
  
Great job! 🥳

We are now ready to 
change how our `visual-editor` classes are constructed!


# 4. Update `visual-editor` classes invocations

**From now on, we'll only be working inside the `HomePageState` class.**

Let's start by changing our `_initializeText` function.
`EditorController` now only receives one argument,
which is the `document`.
Change it to look like so:

```dart
  Future<void> _initializeText() async {
    final doc = DeltaDocM();
    setState(() {
      _controller = EditorController(
        document: doc,
      );
    });
  }
```


## 4.1 `VisualEditor`

Let's move to the `VisualEditor`.
We previously used `QuillEditor`,
where we had a myriad of parameters we set.
These parameters *are now more organised*, 
and will be changed like so.

```dart
    Widget quillEditor = VisualEditor(
      controller: _controller!,
      scrollController: ScrollController(),
      focusNode: _focusNode,
      config: EditorConfigM(
        scrollable: true,
        autoFocus: false,
        readOnly: false,
        placeholder: 'Write what\'s on your mind.',
        enableInteractiveSelection: true,
        expands: false,
        padding: EdgeInsets.zero,
        customStyles: const EditorStylesM(
          h1: TextBlockStyleM(
            TextStyle(
              fontSize: 32,
              color: Colors.black,
              height: 1.15,
              fontWeight: FontWeight.w300,
            ),
            VerticalSpacing(top: 16, bottom: 0),
            VerticalSpacing(top: 0, bottom: 0),
            VerticalSpacing(top: 16, bottom: 0),
            null,
          ),
          sizeSmall: TextStyle(fontSize: 9),
        ),
      ),
    );
```

As you can see, most of the configuration
is now done under the `config` parameter,
which receives an `EditorConfigM`.

- `enableSelectionToolbar` becomes `enableInteractiveSelection`.
- we define the `customStyles` with the `EditorStyleM` class.
In this case, we are defining the `h1` field with `TextBlockStyleM` class,
which has also changed.
- `TextBlockStyleM` has an additional parameter, where you will need to define 4 arguments, instead of 3. 
The added argument pertains to `lastLineSpacing`, the spacing at the end of the text block.
We've just added a `VerticalSpacing(top: 16, bottom: 0)`
- we can't set the `subscript` and `superscript` fields in `EditorStylesM` (previously `DefaultStyles`), 
as they're not yet available.
- we've also removed the `onTapUp` callback field, 
as we no longer need it.

In the same file,
we've re-defined `quillEditor` if it was in a web platform.
Let's update that as well.
It now becomes the following:

```dart
    // Alternatively, the web editor version is shown  (with the web embeds)
    if (widget.platformService.isWebPlatform()) {
      quillEditor = VisualEditor(
        controller: _controller!,
        scrollController: ScrollController(),
        focusNode: _focusNode,
        config: EditorConfigM(
          scrollable: true,
          enableInteractiveSelection: false,
          autoFocus: false,
          readOnly: false,
          placeholder: 'Add content',
          expands: false,
          padding: EdgeInsets.zero,
          customStyles: const EditorStylesM(
            h1: TextBlockStyleM(
              TextStyle(
                fontSize: 32,
                color: Colors.black,
                height: 1.15,
                fontWeight: FontWeight.w300,
              ),
              VerticalSpacing(top: 16, bottom: 0),
              VerticalSpacing(top: 0, bottom: 0),
              VerticalSpacing(top: 16, bottom: 0),
              null,
            ),
            sizeSmall: TextStyle(fontSize: 9),
          ),
        ),
      );
    }
```

## 4.2 `EditorToolbar`

`QuillToolbar` now becomes `EditorToolbar`.
With `flutter-quill`, 
we used `FlutterQuillEmbeds.buttons` and appended these custom embed buttons
this to the toolbar's children.

**This is not the case in `visual-editor`.**

You will simply list the buttons in the `customButton` field 
and add the necessary callbacks (like `webImagePickImpl` or `onImagePickCallback`, for example) to the relevant buttons. 
You can also use the `children` field to enforce a custom order, 
feeding the list straight to `EditorToolbar`'s constructor.
However, in this case, it's almost pointless to use this field as it does not provide much functionality on top of the customs buttons set.

Let's add our buttons to the toolbar, then!
Locate the `toolbar` variable, 
and change it.

```dart
// Toolbar definitions
    const toolbarIconSize = 18.0;
    const toolbarButtonSpacing = 2.5;

    // Instantiating the toolbar
    final toolbar = EditorToolbar(
      children: [
        HistoryButton(
          buttonsSpacing: toolbarButtonSpacing,
          icon: Icons.undo_outlined,
          iconSize: toolbarIconSize,
          controller: _controller!,
          isUndo: true,
        ),
        HistoryButton(
          buttonsSpacing: toolbarButtonSpacing,
          icon: Icons.redo_outlined,
          iconSize: toolbarIconSize,
          controller: _controller!,
          isUndo: false,
        ),
        ToggleStyleButton(
          buttonsSpacing: toolbarButtonSpacing,
          attribute: AttributesM.bold,
          icon: Icons.format_bold,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        ToggleStyleButton(
          buttonsSpacing: toolbarButtonSpacing,
          attribute: AttributesM.italic,
          icon: Icons.format_italic,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        ToggleStyleButton(
          buttonsSpacing: toolbarButtonSpacing,
          attribute: AttributesM.underline,
          icon: Icons.format_underline,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        ToggleStyleButton(
          buttonsSpacing: toolbarButtonSpacing,
          attribute: AttributesM.strikeThrough,
          icon: Icons.format_strikethrough,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),

        // Our embed buttons
        ImageButton(
          icon: Icons.image,
          iconSize: toolbarIconSize,
          buttonsSpacing: toolbarButtonSpacing,
          controller: _controller!,
          onImagePickCallback: _onImagePickCallback,
          webImagePickImpl: _webImagePickImpl,
          mediaPickSettingSelector: (context) {
            return Future.value(MediaPickSettingE.Gallery);
          },
        ),
      ],
    );
```

Here's a list of relevant changes we've made:

- removed `FlutterQuillEmbeds.buttons` - we don't need to use `FlutterQuillEmbeds` to create embed buttons any more. 
We simply create them normally in the children field.
- removed the `afterButtonPressed` field from `EditorToolbar` constructor.
- added `buttonsSpacing` field to all buttons, as it's required.
- `Attribute` is now renamed to `AttributesM`
(which is why we imported it in the beginning of this guide).
- `MediaPickSetting` is now renamed to `MediaPickSettingE`.


Each button we add needs to have the `buttonsSpacing` field defined.
But now can simply define our array of buttons,
display them in the order we like,
and not have to worry about web embeds or anything like that!
All the necessary callbacks (like `onImagePickCallback`)
are related to relevant buttons (`CameraButton`, for example).
So we don't add this behaviour to the definition of the `toolbar`,
but **to the adequate button**.
Much simpler, right?


# 5. Changing tests

Let's fix the compiling errors on our tests.
Luckily, it's simple.
Just change the imports like we've done at the beginning of this guide,
and replace `QuillEditor` with `VisualEditor`
(and other necessary classes).

The method `tester.quillEnterText()` no longer exists,
so you can safely delete it.


# 6. You're done! 🎉

Congratulations, you've successfully migrated 
the app from `flutter-quill` to `visual-editor`!

Give yourself a pat on the back! 👏