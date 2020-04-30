# ANSI color and style library

This is a simple library for applying styles to terminal code using ANSI
escape sequences.

This library can be used simply by importing it.

```sh
import color
```

# Applying sets of styles

A set of styles can be enabled by passing them as arguments to the
`style` function. All styles will be disabled with the `unstyle`
function.

```sh
style $BOLD
echo this text will be bold
unstyle

echo "This $(style $BOLD $ITALIC)word$(unstyle) will be bold"
```

A style can be applied to a single string using `span`.

```sh
style $BOLD
echo this text will be bold
unstyle

echo "This $(span $BOLD $ITALIC "word") will be bold"
```

# Font weight

 * Set with:
    * `$BOLD`
    * `$FAINT` or `$DIM`
 * Reset with: `$MEDIUM`

The font weight can be made heavier using the `$BOLD` style and lighter
using the `$FAINT` style. `$DIM` is an alias for `$FAINT`.

The `$MEDIUM` style reset the font weight.

# Font alternatives

 * Set with:
    * `$ITALIC`
    * `$FRAKTUR`
 * Reset with: `$REGULAR`

# Underlines

 * Set with:
    * `$UNDERLINE`
    * `$DOUBLE_UNDERLINE`
 * Reset with: `$NO_UNDERLINE`

# Alternative fonts

> Note: This is not well supported.

The `font` function can be used to access one of the 10 alternative
fonts. The default font is font 0.

```sh
echo "The word $(span $(font 2) "this") will be different"
```

# Overlines

> Note: This is not well supported.

 * Set with:
    * `$OVERLINE`
 * Reset with: `$NO_OVERLINE`

# Crossed-out text

> Note: This is not well supported.

 * Set with:
    * `$CROSS_OUT` or `$STRIKETHROUGH`
 * Reset with: `$NO_CROSS_OUT` or `$NO_STRIKETHROUGH`

# Blinking text

 * Set with:
    * `$SLOW_BLINK`
    * `$RAPID_BLINK` or `$FAST_BLINK`
 * Reset with: `$NO_BLINK`

# Hiding text

 * Set with:
    * `$CONCEAL`
 * Reset with: `$REVEAL` or `NO_CONCEAL`

# Frames

> Note: This is not well supported.

 * Set with:
    * `$FRAME`
    * `$ENCIRCLE`
 * Reset with: `$NO_FRAME`

# Color inversion

 * Set with:
    * `$REVERSE_VIDEO` or `$INVERT`
 * Reset with: `$NO_REVERSE_VIDEO` or `$NO_INVERT`

# Color styles

## Simple colors

Many common 4-bit colors are defined with styles of the form
`<COLOR>_FG` to set the foreground color and `<COLOR>_BG` to set the
background color.

The available colors are:

 * `BLACK`
 * `RED`
 * `GREEN`
 * `YELLOW`
 * `BLUE`
 * `MAGENTA`
 * `CYAN`
 * `WHITE`
 * `BR_<COLOR>` for bright versions of the above colors

## Greys

Styles that use one of 24 values of grey can be generated with the
`grey_fg` and `grey_bg` functions, setting the foreground and background
colors respectively.

```sh
echo $(span $(grey_fg 2) "dark grey")
echo $(span $(grey_fg 22) "light grey")
```

## 8-bit color

Styles that use 8-bit color values can be created with the `rgb8_fg` and
`rgb8_bg` functions, setting the foreground and background colors
respectively.

Each of these functions takes 3 arguments, each in the range [0..6) for
the channels red, green, and blue.

```sh
echo $(span $(rgb8_fg 3 1 5) "purple")
```

## 24-bit color

Styles that use 24-bit color values can be created with the `rgb24_fg`
and `rgb24_bg` functions, setting the foreground and background colors
respectively.

Each of these functions takes 3 arguments, each in the range [0..256)
for the channels red, green, and blue.

```sh
echo $(span $(rgb24_fg 160 80 192) "purple")
```
