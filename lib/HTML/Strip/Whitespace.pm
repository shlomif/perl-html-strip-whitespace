package HTML::Strip::Whitespace;

package HTML::Strip::Whitespace::State;

sub new
{
    my $class = shift;
    my $self = {};
    bless $self, $class;
    $self->initialize(@_);
    return $self;
}

sub to_array
{
    my $v = shift;
    return (ref($v) eq "ARRAY" ? (@$v) : $v);
}

sub initialize
{
    my $self = shift;
    my %args = (@_);
    $self->{'prev'} = undef;
    $self->{'next'} = undef;
    $self->{'this'} = undef;
    $self->{'parser'} = 
        HTML::TokeParser::Simple->new(
            to_array($args{'parser_args'})
        );

    $self->{'strip_newlines'} = $args{'strip_newlines'} || 0;
    $self->{'out'} = $args{'out_callback'};

    # Get the first element to initialize the parser
    # Otherwise the first call to next_state would return undef;
    $self->next_state();

    return 0;
}

sub next_state
{
    my $self = shift;
    ($self->{'prev'}, $self->{'this'}, $self->{'next'}) = 
        ($self->{'this'}, $self->{'next'}, $self->{'parser'}->get_token());
    if (!defined($self->{'this'}))
    {
        return undef;
    }
    return 1;
}

sub prev
{
    my $self = shift;
    return $self->{'prev'};
}

sub next
{
    my $self = shift;
    return $self->{'next'};
}

sub this
{
    my $self = shift;
    return $self->{'this'};
}

sub text_strip
{
    my $self = shift;

    # my $p = $self->prev();
    # my $n = $self->next();

    my $text = $self->this()->as_is();

    $text =~ s{([\s\n]+)}{($1 =~ /\n/) ? "\n" : " "}eg;

    return $text;
}

my %preserving_start_tags =
(
    'pre' => 1,
);

sub is_preserving_start_tag
{
    my $self = shift;
    my $t = $self->this();
    if ($t->is_start_tag() && 
        exists($preserving_start_tags{$t->get_tag()})
       )
    {
        return $t->get_tag();
    }
    return undef;
}

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

@EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} });

@EXPORT = qw(
	
);

$VERSION = '0.1.3';

# Preloaded methods go here.

sub html_strip_whitespace
{
    my $source = shift;
    my $out_fh = shift;
    my %args = (@_);
    my $strip_newlines = $args{'strip_newlines'} || 0;

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

    my $state = 
        HTML::Strip::Whitespace::State->new(
            'parser_args' => $source,
            'strip_newlines' => $strip_newlines,
            'out_callback' => $out,
        );


    my $tag_type;

    while ($state->next_state())
    {
        if ($state->this->is_text())
        {
            $out->(
                $state->text_strip()
            );            
        }
        # If it's a preserving start tag, preserve all the text inside it.
        # This is for example, a <pre> tag in which the spaces matter.
        elsif ($tag_type = $state->is_preserving_start_tag())
        {
            my $do_once = 1;
            while ($do_once || $state->next_state())
            {
                $do_once = 0;
                $out->(
                    $state->this()->as_is()
                );
                last if ($state->this()->is_end_tag($tag_type))
            }
        }
        else
        {
            $out->($state->this()->as_is());
        }
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
