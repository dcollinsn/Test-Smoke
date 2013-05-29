package Test::Smoke::Poster::Base;
use warnings;
use strict;
use Carp;

use base 'Test::Smoke::ObjectBase';
use Test::Smoke::LogMixin;

require Test::Smoke;

use File::Spec::Functions;

=head1 NAME

Test::Smoke::Poster::Base - Base class for the posters to CoreSmokeDB.

=head1 DESCRIPTION

Provide general methods for the poster subclasses.

=head2 Test::Smoke::Poster::Base->new(%arguments);

=head3 Arguments

Named.

=over

=item smokedb_url => $some_url

=item ddir => $smoke_directory

=item jsnfile => $json_file (mktest.jsn)

=item v => $verbosity

=back

=head3 Returns

An instance of the class.

=head3 Exceptions

None.

=cut

sub new {
    my $class = shift;
    my %args = @_;
    # Convert to "underscore names" for Test::Smoke::ObjecBase.
    my %fields = map
        +( "_$_" => delete $args{$_})
    , keys %args;
    return bless \%fields, $class;
}

=head2 $poster->agent_string()

Class and intstance method.

=head3 Arguments

None.

=head3 Returns

    sprintf "Test::Smoke/%s (%s)", $Test::Smoke::VERSION, $class;

=head3 Exceptions

None.

=cut

sub agent_string {
    my $class = ref($_[0]) || $_[0];

    return "Test::Smoke/$Test::Smoke::VERSION ($class)";
}

=head2 $poster->get_json()

=head3 Arguments

None.

=head3 Returns

The json string that was stored in C<< $ddir/$jsnfile >>.

=head3 Exceptions

File I/O.

=cut

sub get_json {
    my $self = shift;

    my $json_file = $self->json_filename();
    $self->log_debug("Reading from (%s)", $json_file);
    open my $fh, '<', $json_file or die "Cannot open($json_file): $!";
    my $json = do { local $/; <$fh> };
    close $fh;

    return $json;
}

=head2 $poster->json_filename()

Returns the the fully qualified file name of the jsonfile.

=cut

sub json_filename {
    my $self = shift;

    return catfile($self->ddir, $self->jsnfile);
}

=head2 $poster->post()

Abstract method.

=head3 Arguments

None.

=head3 Returns

The id of the CoreSmokeDB report on success.

=head3 Exceptions

HTTP or Test::Smoke::Gateway-application errors.

=cut

sub post {
    my $class = ref($_[0]) || $_[0];
    croak("Must be implemented by '$class'");
}

1;

=head1 COPYRIGHT

(c) 2002-2013, Abe Timmerman <abeltje@cpan.org> All rights reserved.

With contributions from Jarkko Hietaniemi, Merijn Brand, Campo
Weijerman, Alan Burlison, Allen Smith, Alain Barbet, Dominic Dunlop,
Rich Rauenzahn, David Cantrell.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

See:

=over 4

=item * L<http://www.perl.com/perl/misc/Artistic.html>

=item * L<http://www.gnu.org/copyleft/gpl.html>

=back

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut
