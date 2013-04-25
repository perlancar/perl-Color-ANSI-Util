package Color::ANSI::Util;

use 5.010001;
use strict;
use warnings;

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(
                       ansi16_to_rgb
                       ansi256_to_rgb
                       rgb_to_ansi16
                       rgb_to_ansi256
               );

# VERSION

sub ansi16_to_rgb {
}


1;
# ABSTRACT: Routines for dealing with ANSI colors

=head1 SYNOPSIS

 use Color::ANSI::Util qw(
     ansi16_to_rgb
     ansi256_to_rgb
     rgb_to_ansi16
     rgb_to_ansi256
 );

 # convert ANSI-16 color to RGB
 say ansi16_to_rgb("31");       # => "800000" (red)
 say ansi16_to_rgb("red");      # => "800000" (ditto)
 say ansi16_to_rgb("31;1");     # => "ff0000" (red bold)
 say ansi16_to_rgb("bold red"); # => "ff0000" (ditto)

 # convert RGB to ANSI-16
 say ansi16_to_rgb("ac0405");    # => "31" (closest to red)
 say ansi16_to_rgb("f01010");    # => "31;1" (closest to bold red)

 # convert ANSI-256 color to RGB
 say ansi256_to_rgb(204);        # => "ff5f87"

 # convert RGB to ANSI-256 color
 say rgb_to_ansi256("ff5f87");   # => 204


=head1 DESCRIPTION

This module provides routines for dealing with ANSI colors.

Keywords: xterm, xterm-256color, terminal


=head1 FUNCTIONS

=head2 ansi16_to_rgb($color) => STR

Convert ANSI-16 color to RGB. C<$color> can be 30-37, or "30;1" to "37;1" (for
bold), or color names "black", "red", "green", "yellow", "blue", "magenta",
"cyan", "white" with "bold" to indicate bold/bright.

=head2 rgb_to_ansi16($color) => STR

Convert RGB to ANSI-16 color. C<$color> is 6-hexdigit RGB color like "abcdef".
Will pick the closest color. Return color in the form that is convenient for
printing ANSI escape code to set foreground color, e.g. "31", "31;1" (when
printed as color code, "\e[31m" or "\e[31;1m"). To set background color, add
decimal 10 value to the first number, e.g. "\e[41m" or "\e[41;1m".

=head2 ansi256_to_rgb($color) => STR

Convert ANSI-256 color to RGB. C<$color> is a number from 0-255.

=head2 rgb_to_ansi256($color) => STR

Convert RGB to ANSI-256 color. C<$color> is 6-hexdigit RGB color like "abcdef".
Will pick the closest color. Return number between 0-255. Note: to print ANSI
escape code to set foreground color, use: "\e[38;5;<color>m" and to set
background color: "\e[48;5;<color>m".

BTW, ANSI code to set RGB foreground color (supported by Konsole/Yakuake):
"\e[38;2;<R>;<G>;<B>m" and to set RGB background color: "\e[48;2;<R>;<G>;<B>m",
where R, G, B are decimal values.


=head1 SEE ALSO

L<Term::ANSIColor>

http://en.wikipedia.org/wiki/ANSI_escape_code

=cut
