# Contribute to the project

Thank you for your interest in contributing to this project.
To keep the code consistent contributors must respect the coding guidelines described in this document. 

## Coding standard

### Indentation

  * Indentation size: 2.
  * Use spaces (not tab).

### Line padding and trailing spaces

  * The first line after a bloc opening brace must not be empty.
  * The last line before the closing brace must not be empty.
  * **There must not be any spaces at the end of a line**.

<code>

    // Do
    if (TRUE) {
      doThis();
    }

    // Don't
    if (TRUE) {

      doThis();

    }
</code>

### Braces

<code>

    // Do
    if (TRUE) {
      doThis();
    }

    // Don't
    if (TRUE)
    {
      doThis();
    }

</code>

### if...else

  * Space between `if` and the openting parentheses.
  * `else` next to the closing brace separated by space.

<code>

    // Do
    if (FALSE) {
      doThis();
    } else if (STILL_FALSE) {
      doThisInstead();
    } else {
      doThisFinally();
    }

    // Don't
    if (FALSE) {
      doThis();
    }
    else if (STILL_FALSE) {
      doThisInstead();
    }
    else {
      doThisFinally();
    }

</code>

### do...while

  * Opening brace on the same line.
  * `while` next to the closing brace followed by one space before parentheses.

<code>

    do {
      this();
    } while (TRUE);

</code>

### Blocks

Always use braces even to enclose a one line block. 

<code>

    // Do
    if (TRUE) {
      doThis();
    } else {
      doThisInstead();
    }

    // Don't
    if (TRUE)
      doThis();
    else
      doThisInstead();

</code>
