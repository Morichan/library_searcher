package lib::LibrarySearcher;

use Mouse;
use CGI;

use lib::Title;
use lib::Author;
use lib::ISBN;
use lib::Publisher;
use lib::ResultArea;

has q => ( is => "rw" );
has left => ( is => "ro", default => "float: left;" );
has right => ( is => "ro", default => "float: right;" );
has title => ( is => "rw" );
has author => ( is => "rw" );
has isbn => ( is => "rw" );
has publisher => ( is => "rw" );
has result_area => ( is => "rw" );

sub BUILD {
    my $self = shift;

    $self->q(CGI->new);
    $self->title(lib::Title->new);
    $self->author(lib::Author->new);
    $self->isbn(lib::ISBN->new);
    $self->publisher(lib::Publisher->new);
    $self->result_area(lib::ResultArea->new);
}

sub show {
    my $self = shift;

    $self->containts($self->searchbox, $self->result);
}

sub containts {
    my $self = shift;
    my $containts = \@_;

    print $self->q->start_div( {-class => "containts"} );

    foreach (@$containts) {
        print $_;
    }

    print $self->q->end_div;
}

sub searchbox {
    my $self = shift;
    my $title = lib::Title->new;
    my $author = lib::Author->new;
    my $isbn = lib::ISBN->new;
    my $publisher = lib::Publisher->new;

    return (
        $self->q->start_div( {-class => "searchbox"} ),
        $self->q->start_form( -method => "POST" ),
        $self->title->show,
        $self->author->show,
        $self->isbn->show,
        $self->publisher->show,
        $self->q->end_form,
        $self->q->end_div,
        "\n\n");
}

sub result {
    my $self = shift;
    my $result_area = lib::ResultArea->new;

    return (
        $self->q->start_div( {-class => "result"} ),
        $self->q->start_form( -method => "POST" ),
        $self->result_area->show,
        $self->q->end_form,
        $self->q->end_div,
        "\n\n");
}

sub style {
    my $self = shift;

    my $text .= ".searchbox {\n";
    $text .= "  " . $self->left . "\n";
    $text .= "}\n";
    $text .= ".result {\n";
    $text .= "  " . $self->left . "\n";
    $text .= "}\n";
    $text .= "form {\n";
    $text .= "  margin-inline-start: 1em;\n";
    $text .= "  margin-inline-end: 1em;\n";
    $text .= "}\n";
    $text .= ".textfield {\n";
    $text .= "  margin-top: 0.5em;\n";
    $text .= "  margin-bottom: 0.5em;\n";
    $text .= "}\n";

    return $text;
}

1;
