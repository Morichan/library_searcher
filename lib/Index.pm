package lib::Index;

use Mouse;
use CGI;

use lib::LibrarySearcher;

has q => ( is => "rw" );
has library_searcher => ( is => "rw" );

sub BUILD {
    my $self = shift;

    $self->q(CGI->new);
    $self->library_searcher(lib::LibrarySearcher->new);
}

sub show {
    my $self = shift;

    $self->header;
    $self->start;
    # $self->h1("Hello");

    $self->library_searcher->show;

    $self->end;
}

sub header {
    my $self = shift;

    print $self->q->header( -charset => "utf-8" );
}

sub start {
    my $self = shift;

    print $self->q->start_html(
        -title => "title",
        -style => { -code => $self->library_searcher->style },
        -lang => "ja",
        -encoding => "utf-8" );
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
