#!perl

use 5.010001;
use strict;
use warnings;

use Test::More 0.98;
use Color::ANSI::Util qw(
                           ansi16_to_rgb
                           rgb_to_ansi16
                           ansi256_to_rgb
                           rgb_to_ansi256
                    );

is(ansi16_to_rgb("31"), "800000");
is(ansi16_to_rgb("31;1"), "ff0000");
is(ansi16_to_rgb("red"), "800000");
is(ansi16_to_rgb("bold red"), "ff0000");

is(rgb_to_ansi16("7e0000"), "31");
is(rgb_to_ansi16("ee1111"), "31;1");

is(ansi256_to_rgb("156"), "afff87");

is(rgb_to_ansi256("ff0000"), 9);
is(rgb_to_ansi256("afff80"), 156);
is(rgb_to_ansi256("afdf80"), 150);

DONE_TESTING:
done_testing();
