package ShipIt::Step::ChangePodVersion;

use strict;
use base 'ShipIt::Step';
use ShipIt::Util qw(slurp write_file);

our $VERSION = '0.01';

################################################################################
sub run {
    my ($self, $state) = @_;

    $state->pt->current_version; #should create $self->{ver_from} for us
    my $new_version = $state->pt->version_from_file;

    my $file = $state->pt->{ver_from};
    die "perl update not done", $self->{ver_from} unless ($file);

    my $changed_file = $self->_change_pod_version(slurp($file), $new_version);
    write_file($file, $changed_file);

    return 1;

}

################################################################################
sub _change_pod_version {
    my ($self, $file_content, $new_version) = @_;

    # if we find a VERSION section, we change version, otherwise add one
    if ($file_content =~ /^=head\d VERSION/m) {

        # replace version
        if ($file_content !~ s/(^=head\d VERSION[^\d=]*)[\d._]+/$1$new_version/sm) {
            die ('there is a POD VERSION section, but the version cannot be parsed');
        }

    } else {

        my $version = "=head1 VERSION\n\n$new_version\n\n";
        # add it after NAME section, everybody has one, right?
        if ($file_content !~ s/(^=head\d NAME.*?(?=^=))/$1$version/sm) {
            die ('trying to add a POD VERSION section after NAME Section, but there is none');
        }

    }

    return $file_content;
}

1;

=head1 NAME

ShipIt::Step::ChangePodVersion - Keep VERSION in your Pod in sync with $VERSION

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Just add it to the ShipIt config maybe near the ChangeVersion-Step

    steps = FindVersion, ChangeVersion, ChangePodVersion, CheckChangeLog, ...

And make sure you have a VERSION or at least a NAME section in your Pod.

    =head1 VERSION

    version 123

=head1 DESCRIPTION

This is a Step for ShipIt to keep your Pod VERSION in sync with your $VERSION.
If a VERSION section is discovered in your Pod, it is tried to find and replace
numbers or "." or "_" with your new version.

You can write whatever you want before your version-number, but make sure it
does not contain numbers or "." or "_".

In case no VERSION section is found, a VERSION section is created after the
NAME section. If no NAME section is found, we die.

=head1 AUTHOR

Thomas Mueller, C<< <tmueller at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-shipit-step-changepodversion at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=ShipIt-Step-ChangePodVersion>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ShipIt::Step::ChangePodVersion


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=ShipIt-Step-ChangePodVersion>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/ShipIt-Step-ChangePodVersion>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/ShipIt-Step-ChangePodVersion>

=item * Search CPAN

L<http://search.cpan.org/dist/ShipIt-Step-ChangePodVersion/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Thomas Mueller.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut
