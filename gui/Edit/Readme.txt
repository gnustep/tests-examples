this is the GNU implementation of NSText as done by Daniel Bðhringer.

What it already does is laying out plain text. You can modify selectinon and text as with NeXT's NSText class and even use the NeXT spell checking mechanism. there are problems remaining however (pasting newline characters at the end of a paragraph and performance on very large text)... but these problems will eventually fixed :-)

note that the "end" key forces a complete re-layout in case of display problems and pressing "num-lock" dumps some debug information

Some annotations: 

it is implemented completely at foundation level and thus should be unicode ready. (a subclass might override the central rebuildPlainLineLayoutInformationStartingAtLine: lineformatting method using a plain c-string approach if the performance turns out to be limiting to usefulnes).

at implementation level rtf is not treated different from rtfd since both are handled by NSAttributed string.

currently refreshes the lines below the edited line up to the next paragraph (this may cause performance problems with large paragraphs). a simple workaorund is beeing worked out but not implemented yet (coming soon).

in plain mode words wraps use the selectionGranularity configuration for word/ paragraph boundry detection.

tabs are not treated differently from other characters but nevertheles work as expected thanks to NeXT's implementation of -sizeWithAttributes: and -drawAtPoint:withAttributes: (in plain mode tab information seems to come from [NSParagraphStyle defaultParagraphStyle]).

