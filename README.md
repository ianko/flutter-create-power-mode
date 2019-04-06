# Power Mode for Flutter Create 2019

This project is inspired inspired by [Joel Besada's famous Power Mode plugin](https://twitter.com/JoelBesada/status/670343885655293952), and heavily dependent on [Norbert Kozsir's particles from `pimp_my_button` plugin](https://github.com/Norbert515/pimp_my_button).

One of the best things about Flutter is that we have access to both low and high level widgets. The [`TextField`](https://github.com/flutter/flutter/blob/stable/packages/flutter/lib/src/material/text_field.dart) widget didn't give me the option to find the cursor position, but after looking at the source code, I could see that it uses the [`EditableText`](https://github.com/flutter/flutter/blob/stable/packages/flutter/lib/src/widgets/editable_text.dart) as base, and that one had all the low level access that I needed.

With the cursor position sorted out, the rest of the work was to configure the particles and animations for every character typed.

## Instructions

* [LICENSE](LICENSE) (MIT)
* Channel: `stable` (v1.2.1 as per April 6th, 2019)
* Platform: `iOS` and `Android`
  * NOTE: Because of the `HapticFeedback`, it's recommended to use iOS 10+ and Android API Level 23+, for best experience.

## Demo

![power_mode_android](https://user-images.githubusercontent.com/723360/55664880-b2d59a00-5803-11e9-93d8-5fa02689a1b1.gif)
