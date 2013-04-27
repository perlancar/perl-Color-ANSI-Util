package Color::ANSI::Util;

use 5.010001;
use strict;
use warnings;

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(
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

# VERSION

my %ansi16 = (
    0  => '000000',
    1  => '800000',
    2  => '008000',
    3  => '808000',
    4  => '000080',
    5  => '800080',
    6  => '008080',
    7  => 'c0c0c0',
    8  => '808080',
    9  => 'ff0000',
    10 => '00ff00',
    11 => 'ffff00',
    12 => '0000ff',
    13 => 'ff00ff',
    14 => '00ffff',
    15 => 'ffffff',
);
my @revansi16;
for (sort {$a<=>$b} keys %ansi16) {
    $ansi16{$_} =~ /(..)(..)(..)/;
    push @revansi16, [hex($1), hex($2), hex($3), $_];
}

my %ansi256 = (
    %ansi16,

    16 => '000000',  17 => '00005f',  18 => '000087',  19 => '0000af',  20 => '0000d7',  21 => '0000ff',
    22 => '005f00',  23 => '005f5f',  24 => '005f87',  25 => '005faf',  26 => '005fd7',  27 => '005fff',
    28 => '008700',  29 => '00875f',  30 => '008787',  31 => '0087af',  32 => '0087d7',  33 => '0087ff',
    34 => '00af00',  35 => '00af5f',  36 => '00af87',  37 => '00afaf',  38 => '00afd7',  39 => '00afff',
    40 => '00d700',  41 => '00d75f',  42 => '00d787',  43 => '00d7af',  44 => '00d7d7',  45 => '00d7ff',
    46 => '00ff00',  47 => '00ff5f',  48 => '00ff87',  49 => '00ffaf',  50 => '00ffd7',  51 => '00ffff',
    52 => '5f0000',  53 => '5f005f',  54 => '5f0087',  55 => '5f00af',  56 => '5f00d7',  57 => '5f00ff',
    58 => '5f5f00',  59 => '5f5f5f',  60 => '5f5f87',  61 => '5f5faf',  62 => '5f5fd7',  63 => '5f5fff',
    64 => '5f8700',  65 => '5f875f',  66 => '5f8787',  67 => '5f87af',  68 => '5f87d7',  69 => '5f87ff',
    70 => '5faf00',  71 => '5faf5f',  72 => '5faf87',  73 => '5fafaf',  74 => '5fafd7',  75 => '5fafff',
    76 => '5fd700',  77 => '5fd75f',  78 => '5fd787',  79 => '5fd7af',  80 => '5fd7d7',  81 => '5fd7ff',
    82 => '5fff00',  83 => '5fff5f',  84 => '5fff87',  85 => '5fffaf',  86 => '5fffd7',  87 => '5fffff',
    88 => '870000',  89 => '87005f',  90 => '870087',  91 => '8700af',  92 => '8700d7',  93 => '8700ff',
    94 => '875f00',  95 => '875f5f',  96 => '875f87',  97 => '875faf',  98 => '875fd7',  99 => '875fff',
    100 => '878700', 101 => '87875f', 102 => '878787', 103 => '8787af', 104 => '8787d7', 105 => '8787ff',
    106 => '87af00', 107 => '87af5f', 108 => '87af87', 109 => '87afaf', 110 => '87afd7', 111 => '87afff',
    112 => '87d700', 113 => '87d75f', 114 => '87d787', 115 => '87d7af', 116 => '87d7d7', 117 => '87d7ff',
    118 => '87ff00', 119 => '87ff5f', 120 => '87ff87', 121 => '87ffaf', 122 => '87ffd7', 123 => '87ffff',
    124 => 'af0000', 125 => 'af005f', 126 => 'af0087', 127 => 'af00af', 128 => 'af00d7', 129 => 'af00ff',
    130 => 'af5f00', 131 => 'af5f5f', 132 => 'af5f87', 133 => 'af5faf', 134 => 'af5fd7', 135 => 'af5fff',
    136 => 'af8700', 137 => 'af875f', 138 => 'af8787', 139 => 'af87af', 140 => 'af87d7', 141 => 'af87ff',
    142 => 'afaf00', 143 => 'afaf5f', 144 => 'afaf87', 145 => 'afafaf', 146 => 'afafd7', 147 => 'afafff',
    148 => 'afd700', 149 => 'afd75f', 150 => 'afd787', 151 => 'afd7af', 152 => 'afd7d7', 153 => 'afd7ff',
    154 => 'afff00', 155 => 'afff5f', 156 => 'afff87', 157 => 'afffaf', 158 => 'afffd7', 159 => 'afffff',
    160 => 'd70000', 161 => 'd7005f', 162 => 'd70087', 163 => 'd700af', 164 => 'd700d7', 165 => 'd700ff',
    166 => 'd75f00', 167 => 'd75f5f', 168 => 'd75f87', 169 => 'd75faf', 170 => 'd75fd7', 171 => 'd75fff',
    172 => 'd78700', 173 => 'd7875f', 174 => 'd78787', 175 => 'd787af', 176 => 'd787d7', 177 => 'd787ff',
    178 => 'd7af00', 179 => 'd7af5f', 180 => 'd7af87', 181 => 'd7afaf', 182 => 'd7afd7', 183 => 'd7afff',
    184 => 'd7d700', 185 => 'd7d75f', 186 => 'd7d787', 187 => 'd7d7af', 188 => 'd7d7d7', 189 => 'd7d7ff',
    190 => 'd7ff00', 191 => 'd7ff5f', 192 => 'd7ff87', 193 => 'd7ffaf', 194 => 'd7ffd7', 195 => 'd7ffff',
    196 => 'ff0000', 197 => 'ff005f', 198 => 'ff0087', 199 => 'ff00af', 200 => 'ff00d7', 201 => 'ff00ff',
    202 => 'ff5f00', 203 => 'ff5f5f', 204 => 'ff5f87', 205 => 'ff5faf', 206 => 'ff5fd7', 207 => 'ff5fff',
    208 => 'ff8700', 209 => 'ff875f', 210 => 'ff8787', 211 => 'ff87af', 212 => 'ff87d7', 213 => 'ff87ff',
    214 => 'ffaf00', 215 => 'ffaf5f', 216 => 'ffaf87', 217 => 'ffafaf', 218 => 'ffafd7', 219 => 'ffafff',
    220 => 'ffd700', 221 => 'ffd75f', 222 => 'ffd787', 223 => 'ffd7af', 224 => 'ffd7d7', 225 => 'ffd7ff',
    226 => 'ffff00', 227 => 'ffff5f', 228 => 'ffff87', 229 => 'ffffaf', 230 => 'ffffd7', 231 => 'ffffff',

    232 => '080808', 233 => '121212', 234 => '1c1c1c', 235 => '262626', 236 => '303030', 237 => '3a3a3a',
    238 => '444444', 239 => '4e4e4e', 240 => '585858', 241 => '606060', 242 => '666666', 243 => '767676',
    244 => '808080', 245 => '8a8a8a', 246 => '949494', 247 => '9e9e9e', 248 => 'a8a8a8', 249 => 'b2b2b2',
    250 => 'bcbcbc', 251 => 'c6c6c6', 252 => 'd0d0d0', 253 => 'dadada', 254 => 'e4e4e4', 255 => 'eeeeee',
);
my @revansi256;
for (sort {$a<=>$b} keys %ansi256) {
    $ansi256{$_} =~ /(..)(..)(..)/;
    push @revansi256, [hex($1), hex($2), hex($3), $_];
}

sub ansi16_to_rgb {
    my ($input) = @_;

    if ($input =~ /^\d+$/) {
        if ($input >= 0 && $input <= 15) {
            return $ansi16{$input + 0}; # to remove prefix zero e.g. "06"
        } else {
            die "Invalid ANSI 16-color number '$input'";
        }
    } elsif ($input =~ /^(?:(bold|bright) \s )?
                        (black|red|green|yellow|blue|magenta|cyan|white)$/ix) {
        my ($bold, $col) = (lc($1 // ""), lc($2));
        my $i;
        if ($col eq 'black') {
            $i = 0;
        } elsif ($col eq 'red') {
            $i = 1;
        } elsif ($col eq 'green') {
            $i = 2;
        } elsif ($col eq 'yellow') {
            $i = 3;
        } elsif ($col eq 'blue') {
            $i = 4;
        } elsif ($col eq 'magenta') {
            $i = 5;
        } elsif ($col eq 'cyan') {
            $i = 6;
        } elsif ($col eq 'white') {
            $i = 7;
        }
        $i += 8 if $bold;
        return $ansi16{$i};
    } else {
        die "Invalid ANSI 16-color name '$input'";
    }
}

sub _rgb_to_indexed {
    my ($rgb, $table) = @_;

    $rgb =~ /^#?([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})$/
        or die "Invalid RGB input '$rgb'";
    my $r = hex($1);
    my $g = hex($2);
    my $b = hex($3);

    my ($minsqdist, $res);
    for my $e (@$table) {
        my $sqdist =
            abs($e->[0]-$r)**2 + abs($e->[1]-$g)**2 + abs($e->[2]-$b)**2;
        # exact match, return immediately
        return $e->[3] if $sqdist == 0;
        if (!defined($minsqdist) || $minsqdist > $sqdist) {
            #say "D:sqdist=$sqdist";
            $minsqdist = $sqdist;
            $res = $e->[3];
        }
    }
    return $res;
}

sub ansi256_to_rgb {
    my ($input) = @_;

    $input += 0;
    exists($ansi256{$input}) or die "Invalid ANSI 256-color index '$input'";
    $ansi256{$input};
}

sub rgb_to_ansi16 {
    my ($input) = @_;
    _rgb_to_indexed($input, \@revansi16);
}

sub rgb_to_ansi256 {
    my ($input) = @_;
    _rgb_to_indexed($input, \@revansi256);
}

sub rgb_to_ansi16_fg_code {
    my ($input) = @_;

    my $res = _rgb_to_indexed($input, \@revansi16);
    return "\e[" . ($res >= 8 ? ($res+30-8) . ";1" : ($res+30)) . "m";
}

sub ansi16fg  { goto &rgb_to_ansi16_fg_code  }

sub rgb_to_ansi16_bg_code {
    my ($input) = @_;

    my $res = _rgb_to_indexed($input, \@revansi16);
    return "\e[" . ($res >= 8 ? ($res+40-8) : ($res+40)) . "m";
}

sub ansi16bg  { goto &rgb_to_ansi16_bg_code  }

sub rgb_to_ansi256_fg_code {
    my ($input) = @_;

    my $res = _rgb_to_indexed($input, \@revansi16);
    return "\e[38;5;${res}m";
}

sub ansi256fg { goto &rgb_to_ansi256_fg_code }

sub rgb_to_ansi256_bg_code {
    my ($input) = @_;

    my $res = _rgb_to_indexed($input, \@revansi16);
    return "\e[48;5;${res}m";
}

sub ansi256bg { goto &rgb_to_ansi256_bg_code }

sub rgb_to_ansi24b_fg_code {
    my ($rgb) = @_;

    return sprintf("\e[38;2;%d;%d;%dm",
                   hex(substr($rgb, 0, 2)),
                   hex(substr($rgb, 2, 2)),
                   hex(substr($rgb, 4, 2)));
}

sub ansi24bfg { goto &rgb_to_ansi24b_fg_code }

sub rgb_to_ansi24b_bg_code {
    my ($rgb) = @_;

    return sprintf("\e[48;2;%d;%d;%dm",
                   hex(substr($rgb, 0, 2)),
                   hex(substr($rgb, 2, 2)),
                   hex(substr($rgb, 4, 2)));
}

sub ansi24bbg { goto &rgb_to_ansi24b_bg_code }


my $cd_cache;
sub detect_color_depth {
    my $cd;
    if ($ENV{KONSOLE_DBUS_SERVICE} || $ENV{KONSOLE_DBUS_SESSION}) {
        # assume konsole is recent version and support 24bit color
        $cd = 2**24;
    } elsif (($ENV{TERM} // "") =~ /256color/) {
        $cd = 256;
    } else {
        $cd = 16;
    }
    $cd_cache = $cd;
    $cd;
}

sub rgb_to_ansi_fg_code {
    my ($rgb) = @_;
    my $cd = $ENV{COLOR_DEPTH};
    unless (defined $cd) {
        detect_color_depth() unless defined $cd_cache;
        $cd = $cd_cache;
    }
    if ($cd >= 2**24) {
        rgb_to_ansi24b_fg_code($rgb);
    } elsif ($cd >= 256) {
        rgb_to_ansi256_fg_code($rgb);
    } else {
        rgb_to_ansi16_fg_code($rgb);
    }
}

sub ansifg { goto &rgb_to_ansi_fg_code }

sub rgb_to_ansi_bg_code {
    my ($rgb) = @_;
    my $cd = $ENV{COLOR_DEPTH};
    unless (defined $cd) {
        detect_color_depth() unless defined $cd_cache;
        $cd = $cd_cache;
    }
    if ($cd >= 2**24) {
        rgb_to_ansi24b_bg_code($rgb);
    } elsif ($cd >= 256) {
        rgb_to_ansi256_bg_code($rgb);
    } else {
        rgb_to_ansi16_bg_code($rgb);
    }
}

sub ansibg { goto &rgb_to_ansi_bg_code }

1;
# ABSTRACT: Routines for dealing with ANSI colors

=head1 SYNOPSIS

 use Color::ANSI::Util qw(
     ansi16_to_rgb
     ansi256_to_rgb
     rgb_to_ansi16
     rgb_to_ansi256
     rgb_to_ansi16_fg_code
     ansi16fg
     rgb_to_ansi16_bg_code
     ansi16bg
     rgb_to_ansi256_fg_code
     ansi256fg
     rgb_to_ansi256_bg_code
     ansi256bg
 );

 # convert ANSI 16-color index to RGB
 say ansi16_to_rgb(1);          # => "800000" (red)
 say ansi16_to_rgb("red");      # => "800000" (ditto)
 say ansi16_to_rgb(9);          # => "ff0000" (red bold)
 say ansi16_to_rgb("bold red"); # => "ff0000" (ditto)

 # convert RGB to ANSI 16-color index
 say ansi16_to_rgb("ac0405");    # => 1 (closest to red)
 say ansi16_to_rgb("f01010");    # => 9 (closest to bold red)

 # convert RGB to ANSI 16-color escape code for setting foreground color
 say rgb_to_ansi16_fg_code("ac0405"); # => "\e[31m"
 say ansi16fg("f01010");              # => "\e[31;1m" (shorter alias)

 # ditto but for background color (bgcolor actually only supports 0-7)
 say rgb_to_ansi16_bg_code("ac0405"); # => "\e[41m"
 say ansi16bg("f01010");              # => "\e[41m" (shorter alias)

 # convert ANSI 256-color index to RGB
 say ansi256_to_rgb(204);        # => "ff5f87"

 # convert RGB to ANSI 256-color index
 say rgb_to_ansi256("ff5f88");   # => 204 (closest)

 # convert RGB to ANSI 256-color escape code for setting foreground color
 say rgb_to_ansi256_fg_code("ff5f87"); # => "\e[38;5;204m"
 say ansi256fg("ff5f87");              # => "\e[38;5;204m" (shorter alias)

 # ditto but for background color (bgcolor actually only supports 0-7)
 say rgb_to_ansi256_bg_code("ff5f87"); # => "\e[48;5;204m"
 say ansi256bg("ff5f87");              # => "\e[48;5;204m" (shorter alias)


=head1 DESCRIPTION

This module provides routines for dealing with ANSI colors.

Keywords: xterm, xterm-256color, terminal


=head1 FUNCTIONS

=head2 ansi16_to_rgb($color) => STR

Convert ANSI-16 color to RGB. C<$color> is number from 0-15, or color names
"black", "red", "green", "yellow", "blue", "magenta", "cyan", "white" with
"bold" to indicate bold/bright. Return 6-hexdigit, e.g. "ff00cc".

Die on invalid input.

=head2 rgb_to_ansi16($color) => INT

Convert RGB to ANSI-16 color. C<$color> is 6-hexdigit RGB color like "ff00cc".
Will pick the closest color. Return number from 0-15.

Die on invalid input.

=head2 ansi256_to_rgb($color) => STR

Convert ANSI-256 color to RGB. C<$color> is a number from 0-255. Return
6-hexdigit, e.g. "ff00cc".

Die on invalid input.

=head2 rgb_to_ansi256($color) => INT

Convert RGB to ANSI-256 color. C<$color> is 6-hexdigit RGB color like "ff00cc".
Will pick the closest color. Return number between 0-255.

Die on invalid input.

=head2 rgb_to_ansi16_fg_code($rgb) => STR

=head2 ansi16fg($rgb) => STR

Alias for rgb_to_ansi16_fg_code().

=head2 rgb_to_ansi16_bg_code($rgb) => STR

=head2 ansi16bg($rgb) => STR

Alias for rgb_to_ansi16_bg_code().

=head2 rgb_to_ansi256_fg_code($rgb) => STR

=head2 ansi256fg($rgb) => STR

Alias for rgb_to_ansi256_fg_code().

=head2 rgb_to_ansi256_bg_code($rgb) => STR

=head2 ansi256bg($rgb) => STR

Alias for rgb_to_ansi256_bg_code().

=head2 rgb_to_ansi24b_fg_code($rgb) => STR

Return ANSI escape code to set 24bit foreground color. Supported by Konsole and
Yakuake.

=head2 ansi24bfg($rgb) => STR

Alias for rgb_to_ansi24b_fg_code().

=head2 rgb_to_ansi24b_bg_code($rgb) => STR

Return ANSI escape code to set 24bit background color. Supported by Konsole and
Yakuake.

=head2 ansi24bbg($rgb) => STR

Alias for rgb_to_ansi24b_bg_code().

=head2 rgb_to_ansi_fg_code($rgb) => STR

Return ANSI escape code to set 24bit/256/16 foreground color (which color depth
used is determined by C<COLOR_DEPTH> environment setting or the latest
detect_color_depth() result).

=head2 ansifg($rgb) => STR

Alias for rgb_to_ansi_fg_code().

=head2 rgb_to_ansi24b_bg_code($rgb) => STR

Return ANSI escape code to set 24bit/256/16 background color (which color depth
used is determined by C<COLOR_DEPTH> environment setting or the latest
detect_color_depth() result).

=head2 ansibg($rgb) => STR

Alias for rgb_to_ansi_bg_code().

=head2 detect_color_depth() => INT

Detect color depth.


=head1 ENVIRONMENT


=head1 BUGS/NOTES

Algorithm for finding closest indexed color from RGB color currently not very
efficient. Probably can add some threshold square distance, below which we can
shortcut to the final answer.


=head1 TODO

Routine to convert ANSI escape code, e.g. C<\e[31;1m> into RGB value (ff0000).


=head1 SEE ALSO

L<Term::ANSIColor>

http://en.wikipedia.org/wiki/ANSI_escape_code

=cut
