package HTML::Strip::Whitespace;

use 5.004;
use strict;

use HTML::TokeParser::Simple;

require Exporter;
use AutoLoader qw(AUTOLOAD);
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
@ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use HTML::Strip::Whitespace ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
%EXPORT_TAGS = ( 'all' => [ qw(
	html_strip_whitespace
) ] );

@EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

@EXPORT = qw(
	
);

$VERSION = '0.1.0';

# Preloaded methods go here.

sub html_strip_whitespace
{
    my $source = shift;
    my $out_fh = shift;
    my %args = (@_);
    my $strip_newlines = $args{'strip_newlines'} || 0;
    
    my $parser = HTML::TokeParser::Simple->new($source);

    my $out = sub {
        my $what = shift;
        if (ref($out_fh) eq "CODE")
        {
            &{$out_fh}($what);
        }
        elsif (ref($out_fh) eq "SCALAR")
        {
            $$out_fh .= $what;
        }
        elsif (ref($out_fh) eq "GLOB")
        {
            print {*{$out_fh}} $what;
        }
    };

    my $token;
    while ($token = $parser->get_token)
    {
        $out->($token->as_is());
    }

    # Return 0 on success.
    return 0;
}


# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

HTML::Strip::Whitespace - Perl extension for blah blah blah

=head1 SYNOPSIS

  use HTML::Strip::Whitespace;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for HTML::Strip::Whitespace, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Shlomi Fish, E<lt>shlomi@mandrakesoft.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Shlomi Fish

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.5 or,
at your option, any later version of Perl 5 you may have available.


=cut
