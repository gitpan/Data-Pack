package Data::Pack;

use strict;
use warnings;
use Scalar::Util 'reftype';


our $VERSION = '0.01';

use base 'Exporter';

our %EXPORT_TAGS = (
    util  => [ qw(pack_data has_content) ],
);

our @EXPORT_OK = @{ $EXPORT_TAGS{all} = [ map { @$_ } values %EXPORT_TAGS ] };


sub has_content {
    my $data = shift;
    return defined $data unless ref $data;
    my $type = reftype $data;
    return @$data if $type eq 'ARRAY';
    return keys %$data if $type eq 'HASH';
    die "has_content: unknown type [$type]\n";
}


sub pack_data {
    my $data = shift;
    return $data unless ref $data;

    my $type = reftype $data;
    if ($type eq 'HASH') {
        my $packed_hash = {};
        while (my ($key, $value) = each %$data) {
            my $packed_value = pack_data($value);
            next unless has_content($packed_value);
            $packed_hash->{$key} = $packed_value;
        }
        bless $packed_hash, ref $data unless ref $data eq 'HASH';
        return $packed_hash;

    } elsif ($type eq 'ARRAY') {
        return [ grep { defined } map { pack_data($_) } @$data ];
    } else {
        die "pack_hash: unknown type [$type]\n";
    }
}



1;


__END__

=head1 NAME

Data::Pack - pack data structures so only real content remains

=head1 SYNOPSIS

    use Data::Pack ':all';

    my $h = {
        a => 1,
        b => [ 2..4, undef, 6..8 ],
        c => [],
        d => {},
        e => undef,
        f => (bless {
            f1 => undef,
            f2 => 'f2',
        }, 'Foo'),
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

    my $p = pack_data($h);

The result is

    $p = {
        a => 1,
        b => [ 2..4, 6..8 ],
        f => (bless {
            f2 => 'f2',
        }, 'Foo'),
    };

=head1 DESCRIPTION

This module provides a way to traverse data structures and eliminate any
undefined or otherwise empty pieces from it. None of the functions are
exported automatically, but you can request them by name, or get all of them
if you use the C<:all> tag.

=head1 FUNCTIONS

=over 4

=item pack_data

This function takes a possibly blessed hash or array reference and traverses
it, returning a copy that has no undefined or otherwise empty pieces. That is,
key/value pairs where the value is undefined - or recursively deemed
contentless - are eliminated from the copy, as are undefined or contentless
elements from arrays. "Deemed contentless" is done with C<has_content()>, so
for example a hash key/value pair whose value is a hash of arrays or the like,
but whose leaves are all undefined or empty, is omitted. See the Synopsis for
an example.

=item has_content

This is really just a convenience function used by C<data_pack()>, but it is
still exportable.

Given a scalar, it returns whether this is a defined value.

Given a possibly blessed array reference, it returns whether that array
contains any elements.

Given a possibly blessed hash reference, it returns whether that hash contains
any key/value pairs.

Given any other type of reference, it will die.

=back

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

