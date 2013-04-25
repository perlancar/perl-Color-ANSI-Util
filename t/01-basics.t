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

DONE_TESTING:
done_testing();
