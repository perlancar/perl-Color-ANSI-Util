#!perl

use 5.010001;
use strict;
use warnings;

use Test::More 0.98;
use Color::ANSI::Util qw(
                           ansi16_to_rgb
                           rgb_to_ansi16
                           rgb_to_ansi16_fg_code
                           ansi16fg
                           rgb_to_ansi16_bg_code
                           ansi16bg

                           ansi256_to_rgb
                           rgb_to_ansi256
                           rgb_to_ansi256_fg_code
                           ansi256fg
                           rgb_to_ansi256_bg_code
                           ansi256bg

                           rgb_to_ansi24b_fg_code
                           ansi24bfg
                           rgb_to_ansi24b_bg_code
                           ansi24bbg

                           rgb_to_ansi_fg_code
                           ansifg
                           rgb_to_ansi_bg_code
                           ansibg

                           detect_color_depth
                    );

subtest "16 colors" => sub {
    is(ansi16_to_rgb(1), "800000");
    is(ansi16_to_rgb(9), "ff0000");
    is(ansi16_to_rgb("red"), "800000");
    is(ansi16_to_rgb("bold red"), "ff0000");
    is(rgb_to_ansi16("7e0000"), 1);
    is(rgb_to_ansi16("ee1111"), 9);
    is(rgb_to_ansi16_fg_code("7e0000"), "\e[31m");
    is(ansi16fg             ("fe0000"), "\e[31;1m");
    is(rgb_to_ansi16_bg_code("7e0000"), "\e[41m");
    is(ansi16bg             ("fe0000"), "\e[41m");
};

subtest "256 colors" => sub {
    is(ansi256_to_rgb(156), "afff87");
    is(rgb_to_ansi256("ff0000"), 9);
    is(rgb_to_ansi256("afff80"), 156);
    is(rgb_to_ansi256("afdf80"), 150);
    is(rgb_to_ansi256_fg_code("7e0000"), "\e[38;5;1m");
    is(ansi256fg             ("fe0000"), "\e[38;5;9m");
    is(rgb_to_ansi256_bg_code("7e0000"), "\e[48;5;1m");
    is(ansi256bg             ("fe0000"), "\e[48;5;9m");
};

subtest "24bit colors" => sub {
    is(rgb_to_ansi24b_fg_code("7e0102"), "\e[38;2;126;1;2m");
    is(ansi24bfg             ("fe0102"), "\e[38;2;254;1;2m");
    is(rgb_to_ansi24b_bg_code("7e0102"), "\e[48;2;126;1;2m");
    is(ansi24bbg             ("fe0102"), "\e[48;2;254;1;2m");
};

subtest "detect" => sub {
    {
        local $ENV{COLOR_DEPTH};
        local $ENV{KONSOLE_DBUS_SERVICE} = 'some value';
        local $ENV{KONSOLE_DBUS_SESSION} = 'some value';
        local $ENV{TERM} = 'xterm';
        is(detect_color_depth(), 2**24);
    }
    {
        local $ENV{COLOR_DEPTH};
        local $ENV{KONSOLE_DBUS_SERVICE};
        local $ENV{KONSOLE_DBUS_SESSION};
        local $ENV{TERM} = 'xterm-256color';
        is(detect_color_depth(), 256);
    }

    {
        local $ENV{COLOR_DEPTH} = 256;
        is(rgb_to_ansi_fg_code("7e0000"), "\e[38;5;1m");
        is(ansifg             ("fe0000"), "\e[38;5;9m");
        is(rgb_to_ansi_bg_code("7e0000"), "\e[48;5;1m");
        is(ansibg             ("fe0000"), "\e[48;5;9m");
    }
};

DONE_TESTING:
done_testing();
