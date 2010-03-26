#!/usr/bin/env perl
use warnings;
use strict;
use Data::Pack ':all';
use Test::More tests => 2;
use Test::Differences;
my $h = {
    a => 1,
    b => [ 2 .. 4, undef, 6 .. 8 ],
    c => [],
    d => {},
    e => undef,
    f => (
        bless {
            f1 => undef,
            f2 => 'f2',
        },
        'Foo'
    ),
    g => {
        g1 => undef,
        g2 => undef,
        g3 => [ undef, undef, undef ],
        g4 => {
            g4a => undef,
            g4b => undef,
        },
    },
};
my $hp = {
    a => 1,
    b => [ 2 .. 4, 6 .. 8 ],
    f => (bless { f2 => 'f2', }, 'Foo'),
};
eq_or_diff(pack_data($h), $hp, 'hashpack');
eq_or_diff(pack_data({ a => undef }), {}, 'hashpack');
