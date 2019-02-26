package Index;

use Mouse;
use CGI;

use lib::Param;

has q => ( is => "rw" );
has param => ( is => "rw" );

sub create {
    my $self = shift;

    $self->q(CGI->new);
    $self->param(Param->new);
}

sub show {
    my $self = shift;

    $self->header;
    $self->start;
    $self->h1("Hello");

    $self->param->create;

    $self->end;
}

sub header {
    my $self = shift;

    print $self->q->header( -charset => "utf-8" );
}

sub start {
    my $self = shift;

    print $self->q->start_html( -title => "title", -lang => "ja", -encoding => "utf-8" );
}

sub end {
    my $self = shift;

    print $self->q->end_html();
}

sub h1 {
    my $self = shift;
    my $text = shift;

    print $self->q->h1($text);
    print "\n";
}

1;
